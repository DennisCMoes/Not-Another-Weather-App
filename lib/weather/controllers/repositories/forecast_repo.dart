import 'package:not_another_weather_app/menu/models/units.dart';
import 'package:not_another_weather_app/shared/utilities/controllers/api_controller.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForecastRepo {
  final String _baseUrl = "https://api.open-meteo.com/v1";
  final ApiController _apiController = ApiController();

  Future<Forecast> getForecastOfLocation(
      double latitude, double longitude) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var temperature = TemperatureUnit
        .values[prefs.getInt("temperature_unit") ?? 1]; // Celsius
    var windSpeed =
        WindspeedUnit.values[prefs.getInt("wind_speed_unit") ?? 1]; // "KM/H"
    var precipitation = PrecipitationUnit
        .values[prefs.getInt("precipitation_unit") ?? 0]; // Millimeters

    return _apiController.getRequest(
      "$_baseUrl/forecast",
      parameters: Map.from(
        {
          "latitude": latitude,
          "longitude": longitude,
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
  }
}
