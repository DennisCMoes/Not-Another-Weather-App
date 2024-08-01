import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:not_another_weather_app/weather/models/colorscheme.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/widget_item.dart';

/// A provider that manages the state and logic for the currently selected geocoding
class CurrentGeocodingProvider extends ChangeNotifier {
  final Geocoding geocoding;

  final PageController _pageController = PageController(initialPage: 0);
  final PageController _futureForecastController =
      PageController(initialPage: 2, viewportFraction: 0.2);

  bool _isEditing = false;
  int _subPageIndex = 0;
  DateTime _selectedHour = DateTime.now();

  CurrentGeocodingProvider(this.geocoding) {
    _initializeSelectedHour();
  }

  bool get isEditing => _isEditing;
  int get subPageIndex => _subPageIndex;
  PageController get subPageController => _pageController;
  PageController get futureForecastController => _futureForecastController;
  DateTime get selectedHour => _selectedHour;

  void _initializeSelectedHour() {
    final now = DateTime.now();
    _selectedHour = DateTime(now.year, now.month, now.day, now.hour);
  }

  void _setSelectedHour(DateTime time) {
    final now = DateTime.now();
    _selectedHour = DateTime(now.year, now.month, time.day, time.hour);
    notifyListeners();
  }

  void _updateWidgetItem(WidgetItem item, void Function(WidgetItem) updateFn) {
    WidgetItem widget =
        geocoding.detailWidgets.singleWhere((widget) => widget.id == item.id);

    updateFn(widget);
    notifyListeners();
  }

  DateTime _getStartOfHour([int offset = 0, int? hour]) {
    final now = DateTime.now();
    final adjustedHour = hour ?? now.hour;
    return DateTime(now.year, now.month, now.day, adjustedHour)
        .add(Duration(hours: offset));
  }

  /// Checks if the given [index] is the current page.
  ///
  /// Returns `true` if the [index] matches the current sub-page index
  bool isCurrentPage(int index) => _subPageIndex == index;

  /// Sets the editing state to [isEditing] and notifies it's listeners
  void setIsEditing(bool isEditing) {
    _isEditing = isEditing;
    notifyListeners();
  }

  /// Sets the sub-page index to [index] and notifies it's listeners
  void setSubPageIndex(int index) {
    _subPageIndex = index;
    notifyListeners();
  }

  void setFutureForecastIndex(DateTime time) {
    _setSelectedHour(time);
    notifyListeners();
  }

  /// Sets the selected hour to [hour] and notifies it's listeners
  void setSelectedHour(DateTime time) {
    _setSelectedHour(time);
    notifyListeners();
  }

  /// Sets the main field of the geocoding to [field] and notifies it's listeners
  void setMainField(SelectableForecastFields field) {
    geocoding.selectedMainField = field;
    notifyListeners();
  }

  /// Replaces the [oldField] with [newField] in the list of selected forecast items and notifies it's listeners
  void replaceSecondaryField(
      SelectableForecastFields oldField, SelectableForecastFields newField) {
    int oldFieldIndex = geocoding.selectedForecastItems.indexOf(oldField);
    int newFieldIndex = geocoding.selectedForecastItems.indexOf(newField);

    if (oldFieldIndex != -1) {
      if (newFieldIndex != -1) {
        // Swap the fields
        geocoding.selectedForecastItems[newFieldIndex] = oldField;
      }

      geocoding.selectedForecastItems[oldFieldIndex] = newField;
      notifyListeners();
    } else {
      debugPrint("Error: Old field not found");
    }
  }

  /// Sets the size of the widget item identified by [item] to [size] and notifies it's listeners
  void setGeocodingSize(WidgetItem item, WidgetSize size) {
    _updateWidgetItem(item, (widget) => widget.size == size);
    notifyListeners();
  }

  /// Sets the type of the widget item identified by [item] to [type] and notifies it's listeners
  void setGeocodingType(WidgetItem item, WidgetType type) {
    _updateWidgetItem(item, (widget) => widget.type == type);
    notifyListeners();
  }

  /// Returns a string representing the selected hour relative to the current day
  ///
  /// If the `selectedHour` is on the same day as the current date, the string will be in the format
  /// "Today at {hour}". Otherwise, it will be "Tomorrow at {hour}"
  ///
  /// Returns a string indicating the relative day and hour
  String getSelectedHourDescription() {
    return DateUtils.isSameDay(DateTime.now(), selectedHour)
        ? "Today at ${selectedHour.hour}"
        : "Tomorrow at ${selectedHour.hour}";
  }

  /// Returns a color scheme based on the weather forecast and selected hour
  ///
  /// If no forecast data is available, return a default color scheme of purple and white.
  /// Otherwise, it determines if the `selectedHour` falls within the daytime and retrieves
  /// the appropriate color scheme based on the weather conditions for that hour.
  ///
  /// Return a `ColorPair` representing the color scheme for the selected hour's weather conditions.
  ColorPair getWeatherColorScheme() {
    Forecast? forecast = geocoding.forecast;

    if (forecast == null) {
      return const ColorPair(Colors.purple, Colors.white);
    }

    DateTime startOfDay =
        DateTime(selectedHour.year, selectedHour.month, selectedHour.day);

    final isInTheDay = selectedHour
            .isBefore(forecast.dailyWeatherData[startOfDay]!.sunset) &&
        selectedHour.isAfter(forecast.dailyWeatherData[startOfDay]!.sunrise);

    final weatherData = forecast.getCurrentHourData(selectedHour);

    return weatherData.weatherCode.colorScheme.getColorPair(isInTheDay);
  }

  List<MapEntry<DateTime, HourlyWeatherData>> get24hForecast() {
    final startOfHour = _getStartOfHour(-2);

    return geocoding.forecast!.hourlyWeatherData.entries
        .where((element) =>
            element.key.isAtSameMomentAs(startOfHour) ||
            element.key.isAfter(startOfHour))
        .take(27)
        .toList();
  }

  int get24hForecastIndex(DateTime time) {
    final startOfHour = _getStartOfHour(0, time.hour);
    return get24hForecast().indexWhere((element) => element.key == startOfHour);
  }
}
