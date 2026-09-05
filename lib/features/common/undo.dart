import 'package:flutter/material.dart';

/// Usunięcie z możliwością cofnięcia.
///
/// Przytrzymanie elementu kasujące go bez ostrzeżenia i bez odwrotu to
/// najprostszy sposób na utratę zapisanej myśli — a pomysł notuje się właśnie
/// wtedy, gdy nie chce się go stracić. Zamiast dialogu potwierdzenia
/// (który pyta *zanim* wiadomo, czy to pomyłka) pokazujemy pasek z „Cofnij":
/// operacja idzie od razu, a wycofanie jest jednym kliknięciem.
///
/// Działa wyłącznie dlatego, że kasowanie w tej aplikacji jest miękkie —
/// wiersz zostaje w bazie z flagą `deleted`, więc przywrócenie to zmiana
/// jednego pola, a nie odtwarzanie danych z niczego.
void showUndoSnackBar(
  BuildContext context, {
  required String message,
  required Future<void> Function() onUndo,
}) {
  final messenger = ScaffoldMessenger.of(context);

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        // Sześć sekund zamiast domyślnych czterech: jeśli skasowałeś coś
        // przez przypadek, potrzebujesz chwili, żeby to w ogóle zauważyć.
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: 'Cofnij',
          onPressed: () => onUndo(),
        ),
      ),
    );
}
