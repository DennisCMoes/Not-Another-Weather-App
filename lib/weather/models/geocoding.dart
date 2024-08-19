import 'dart:async';

import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/utilities/datetime_utils.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/forecast_repo.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/geocoding_repo.dart';
import 'package:not_another_weather_app/weather/models/logics/selectable_forecast_fields.dart';
import 'package:not_another_weather_app/weather/models/weather/colorscheme.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/logics/widget_item.dart';
import 'package:objectbox/objectbox.dart';

enum TestClass {
  none,
  day,
  night;
}

@Entity()
class Geocoding {
  @Id(assignable: true)
  int id;

  int ordening;
  String name;
  double latitude;
  double longitude;
  String country;

  @Transient()
  TestClass isTestClass;

  @Transient() // Not stored in database
  bool isCurrentLocation;

  @Transient()
  late Future<Forecast> forecast;

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

  Geocoding(
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.country, {
    this.isCurrentLocation = false,
    this.ordening = -1,
    this.isTestClass = TestClass.none,
  }) {
    final completer = Completer<Forecast>();
    final ForecastRepo repo = ForecastRepo();

    forecast = completer.future;

    if (isTestClass == TestClass.none && latitude != 0 && longitude != 0) {
      _fetchForecast(completer, repo);
    }
  }

  void _fetchForecast(Completer<Forecast> completer, ForecastRepo repo) async {
    try {
      final forecastData = await repo.getForecastOfLocation(
        latitude,
        longitude,
      );

      completer.complete(forecastData);
    } catch (exception, stacktrace) {
      completer.completeError(exception, stacktrace);
    }
  }

  factory Geocoding.fromJson(Map<String, dynamic> json) {
    return Geocoding(
      json['id'],
      json['name'],
      json['latitude'],
      json['longitude'],
      json['country'] ?? "Unknown",
    )..selectedForecastItems = [
        SelectableForecastFields.windSpeed,
        SelectableForecastFields.precipitation,
        SelectableForecastFields.chainceOfRain,
        SelectableForecastFields.cloudCover,
      ];
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
    assert(SelectableForecastFields.localTime.index == 11);
  }

  Future<ColorPair> getColorSchemeOfForecast([DateTime? time]) async {
    try {
      Forecast forecastData = await forecast;
      time ??= DateTime.now();

      final DateTime startOfHour = DatetimeUtils.startOfHour(time);
      final DateTime startOfDay = DatetimeUtils.startOfDay(time);

      final dailyWeatherData = forecastData.dailyWeatherData[startOfDay];
      if (dailyWeatherData == null) {
        return const ColorPair(Color(0xFF0327D6), Color(0xFFDBE7F6));
      }

      final sunrise = dailyWeatherData.sunrise;
      final sunset = dailyWeatherData.sunset;

      bool isInTheDay;

      if (isTestClass == TestClass.day) {
        isInTheDay = true;
      } else if (isTestClass == TestClass.night) {
        isInTheDay = false;
      } else {
        isInTheDay = (time.isAfter(sunrise)) && (time.isBefore(sunset));
      }

      return forecastData
          .getCurrentHourData(startOfHour)
          .weatherCode
          .colorScheme
          .getColorPair(isInTheDay);
    } catch (exception) {
      return const ColorPair(Color(0xFF0327D6), Color(0xFFDBE7F6));
    }
  }

  @override
  String toString() {
    return "$country - $name";
  }
}
