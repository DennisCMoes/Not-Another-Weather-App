import 'package:instant/instant.dart';

class DatetimeUtils {
  static DateTime convertToTimezone(DateTime datetime, String targetTimezone) {
    return dateTimeToZone(
      datetime: datetime,
      zone: targetTimezone,
    );
  }

  static DateTime startOfHour([DateTime? date]) {
    date ??= DateTime.now().toUtc();
    return DateTime.utc(date.year, date.month, date.day, date.hour);
  }

  static DateTime startOfDay([DateTime? date]) {
    date ??= DateTime.now().toUtc();
    return DateTime.utc(date.year, date.month, date.day);
  }
}
