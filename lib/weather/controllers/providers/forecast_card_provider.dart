import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/utilities/datetime_utils.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/geocoding_repo.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/logics/selectable_forecast_fields.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
    try {
      _initializeSelectedHour();
    } catch (exception, stacktrace) {
      Sentry.captureException(exception, stackTrace: stacktrace);
    }
  }

  bool get isEditing => _isEditing;
  int get subPageIndex => _subPageIndex;
  PageController get subPageController => _pageController;
  DateTime get selectedHour => _selectedHour;

  void _initializeSelectedHour() {
    final forecast = geocoding.forecast!;
    final convertedNow =
        DatetimeUtils.convertToTimezone(DateTime.now(), forecast.timezome);
    final convertedStartHour = DatetimeUtils.startOfHour(convertedNow);

    _selectedHour = convertedStartHour;
  }

  void _setSelectedHour(DateTime time) {
    _selectedHour = DatetimeUtils.startOfHour(time);
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

  /// Returns a string representing the selected hour relative to the current day
  ///
  /// If the `selectedHour` is on the same day as the current date, the string will be in the format
  /// "Today at {hour}". Otherwise, it will be "Tomorrow at {hour}"
  ///
  /// Returns a string indicating the relative day and hour
  String getSelectedHourDescription(Forecast forecast) {
    try {
      // final forecastData = await geocoding.forecast;
      final now = DateTime.now();
      final timezone = forecast.timezome;

      final nowInTargetzone = DatetimeUtils.convertToTimezone(now, timezone);

      if (DateUtils.isSameDay(nowInTargetzone, selectedHour)) {
        return "Today at ${selectedHour.hour}";
      } else if (selectedHour.isBefore(nowInTargetzone)) {
        return "Yesterday at ${selectedHour.hour}";
      } else {
        return "Tomorrow at ${selectedHour.hour}";
      }
    } catch (exception) {
      return "Error fetching data: $exception";
    }
  }
}
