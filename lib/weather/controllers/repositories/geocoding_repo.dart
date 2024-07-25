import 'package:not_another_weather_app/shared/utilities/controllers/api_controller.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';

class GeocodingRepo {
  final String _baseUrl = "https://geocoding-api.open-meteo.com/v1";
  final ApiController _apiController = ApiController();

  Future<List<Geocoding>> getGeocodings(String searchValue) async {
    final Map<String, dynamic> data = await _apiController.getRawRequest(
      "$_baseUrl/search",
      parameters: {
        "name": searchValue,
        "count": 10,
      },
    );

    if (!data.containsKey("results")) {
      return [];
    } else {
      return List.from(data['results'])
          .map((e) => Geocoding.fromJson(e))
          .toList();
    }
  }
}
