import 'package:not_another_weather_app/shared/utilities/controllers/api_controller.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';

class ForecastRepo {
  final String _baseUrl = "https://api.open-meteo.com/v1";
  final ApiController _apiController = ApiController();

  Future<Forecast> getLocalForecast(double latitude, double longitude) {
    return _apiController.getRequest(
      "$_baseUrl/forecast",
      parameters: Map.from(
        {
          "latitude": latitude,
          "longitude": longitude,
          "timezone": "auto",
          "forecast_days": 1,
          "current": [
            "temperature_2m",
            "relative_humidity_2m",
            "precipitation",
            "weather_code",
            "wind_speed_10m",
            "surface_pressure",
            "apparent_temperature",
            "cloud_cover",
            "wind_direction_10m",
            "wind_gusts_10m",
            "is_day",
          ].join(","),
          "hourly": [
            "temperature_2m",
            "precipitation_probability",
            "precipitation"
          ].join(","),
          "daily": ["sunrise", "sunset"].join(","),
        },
      ),
      (json) => Forecast.fromJson(json),
    );
  }

  Future<Forecast> getForecast() {
    return _apiController.getRequest(
      "$_baseUrl/forecast",
      parameters: Map.from(
        {
          "latitude": "52.52",
          "longitude": "13.41",
          "current": [
            "temperature_2m",
            "relative_humidity_2m",
            "precipitation",
            "weather_code",
            "wind_speed_10m"
          ].join(","),
          "hourly": ["temperature_2m"].join(","),
          "forecast_days": 1,
        },
      ),
      (x) => Forecast.fromJson(x),
    );
  }
}
