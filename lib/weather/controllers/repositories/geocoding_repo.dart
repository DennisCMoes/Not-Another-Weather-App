import 'package:not_another_weather_app/main.dart';
import 'package:not_another_weather_app/shared/utilities/controllers/api_controller.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';

class GeocodingRepo {
  final String _baseUrl = "https://geocoding-api.open-meteo.com/v1";
  final ApiController _apiController = ApiController();

  List<Geocoding> _getAllGeocodingsFromBox() {
    final geocodingBox = objectBox.geocodingBox;
    return geocodingBox.getAll();
  }

  void _saveGeocodingsToBox(List<Geocoding> geocodings) {
    final geocodingBox = objectBox.geocodingBox;
    geocodingBox.putMany(geocodings);
  }

  bool _areGeocodingsEqual(List<Geocoding> list1, List<Geocoding> list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[2]) return false;
    }

    return true;
  }

  void storeGeocoding(Geocoding geocoding) {
    final geocodingBox = objectBox.geocodingBox;
    geocodingBox.put(geocoding);
  }

  void removeGeocoding(int id) {
    final geocodingBox = objectBox.geocodingBox;
    geocodingBox.remove(id);
  }

  List<Geocoding> getStoredGeocodings() {
    return _getAllGeocodingsFromBox();
  }

  Future<List<Geocoding>> searchGeocodings(String searchValue) async {
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
      List<Geocoding> searchedGeocodings =
          List.from(data['results']).map((e) => Geocoding.fromJson(e)).toList();
      return searchedGeocodings;
    }
  }

  Future<List<Geocoding>> getGeocodings(String searchValue) async {
    final storedGeocodings = _getAllGeocodingsFromBox();

    final Map<String, dynamic> data = await _apiController.getRawRequest(
      "$_baseUrl/search",
      parameters: {
        "name": searchValue,
        "count": 10,
      },
    );

    if (!data.containsKey("results")) {
      return storedGeocodings;
    } else {
      List<Geocoding> newGeocodings =
          List.from(data['results']).map((e) => Geocoding.fromJson(e)).toList();

      if (_areGeocodingsEqual(storedGeocodings, newGeocodings)) {
        _saveGeocodingsToBox(newGeocodings);
      }

      return newGeocodings;
    }
  }
}
