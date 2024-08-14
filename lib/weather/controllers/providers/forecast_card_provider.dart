import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/utilities/datetime_utils.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/geocoding_repo.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/logics/selectable_forecast_fields.dart';
import 'package:not_another_weather_app/weather/models/logics/widget_item.dart';

/// A provider that manages the state and logic for the currently selected geocoding
class ForecastCardProvider extends ChangeNotifier {
  Geocoding _geocoding;

  final GeocodingRepo _geocodingRepo = GeocodingRepo();

  final PageController _pageController = PageController(initialPage: 0);

  bool _isEditing = false;
  int _subPageIndex = 0;
  DateTime _selectedHour = DateTime.now();

  Geocoding get geocoding => _geocoding;

  ForecastCardProvider(this._geocoding) {
    _initializeSelectedHour();
  }

  bool get isEditing => _isEditing;
  int get subPageIndex => _subPageIndex;
  PageController get subPageController => _pageController;
  DateTime get selectedHour => _selectedHour;

  void _initializeSelectedHour() {
    final convertedNow = DatetimeUtils.convertToTimezone(DateTime.now(),
        geocoding.forecast?.timezome ?? DateTime.now().timeZoneName);
    final convertedStart = DatetimeUtils.startOfHour(convertedNow);
    _selectedHour = convertedStart;
  }

  void _setSelectedHour(DateTime time) {
    _selectedHour = DatetimeUtils.startOfHour(time);
    notifyListeners();
  }

  void _updateWidgetItem(WidgetItem item, void Function(WidgetItem) updateFn) {
    WidgetItem widget =
        geocoding.detailWidgets.singleWhere((widget) => widget.id == item.id);

    updateFn(widget);
    notifyListeners();
  }

  void setGeocoding(Geocoding geocoding) {
    _geocoding = geocoding;
    notifyListeners();
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
    _selectedHour = DatetimeUtils.startOfHour(time);
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
      _geocodingRepo.storeGeocoding(geocoding);
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
    final now = DateTime.now();
    final timezone = geocoding.forecast?.timezome ?? now.timeZoneName;

    final nowInTargetzone = DatetimeUtils.convertToTimezone(now, timezone);

    if (DateUtils.isSameDay(nowInTargetzone, selectedHour)) {
      return "Today at ${selectedHour.hour}";
    } else if (selectedHour.isBefore(nowInTargetzone)) {
      return "Yesterday at ${selectedHour.hour}";
    } else {
      return "Tomorrow at ${selectedHour.hour}";
    }
  }
}
