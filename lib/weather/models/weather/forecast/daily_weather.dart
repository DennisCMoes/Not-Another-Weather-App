import 'package:not_another_weather_app/shared/utilities/datetime_utils.dart';
import 'package:objectbox/objectbox.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';

@Entity()
class DailyWeatherData {
  @Id()
  int id = 0;

  @Property(type: PropertyType.date)
  DateTime time;

  int get dbTime => time.millisecondsSinceEpoch;
  set dbTime(int value) => time = DatetimeUtils.startOfDay(
      DateTime.fromMillisecondsSinceEpoch(value, isUtc: true));

  final DateTime sunrise;
  final DateTime sunset;
  final double uvIndex;
  final double clearSkyUvIndex;

  final forecast = ToOne<Forecast>();

  @Transient()
  bool invalidData;

  DailyWeatherData(
    this.time,
    this.sunrise,
    this.sunset,
    this.uvIndex,
    this.clearSkyUvIndex, {
    this.invalidData = false,
  });

  static DailyWeatherData invalidDay(DateTime time) {
    return DailyWeatherData(time, time, time, -1, -1, invalidData: false);
  }
}
