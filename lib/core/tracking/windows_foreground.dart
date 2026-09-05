import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import '../db/enums.dart';
import 'activity_tracker.dart';

/// Odczyt aktywnego okna na Windowsie przez surowe `dart:ffi`.
///
/// Świadomie bez pakietu `win32`: potrzebujemy sześciu funkcji, a pakiet
/// opakowuje je w typy (`HWND`, `PWSTR`, `Win32Result`), które zmieniają się
/// między wersjami major i przy każdej takiej zmianie trzeba by przepisywać
/// ten plik. Deklaracje poniżej są dosłownym odbiciem nagłówków WinAPI
/// i nie zestarzeją się razem z zależnością.

// LASTINPUTINFO — { UINT cbSize; DWORD dwTime; }
base class _LastInputInfo extends Struct {
  @Uint32()
  external int cbSize;

  @Uint32()
  external int dwTime;
}

// user32.dll
typedef _GetForegroundWindowNative = IntPtr Function();
typedef _GetForegroundWindowDart = int Function();

typedef _GetWindowTextNative = Int32 Function(
    IntPtr hWnd, Pointer<Utf16> lpString, Int32 nMaxCount);
typedef _GetWindowTextDart = int Function(
    int hWnd, Pointer<Utf16> lpString, int nMaxCount);

typedef _GetWindowTextLengthNative = Int32 Function(IntPtr hWnd);
typedef _GetWindowTextLengthDart = int Function(int hWnd);

typedef _GetWindowThreadProcessIdNative = Uint32 Function(
    IntPtr hWnd, Pointer<Uint32> lpdwProcessId);
typedef _GetWindowThreadProcessIdDart = int Function(
    int hWnd, Pointer<Uint32> lpdwProcessId);

typedef _GetLastInputInfoNative = Int32 Function(Pointer<_LastInputInfo> plii);
typedef _GetLastInputInfoDart = int Function(Pointer<_LastInputInfo> plii);

// kernel32.dll
typedef _OpenProcessNative = IntPtr Function(
    Uint32 dwDesiredAccess, Int32 bInheritHandle, Uint32 dwProcessId);
typedef _OpenProcessDart = int Function(
    int dwDesiredAccess, int bInheritHandle, int dwProcessId);

typedef _QueryFullProcessImageNameNative = Int32 Function(
    IntPtr hProcess,
    Uint32 dwFlags,
    Pointer<Utf16> lpExeName,
    Pointer<Uint32> lpdwSize);
typedef _QueryFullProcessImageNameDart = int Function(
    int hProcess, int dwFlags, Pointer<Utf16> lpExeName, Pointer<Uint32> lpdwSize);

typedef _CloseHandleNative = Int32 Function(IntPtr hObject);
typedef _CloseHandleDart = int Function(int hObject);

typedef _GetTickCountNative = Uint32 Function();
typedef _GetTickCountDart = int Function();

/// Minimalne prawo dostępu wystarczające do odczytania ścieżki pliku
/// wykonywalnego. Celowo nie `PROCESS_QUERY_INFORMATION`: szersze prawo
/// bywa odmawiane dla procesów podniesionych i wtedy tracimy nazwę okna
/// dla wszystkiego, co uruchomione jako administrator.
const _processQueryLimitedInformation = 0x1000;

const _maxPath = 32768;

class WindowsForegroundReader implements PollingTracker {
  WindowsForegroundReader._({
    required DynamicLibrary user32,
    required DynamicLibrary kernel32,
  })  : _getForegroundWindow = user32.lookupFunction<
            _GetForegroundWindowNative, _GetForegroundWindowDart>(
            'GetForegroundWindow'),
        _getWindowText =
            user32.lookupFunction<_GetWindowTextNative, _GetWindowTextDart>(
                'GetWindowTextW'),
        _getWindowTextLength = user32.lookupFunction<
            _GetWindowTextLengthNative,
            _GetWindowTextLengthDart>('GetWindowTextLengthW'),
        _getWindowThreadProcessId = user32.lookupFunction<
            _GetWindowThreadProcessIdNative,
            _GetWindowThreadProcessIdDart>('GetWindowThreadProcessId'),
        _getLastInputInfo = user32.lookupFunction<_GetLastInputInfoNative,
            _GetLastInputInfoDart>('GetLastInputInfo'),
        _openProcess =
            kernel32.lookupFunction<_OpenProcessNative, _OpenProcessDart>(
                'OpenProcess'),
        _queryFullProcessImageName = kernel32.lookupFunction<
            _QueryFullProcessImageNameNative,
            _QueryFullProcessImageNameDart>('QueryFullProcessImageNameW'),
        _closeHandle =
            kernel32.lookupFunction<_CloseHandleNative, _CloseHandleDart>(
                'CloseHandle'),
        _getTickCount =
            kernel32.lookupFunction<_GetTickCountNative, _GetTickCountDart>(
                'GetTickCount');

