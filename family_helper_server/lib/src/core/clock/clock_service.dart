class ClockService {
  const ClockService();

  DateTime nowUtc() => DateTime.now().toUtc();
}
