import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/widget_item.dart';

/// A provider that manages the state and logic for the currently selected geocoding
class CurrentGeocodingProvider extends ChangeNotifier {
  final Geocoding geocoding;
  final PageController _pageController = PageController(initialPage: 0);

  bool _isEditing = false;
  int _subPageIndex = 0;

  CurrentGeocodingProvider(this.geocoding);

  bool get isEditing => _isEditing;
  int get subPageIndex => _subPageIndex;
  PageController get subPageController => _pageController;

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

  /// Sets the main field of the geocoding to [field] and notifies it's listeners
  void setMainField(SelectableForecastFields field) {
    geocoding.selectedMainField = field;
    notifyListeners();
  }

  /// Replaces the [oldField] with [newField] in the list of selected forecast items and notifies it's listeners
  void replaceSecondaryField(
      SelectableForecastFields oldField, SelectableForecastFields newField) {
    int index = geocoding.selectedForecastItems.indexOf(oldField);
    geocoding.selectedForecastItems[index] = newField;
    notifyListeners();
  }

  /// Sets the size of the widget item identified by [item] to [size] and notifies it's listeners
  void setGeocodingSize(WidgetItem item, WidgetSize size) {
    geocoding.detailWidgets.singleWhere((widget) => widget.id == item.id).size =
        size;
    notifyListeners();
  }

  /// Sets the type of the widget item identified by [item] to [type] and notifies it's listeners
  void setGeocodingType(WidgetItem item, WidgetType type) {
    geocoding.detailWidgets.singleWhere((widget) => widget.id == item.id).type =
        type;
    notifyListeners();
  }
}
