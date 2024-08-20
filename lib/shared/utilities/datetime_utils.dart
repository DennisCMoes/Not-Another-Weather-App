import 'package:not_another_weather_app/weather/views/painters/line_chart.dart';
import 'package:timezone/timezone.dart' as tz;

class DatetimeUtils {
  static DateTime convertToTimezone(DateTime datetime, String targetTimezone) {
    final timezone = tz.getLocation(targetTimezone);
    return tz.TZDateTime.from(datetime, timezone);
  }

  static DateTime startOfHour([DateTime? date]) {
    date ??= DateTime.now().toUtc();
    return DateTime.utc(date.year, date.month, date.day, date.hour);
  }

  static DateTime startOfDay([DateTime? date]) {
    date ??= DateTime.now().toUtc();
    return DateTime.utc(date.year, date.month, date.day);
  }

  static DateTime withOffset(int offsetInHours) {
    return DatetimeUtils.startOfHour().add(Duration(hours: offsetInHours));
  }
}
