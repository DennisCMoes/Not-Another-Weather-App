import 'dart:async';

import 'package:dio/dio.dart';
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

  Future<Forecast> _getForecastFromApi(Geocoding geocode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var temperature = // Celsius
        TemperatureUnit.values[prefs.getInt("temperature_unit") ?? 1];
    var windSpeed = // "KM/H"
        WindspeedUnit.values[prefs.getInt("wind_speed_unit") ?? 1];
    var precipitation = // Millimeters
        PrecipitationUnit.values[prefs.getInt("precipitation_unit") ?? 0];

    Forecast data = await _apiController.getRequest<Forecast>(
      "$_baseUrl/forecast",
      parameters: Map.from(
        {
          "latitude": geocode.latitude,
          "longitude": geocode.longitude,
          "timezone": "auto",
          "forecast_days": 2,
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

    data.id = geocode.id;

    storeForecast(data);
    return data;
  }

  Forecast getForecastFromPersistedStorage(Geocoding geocode) {
    final forecastBox = objectBox.forecastBox;
    final hourlyBox = objectBox.hourlyBox;
    final dailyBox = objectBox.dailyBox;

    // TODO: Add a null check mechanism
    Forecast? forecast = forecastBox.get(geocode.id);

    if (forecast == null) {
      return Forecast.noInternet();
    }

    forecast.hourlyWeatherList = _getWeatherDataList(
        geocode.id, hourlyBox, HourlyWeatherData_.forecast.equals(geocode.id));
    forecast.dailyWeatherDataList = _getWeatherDataList(
        geocode.id, dailyBox, DailyWeatherData_.forecast.equals(geocode.id));

    return forecast;
  }

  List<T> _getWeatherDataList<T>(
      int geocodeId, Box<T> box, Condition<T> condition) {
    final Query<T> query = box.query(condition).build();
    final List<T> dataList =
        box.getMany(query.findIds()).whereType<T>().toList();
    query.close();
    return dataList;
  }

  Future<Forecast> getForecastById(Geocoding geocode) async {
    try {
      return await _getForecastFromApi(geocode);
    } on DioException {
      return getForecastFromPersistedStorage(geocode);
    } on Exception {
      // TODO: Change to generic forecast
      return await _getForecastFromApi(geocode);
    }
  }

  void storeForecast(Forecast forecast) {
    final forecastBox = objectBox.forecastBox;
    final hourlyBox = objectBox.hourlyBox;
    final dailyBox = objectBox.dailyBox;

    deleteAllHourly(forecast.id);
    deleteAllDaily(forecast.id);

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
