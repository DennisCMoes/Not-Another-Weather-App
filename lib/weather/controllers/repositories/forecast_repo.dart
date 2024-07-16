import 'package:weather/shared/controllers/api_controller.dart';
import 'package:weather/weather/models/forecast.dart';

class ForecastRepo {
  final String _baseUrl = "https://api.open-meteo.com/v1";
  final ApiController _apiController = ApiController();

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
