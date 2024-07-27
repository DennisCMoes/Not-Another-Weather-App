import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/widget_item.dart';

class Geocoding {
  final int id;
  final bool isCurrentLocation;

  String name;
  double latitude;
  double longitude;
  String country;

  Forecast? forecast;

  int selectedPage = 1;

  SelectableForecastFields selectedMainField =
      SelectableForecastFields.temperature;

  List<SelectableForecastFields> selectedForecastItems = [
    SelectableForecastFields.windSpeed,
    SelectableForecastFields.precipitation,
    SelectableForecastFields.chainceOfRain
  ];

  List<WidgetItem> detailWidgets = [
    WidgetItem(id: 1, size: WidgetSize.medium),
    WidgetItem(id: 2, size: WidgetSize.small),
    WidgetItem(id: 3, size: WidgetSize.small),
    WidgetItem(id: 4, size: WidgetSize.large),
    WidgetItem(id: 5, size: WidgetSize.medium),
    WidgetItem(id: 6, size: WidgetSize.medium),
  ];

  Geocoding(this.id, this.name, this.latitude, this.longitude, this.country,
      {this.isCurrentLocation = false});

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

  @override
  String toString() {
    return "$country - $name";
  }
}
