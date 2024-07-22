import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'dart:math';

import 'package:not_another_weather_app/weather/models/weather_code.dart';

class Geocoding {
  final int id;
  String name;
  double latitude;
  double longitude;
  String country;

  Forecast? forecast;

  Geocoding(this.id, this.name, this.latitude, this.longitude, this.country);

  factory Geocoding.fromJson(Map<String, dynamic> json) {
    return Geocoding(
      json['id'],
      json['name'],
      json['latitude'],
      json['longitude'],
      json['country'],
    );
  }

  static List<Geocoding> sampleData() {
    var random = Random();

    var items = [
      Geocoding(2759794, 'Amsterdam', 52.37403, 4.88969, "Netherlands"),
      Geocoding(2911298, 'Hamburg', 53.55073, 9.99302, 'Germany'),
      Geocoding(2514256, 'Málaga', 36.72016, -4.42034, 'Spain'),
      Geocoding(3413829, 'Reykjavik', 64.13548, -21.89541, 'Iceland'),
      Geocoding(2825297, 'Stuttgart', 48.78232, 9.17702, 'Germany'),
      Geocoding(2791537, 'Mechelen', 51.02574, 4.47762, 'Belgium')
    ];

    return items;
  }
}
