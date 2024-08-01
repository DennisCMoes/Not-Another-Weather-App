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
          "forecast_days": 2,
          "current": [
            "surface_pressure",
            "is_day",
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
  }
}
