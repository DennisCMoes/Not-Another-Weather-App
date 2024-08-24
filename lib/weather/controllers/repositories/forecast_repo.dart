import 'dart:async';

import 'package:not_another_weather_app/main.dart';
import 'package:not_another_weather_app/menu/models/units.dart';
import 'package:not_another_weather_app/objectbox.g.dart';
import 'package:not_another_weather_app/shared/utilities/controllers/api_controller.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/weather/forecast/daily_weather.dart';
import 'package:not_another_weather_app/weather/models/weather/forecast/hourly_weather.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForecastRepo {
  final String _baseUrl = "https://api.open-meteo.com/v1";
  final ApiController _apiController = ApiController();

  Future<Forecast> getForecastOfLocation(Geocoding geocode) async {
    Completer<Forecast> completer = Completer();
    _getForecast(geocode, completer);
    return completer.future;
  }

  Future<void> _getForecast(Geocoding geocode, Completer completer) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      var temperature = TemperatureUnit
          .values[prefs.getInt("temperature_unit") ?? 1]; // Celsius
      var windSpeed =
          WindspeedUnit.values[prefs.getInt("wind_speed_unit") ?? 1]; // "KM/H"
      var precipitation = PrecipitationUnit
          .values[prefs.getInt("precipitation_unit") ?? 0]; // Millimeters

      Forecast data = await _apiController.getRequest<Forecast>(
        "$_baseUrl/forecast",
        parameters: Map.from(
          {
            "latitude": geocode.latitude,
            "longitude": geocode.longitude,
            "timezone": "auto",
            "forecast_days": 1,
            "past_days": 1,
            "temperature_unit": temperature.value,
            "wind_speed_unit": windSpeed.value,
            "precipitation_unit": precipitation.value,
            "current": [
              "surface_pressure",
            ].join(","),
            "hourly": [
              "temperature_2m",
              "apparent_temperature",
              "relative_humidity_2m",
              "precipitation_probability",
              "precipitation",
              "weather_code",
              "cloud_cover",
              "wind_speed_10m",
              "wind_direction_10m",
              "wind_gusts_10m",
            ].join(","),
            "daily": [
              "sunrise",
              "sunset",
              "uv_index_max",
              "uv_index_clear_sky_max",
            ].join(","),
          },
        ),
        (json) => Forecast.fromJson(json),
      );

      completer.complete(data);
    } catch (exception, stacktrace) {
      completer.completeError(exception, stacktrace);
    }
  }

  List<Forecast> getAllForecastsFromBox() {
    final forecastBox = objectBox.forecastBox;
    return forecastBox.getAll();
  }

  Forecast getForecastById(int id) {
    final forecastBox = objectBox.forecastBox;
    final hourlyBox = objectBox.hourlyBox;
    final dailyBox = objectBox.dailyBox;

    // TODO: Add a check to see if the forecast is null
    Forecast forecast = forecastBox.get(id)!;

    Query<HourlyWeatherData> hourlyIdQuery =
        hourlyBox.query(HourlyWeatherData_.forecast.equals(id)).build();

    Query<DailyWeatherData> dailyIdQuery =
        dailyBox.query(DailyWeatherData_.forecast.equals(id)).build();

    final hourlyList =
        hourlyBox.getMany(hourlyIdQuery.findIds()).map((e) => e!).toList();
    final dailyList =
        dailyBox.getMany(dailyIdQuery.findIds()).map((e) => e!).toList();

    forecast.hourlyWeatherList = hourlyList;
    forecast.dailyWeatherDataList = dailyList;

    return forecast;
  }

  void updateForecasts(List<Forecast> forecasts) {
    final forecastBox = objectBox.forecastBox;
    forecastBox.putMany(forecasts);
  }

  void storeForecast(Forecast forecast) {
    final forecastBox = objectBox.forecastBox;
    final hourlyBox = objectBox.hourlyBox;
    final dailyBox = objectBox.dailyBox;

    hourlyBox.putMany(forecast.hourlyWeatherList);
    dailyBox.putMany(forecast.dailyWeatherDataList);

    forecastBox.put(forecast);
  }

  void deleteAllHourly(int forecastId) {
    final hourlyBox = objectBox.hourlyBox;

    Query<HourlyWeatherData> query =
        hourlyBox.query(HourlyWeatherData_.forecast.equals(forecastId)).build();

    hourlyBox.removeMany(query.findIds());
  }

  void deleteAllDaily(int forecastId) {
    final dailyBox = objectBox.dailyBox;

    Query<DailyWeatherData> query =
        dailyBox.query(DailyWeatherData_.forecast.equals(forecastId)).build();

    dailyBox.removeMany(query.findIds());
  }
}
