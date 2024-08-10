import 'package:flutter/material.dart';
import 'package:not_another_weather_app/weather/models/colorscheme.dart';
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
    Geocoding geocoding = Geocoding(
      json['id'],
      json['name'],
      json['latitude'],
      json['longitude'],
      json['country'] ?? "Unknown",
    );

    geocoding.selectedForecastItems = [
      SelectableForecastFields.windSpeed,
      SelectableForecastFields.precipitation,
      SelectableForecastFields.chainceOfRain,
      SelectableForecastFields.cloudCover,
    ];

    return geocoding;
  }

  void _ensureStableEnumValues() {
    assert(SelectableForecastFields.temperature.index == 0);
    assert(SelectableForecastFields.apparentTemperature.index == 1);
    assert(SelectableForecastFields.windSpeed.index == 2);
    assert(SelectableForecastFields.precipitation.index == 3);
    assert(SelectableForecastFields.chainceOfRain.index == 4);
    assert(SelectableForecastFields.sunrise.index == 5);
    assert(SelectableForecastFields.sunset.index == 6);
    assert(SelectableForecastFields.humidity.index == 7);
    assert(SelectableForecastFields.windDirection.index == 8);
    assert(SelectableForecastFields.windGusts.index == 9);
    assert(SelectableForecastFields.cloudCover.index == 10);
    assert(SelectableForecastFields.isDay.index == 11);
    assert(SelectableForecastFields.localTime.index == 12);
  }

  ColorPair getColorSchemeOfForecast([DateTime? selectedTime]) {
    if (forecast == null) {
      return const ColorPair(Color(0xFF0327D6), Color(0xFFDBE7F6));
    }

    DateTime time = selectedTime ?? DateTime.now();
    DateTime startOfHour = DateTime(time.year, time.month, time.day, time.hour);
    DateTime startOfDay = DateTime(time.year, time.month, time.day);

    final dailyWeatherData = forecast?.dailyWeatherData[startOfDay];
    if (dailyWeatherData == null) {
      return const ColorPair(Color(0xFF0327D6), Color(0xFFDBE7F6));
    }

    final sunrise = dailyWeatherData.sunrise;
    final sunset = dailyWeatherData.sunset;

    final isInTheDay = time.isBefore(sunset) && time.isAfter(sunrise);

    return forecast!
        .getCurrentHourData(startOfHour)
        .weatherCode
        .colorScheme
        .getColorPair(isInTheDay);
  }

  @override
  String toString() {
    return "$country - $name";
  }
}
