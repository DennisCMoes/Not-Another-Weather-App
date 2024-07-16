import 'package:weather/shared/utilities/controllers/api_controller.dart';
import 'package:weather/weather/models/forecast.dart';

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
          "current": [
            "temperature_2m",
            "relative_humidity_2m",
            "precipitation",
            "weather_code",
            "wind_speed_10m"
          ].join(","),
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
        },
      ),
      (x) => Forecast.fromJson(x),
    );
  }
}
