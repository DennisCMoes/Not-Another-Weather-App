import 'package:flutter/material.dart';

class DrawerProvider extends ChangeNotifier {
  bool _isOpened = false;

  bool get isOpened => _isOpened;

  void openDrawer() {
    _isOpened = true;
    notifyListeners();
  }

  void closeDrawer() {
    _isOpened = false;
    notifyListeners();
  }
}
