import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
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
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      IUnit temperature = // Celsius
          TemperatureUnit.values[prefs.getInt("temperature_unit") ?? 1];
      IUnit windSpeed = // "KM/H"
          WindspeedUnit.values[prefs.getInt("wind_speed_unit") ?? 1];
      IUnit precipitation = // Millimeters
          PrecipitationUnit.values[prefs.getInt("precipitation_unit") ?? 0];

      Forecast data = await _apiController.getRequest<Forecast>(
        "$_baseUrl/forecast",
        parameters: {
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
        (json) => Forecast.fromJson(json),
      );

      data.id = geocode.id;
      storeForecast(data);
      return data;
    } catch (exception) {
      debugPrint("Error fetching forecast from API: $exception");
      return Forecast.noInternet();
    }
  }

  /// Retrieves the forecast from local storage or returns a fallback if not available
  Forecast getForecastFromPersistedStorage(Geocoding geocode) {
    try {
      final forecastBox = objectBox.forecastBox;
      final hourlyBox = objectBox.hourlyBox;
      final dailyBox = objectBox.dailyBox;

      // TODO: Add a null check mechanism
      Forecast? forecast = forecastBox.get(geocode.id);

      if (forecast == null) {
        return Forecast.noInternet();
      }

      forecast.hourlyWeatherList = _getWeatherDataList(
        geocode.id,
        hourlyBox,
        HourlyWeatherData_.forecast.equals(geocode.id),
      );
      forecast.dailyWeatherDataList = _getWeatherDataList(
        geocode.id,
        dailyBox,
        DailyWeatherData_.forecast.equals(geocode.id),
      );

      return forecast;
    } catch (exception) {
      debugPrint("Error fetching forecast from storage: $exception");
      return Forecast.noInternet();
    }
  }

  /// Attempts to fetch forecast data by geocoding ID
  Future<Forecast> getForecastById(Geocoding geocode) async {
    try {
      return await _getForecastFromApi(geocode);
    } on DioException {
      return getForecastFromPersistedStorage(geocode);
    } catch (exception) {
      // TODO: Change to generic forecast
      debugPrint(
          "Something went wrong fetching the forecast by ID: $exception");
      return await _getForecastFromApi(geocode);
    }
  }

  void storeForecast(Forecast forecast) {
    try {
      final forecastBox = objectBox.forecastBox;
      final hourlyBox = objectBox.hourlyBox;
      final dailyBox = objectBox.dailyBox;

      _deleteAllSubData<DailyWeatherData>(
          dailyBox, DailyWeatherData_.forecast.equals(forecast.id));
      _deleteAllSubData<HourlyWeatherData>(
          hourlyBox, HourlyWeatherData_.forecast.equals(forecast.id));

      hourlyBox.putMany(forecast.hourlyWeatherList);
      dailyBox.putMany(forecast.dailyWeatherDataList);
      forecastBox.put(forecast);
    } catch (exception) {
      debugPrint("Error storing forecast data: $exception");
      rethrow;
    }
  }

  void _deleteAllSubData<T>(
    Box<T> box,
    Condition<T> condition,
  ) {
    try {
      final Query<T> query = box.query(condition).build();
      box.removeMany(query.findIds());
      query.close();
    } catch (exception) {
      debugPrint("Error deleting the subdata: $exception");
    }
  }

  /// Generic method to fetch weather data lists from storage
  List<T> _getWeatherDataList<T>(
    int geocodeId,
    Box<T> box,
    Condition<T> condition,
  ) {
    final Query<T> query = box.query(condition).build();
    final List<T> dataList =
        box.getMany(query.findIds()).whereType<T>().toList();
    query.close();
    return dataList;
  }
}