  factory WindowsForegroundReader() {
    return WindowsForegroundReader._(
      user32: DynamicLibrary.open('user32.dll'),
      kernel32: DynamicLibrary.open('kernel32.dll'),
    );
  }

  final _GetForegroundWindowDart _getForegroundWindow;
  final _GetWindowTextDart _getWindowText;
  final _GetWindowTextLengthDart _getWindowTextLength;
  final _GetWindowThreadProcessIdDart _getWindowThreadProcessId;
  final _GetLastInputInfoDart _getLastInputInfo;
  final _OpenProcessDart _openProcess;
  final _QueryFullProcessImageNameDart _queryFullProcessImageName;
  final _CloseHandleDart _closeHandle;
  final _GetTickCountDart _getTickCount;

  @override
  DevicePlatform get platform => DevicePlatform.windows;

  @override
  Future<bool> isAvailable() async => Platform.isWindows;

  /// Windows nie wymaga żadnych zgód na odczyt aktywnego okna
  /// dla procesów tego samego użytkownika.
  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<void> requestPermission() async {}

  @override
  Future<ForegroundInfo?> current() async {
    final hwnd = _getForegroundWindow();
    if (hwnd == 0) return null; // ekran blokady albo brak aktywnego okna

    final title = _readWindowTitle(hwnd);
    final exePath = _readProcessPath(hwnd);
    if (exePath == null) return null;

    final appId = exePath.split(r'\').last;

    return ForegroundInfo(
      appId: appId,
      appName: _prettyName(appId),
      windowTitle: title.isEmpty ? null : title,
      idleFor: _idleTime(),
    );
  }

  String _readWindowTitle(int hwnd) {
    final length = _getWindowTextLength(hwnd);
    if (length <= 0) return '';

    final buffer = calloc<Uint16>(length + 1).cast<Utf16>();
    try {
      final written = _getWindowText(hwnd, buffer, length + 1);
      return written <= 0 ? '' : buffer.toDartString();
    } finally {
      calloc.free(buffer);
    }
  }

  String? _readProcessPath(int hwnd) {
    final pidPtr = calloc<Uint32>();
    try {
      _getWindowThreadProcessId(hwnd, pidPtr);
      final pid = pidPtr.value;
      if (pid == 0) return null;

      final handle =
          _openProcess(_processQueryLimitedInformation, 0 /* FALSE */, pid);
      if (handle == 0) return null;

      final sizePtr = calloc<Uint32>()..value = _maxPath;
      final pathBuffer = calloc<Uint16>(_maxPath).cast<Utf16>();
      try {
        final ok = _queryFullProcessImageName(handle, 0, pathBuffer, sizePtr);
        return ok == 0 ? null : pathBuffer.toDartString();
      } finally {
        calloc.free(pathBuffer);
        calloc.free(sizePtr);
        _closeHandle(handle);
      }
    } finally {
      calloc.free(pidPtr);
    }
  }

  /// Czas od ostatniego ruchu myszy albo klawisza.
  ///
  /// `LASTINPUTINFO.dwTime` i `GetTickCount` to 32-bitowe liczniki
  /// milisekund, które przekręcają się po ~49 dniach. Maska poniżej
  /// sprawia, że w momencie przekręcenia wyjdzie mała dodatnia różnica,
  /// a nie ujemna albo absurdalnie wielka.
  Duration _idleTime() {
    final info = calloc<_LastInputInfo>();
    try {
      info.ref.cbSize = sizeOf<_LastInputInfo>();
      if (_getLastInputInfo(info) == 0) return Duration.zero;

      final elapsed = (_getTickCount() - info.ref.dwTime) & 0xFFFFFFFF;
      return Duration(milliseconds: elapsed);
    } finally {
      calloc.free(info);
    }
  }

  /// `Code.exe` → `Code`, `WINWORD.EXE` → `Winword`.
  ///
  /// Tylko kosmetyka na potrzeby list w UI. Reguły dopasowują się
  /// do surowego [ForegroundInfo.appId], więc ta funkcja nie może
  /// wpłynąć na klasyfikację.
  static String _prettyName(String exe) {
    final base = exe.toLowerCase().endsWith('.exe')
        ? exe.substring(0, exe.length - 4)
        : exe;
    if (base.isEmpty) return exe;
    return base[0].toUpperCase() + base.substring(1);
  }
}
