import 'package:flutter/material.dart';

class WeatherProvider extends ChangeNotifier {
  final PageController _pageController = PageController();

  PageController get pageController => _pageController;
}
