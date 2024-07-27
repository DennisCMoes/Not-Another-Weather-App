import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/widget_item.dart';

class CurrentGeocodingProvider extends ChangeNotifier {
  final Geocoding geocoding;
  final PageController _pageController = PageController(initialPage: 0);

  bool _isEditing = false;
  int _subPageIndex = 0;

  CurrentGeocodingProvider(this.geocoding);

  bool get isEditing => _isEditing;
  int get subPageIndex => _subPageIndex;
  PageController get subPageController => _pageController;

  bool isCurrentPage(int index) => _subPageIndex == index;

  void setIsEditing(bool isEditing) {
    _isEditing = isEditing;
    notifyListeners();
  }

  void setSubPageIndex(int index) {
    _subPageIndex = index;
    notifyListeners();
  }

  void setMainField(SelectableForecastFields field) {
    geocoding.selectedMainField = field;
    notifyListeners();
  }

  void replaceSecondaryField(
      SelectableForecastFields oldField, SelectableForecastFields newField) {
    int index = geocoding.selectedForecastItems.indexOf(oldField);
    geocoding.selectedForecastItems[index] = newField;
    notifyListeners();
  }

  void setGeocodingSize(WidgetItem item, WidgetSize size) {
    geocoding.detailWidgets.singleWhere((widget) => widget.id == item.id).size =
        size;
    notifyListeners();
  }

  void setGeocodingType(WidgetItem item, WidgetType type) {
    geocoding.detailWidgets.singleWhere((widget) => widget.id == item.id).type =
        type;
    notifyListeners();
  }
}
