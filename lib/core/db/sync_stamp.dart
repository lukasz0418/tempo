import 'package:uuid/uuid.dart';

/// Pomocnik do kolumn synchronizacyjnych.
///
/// Każdy zapis lokalny musi odświeżyć `updatedAt` i ustawić `dirty`.
/// Gdyby to zostawić DAO-som, prędzej czy później któryś zapis by o tym
/// zapomniał i wiersz po cichu nie pojechałby na serwer — a taki błąd
/// zauważa się dopiero, gdy czegoś brakuje na drugim urządzeniu.
class SyncStamp {
  const SyncStamp._();

  static const _uuid = Uuid();

  /// UUID v4 generowany **na kliencie**, jeszcze przed jakimkolwiek
  /// kontaktem z serwerem. To warunek pracy offline: bez tego trzeba by
  /// czekać na klucz z bazy zdalnej albo przepisywać relacje po synchronizacji.
  static String newId() => _uuid.v4();

  static DateTime now() => DateTime.now().toUtc();
}
