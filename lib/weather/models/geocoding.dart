import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/widget_item.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Geocoding {
  @Id(assignable: true)
  int id;

  String name;
  double latitude;
  double longitude;
  String country;

  @Transient() // Not stored in database
  bool isCurrentLocation;

  Forecast? forecast;

  int selectedPage = 0;

  @Transient()
  List<SelectableForecastFields> selectedForecastItems = [];

  List<int> get selectedForecastItemsDb {
    _ensureStableEnumValues();
    return selectedForecastItems
        .map((e) => SelectableForecastFields.fromEnumToIndex(e))
        .toList();
  }

  set selectedForecastItemsDb(List<int> fields) {
    _ensureStableEnumValues();
    selectedForecastItems = fields.isNotEmpty
        ? fields
            .map((e) => SelectableForecastFields.fromIndexToEnum(e))
            .toList()
        : [
            SelectableForecastFields.windSpeed,
            SelectableForecastFields.precipitation,
            SelectableForecastFields.chainceOfRain,
            SelectableForecastFields.cloudCover
          ];
  }

  List<WidgetItem> detailWidgets = [
    WidgetItem(id: 1, size: WidgetSize.medium, type: WidgetType.compass),
    WidgetItem(id: 2, size: WidgetSize.small, type: WidgetType.genericText),
    WidgetItem(id: 3, size: WidgetSize.small, type: WidgetType.genericText),
    WidgetItem(id: 4, size: WidgetSize.large, type: WidgetType.sunriseSunset),
    WidgetItem(id: 5, size: WidgetSize.medium, type: WidgetType.genericText),
    WidgetItem(id: 6, size: WidgetSize.medium, type: WidgetType.genericText),
  ];

  Geocoding(this.id, this.name, this.latitude, this.longitude, this.country,
      {this.isCurrentLocation = false});

  factory Geocoding.fromJson(Map<String, dynamic> json) {
    return Geocoding(
      json['id'],
      json['name'],
      json['latitude'],
      json['longitude'],
      json['country'] ?? "Unknown",
    );
  }

  void _ensureStableEnumValues() {
    assert(SelectableForecastFields.temperature.index == 0);
    assert(SelectableForecastFields.windSpeed.index == 1);
    assert(SelectableForecastFields.precipitation.index == 2);
    assert(SelectableForecastFields.chainceOfRain.index == 3);
    assert(SelectableForecastFields.sunrise.index == 4);
    assert(SelectableForecastFields.sunset.index == 5);
    assert(SelectableForecastFields.humidity.index == 6);
    assert(SelectableForecastFields.windDirection.index == 7);
    assert(SelectableForecastFields.windGusts.index == 8);
    assert(SelectableForecastFields.cloudCover.index == 9);
    assert(SelectableForecastFields.isDay.index == 10);
    assert(SelectableForecastFields.localTime.index == 11);
  }

  @override
  String toString() {
    return "$country - $name";
  }
}
