import 'package:not_another_weather_app/shared/utilities/datetime_utils.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/weather/weather_code.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class HourlyWeatherData {
  @Id()
  int id = 0;

  @Property(type: PropertyType.date)
  DateTime time;

  int get dbTime => time.millisecondsSinceEpoch;
  set dbTime(int value) => time = DatetimeUtils.startOfHour(
      DateTime.fromMillisecondsSinceEpoch(value, isUtc: true));

  final double temperature;
  final double apparentTemperature;
  final int humidity;
  final int rainProbability;
  final double rainInMM;
  final int weatherCodeNum;
  final int cloudCover;
  final double windSpeed;
  final int windDirection;
  final double windGusts;

  final forecast = ToOne<Forecast>();

  WeatherCode get weatherCode => WeatherCode.fromCode(weatherCodeNum);

  @Transient()
  bool invalidData;

  HourlyWeatherData(
    this.time,
    this.temperature,
    this.apparentTemperature,
    this.humidity,
    this.rainProbability,
    this.rainInMM,
    this.weatherCodeNum,
    this.cloudCover,
    this.windSpeed,
    this.windDirection,
    this.windGusts, {
    this.invalidData = false,
  });

  static HourlyWeatherData invalidHour(DateTime time) {
    return HourlyWeatherData(time, -1, -1, -1, -1, -1, -2, -1, -1, -1, -1,
        invalidData: true);
  }
}
