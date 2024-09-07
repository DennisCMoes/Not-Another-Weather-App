import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/utilities/datetime_utils.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/geocoding_repo.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/logics/selectable_forecast_fields.dart';

/// A provider that manages the state and logic for the currently selected geocoding
class ForecastCardProvider extends ChangeNotifier {
  Geocoding? _geocoding;

  final GeocodingRepo _geocodingRepo = GeocodingRepo();

  bool _isEditing = false;

  // Getters
  Geocoding? get geocoding => _geocoding;
  bool get isEditing => _isEditing;

  /// Sets the geocoding and notifies listeners
  void setGeocoding(Geocoding geocoding) {
    _geocoding = geocoding;
    notifyListeners();
  }

  /// Sets the editing state to [isEditing] and notifies it's listeners
  void setIsEditing(bool isEditing) {
    _isEditing = isEditing;
    notifyListeners();
  }

  /// Initializes the selected hour to the start of the current hour in the geocoding's timezone
  // void _initializeSelectedHour() {
  //   final forecast = geocoding.forecast;
  //   final convertedNow =
  //       DatetimeUtils.convertToTimezone(DateTime.now(), forecast.timezone);

  //   _selectedHour = DatetimeUtils.startOfHour(convertedNow);
  // }

  /// Replaces the [oldField] with [newField] in the list of selected forecast items and notifies it's listeners
  void replaceSecondaryField(
    Geocoding geocoding,
    SelectableForecastFields oldField,
    SelectableForecastFields newField,
  ) {
    final List<SelectableForecastFields> selectedFields =
        geocoding.selectedForecastItems;

    int oldFieldIndex = geocoding.selectedForecastItems.indexOf(oldField);
    int newFieldIndex = geocoding.selectedForecastItems.indexOf(newField);

    if (oldFieldIndex != -1) {
      if (newFieldIndex != -1) {
        // Swap the fields
        selectedFields[newFieldIndex] = oldField;
      }

      selectedFields[oldFieldIndex] = newField;
      notifyListeners();
      _geocodingRepo.storeGeocoding(geocoding);
    } else {
      debugPrint("Error: Old field not found in selected forecast items");
    }
  }

  /// Returns a string representing the selected hour relative to the current day
  ///
  /// If the `selectedHour` is on the same day as the current date, the string will be in the format
  /// "Today at {hour}". Otherwise, it will be "Tomorrow at {hour}"
  ///
  /// Returns a string indicating the relative day and hour
  String getSelectedHourDescription(Forecast forecast, DateTime selectedHour) {
    try {
      // final forecastData = await geocoding.forecast;
      final now = DateTime.now();
      final timezone = forecast.timezone;

      final nowInTargetzone = DatetimeUtils.convertToTimezone(now, timezone);

      if (DateUtils.isSameDay(nowInTargetzone, selectedHour)) {
        return "Today at ${selectedHour.hour}";
      } else if (selectedHour.isBefore(nowInTargetzone)) {
        return "Yesterday at ${selectedHour.hour}";
      } else {
        return "Tomorrow at ${selectedHour.hour}";
      }
    } catch (exception) {
      debugPrint("Error fetching selected hour description: $exception");
      return "Error fetching data";
    }
  }
}
