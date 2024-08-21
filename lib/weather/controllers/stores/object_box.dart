import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/weather/forecast/daily_weather.dart';
import 'package:not_another_weather_app/weather/models/weather/forecast/hourly_weather.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:not_another_weather_app/objectbox.g.dart';

class ObjectBox {
  late final Store _store;

  late final Box<Forecast> _forecastBox;
  late final Box<Geocoding> _geocodingBox;
  late final Box<HourlyWeatherData> _hourlyBox;
  late final Box<DailyWeatherData> _dailyBox;

  ObjectBox._create(this._store) {
    _geocodingBox = Box<Geocoding>(_store);
    _forecastBox = Box<Forecast>(_store);
    _hourlyBox = Box<HourlyWeatherData>(_store);
    _dailyBox = Box<DailyWeatherData>(_store);
  }

  Box<Geocoding> get geocodingBox => _geocodingBox;
  Box<Forecast> get forecastBox => _forecastBox;
  Box<HourlyWeatherData> get hourlyBox => _hourlyBox;
  Box<DailyWeatherData> get dailyBox => _dailyBox;

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(
      directory: p.join(docsDir.path, 'obx-example'),
    );

    return ObjectBox._create(store);
  }
}
