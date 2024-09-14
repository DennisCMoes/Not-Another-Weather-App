import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:not_another_weather_app/shared/extensions/color_extensions.dart';
import 'package:not_another_weather_app/shared/utilities/datetime_utils.dart';
import 'package:not_another_weather_app/weather/controllers/providers/forecast_card_provider.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/weather/forecast/daily_weather.dart';
import 'package:not_another_weather_app/weather/views/add_geocoding.dart';
import 'package:not_another_weather_app/weather/views/card.dart';
import 'package:not_another_weather_app/weather/views/components/forecast_card.dart';
import 'package:not_another_weather_app/weather/views/components/slider/forecast_slider_thumb.dart';
import 'package:not_another_weather_app/weather/views/components/slider/forecast_slider_track.dart';
import 'package:not_another_weather_app/weather/views/components/slider/forecast_slider_value_indicator.dart';
import 'package:provider/provider.dart';

class ForecastListScreen extends StatefulWidget {
  const ForecastListScreen({super.key});

  @override
  State<ForecastListScreen> createState() => _ForecastListScreenState();
}

class _ForecastListScreenState extends State<ForecastListScreen> {
  final PageController _pageController = PageController();

  bool _showingMenu = false;
  bool _keyboardIsOpen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _setShowingMenu(bool value) {
    setState(() {
      _showingMenu = value;
    });
  }

  void _goToAddGeocoding(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutQuint,
    );
  }

  void _setKeyboardIsOpen(bool isOpen) {
    setState(() {
      _keyboardIsOpen = isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeatherProvider>(
        builder: (context, state, child) {
          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                physics: _keyboardIsOpen
                    ? const NeverScrollableScrollPhysics()
                    : const PageScrollPhysics(),
                itemCount: _showingMenu
                    ? state.geocodings.length + 1
                    : state.geocodings.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      if (index == state.geocodings.length) {
                        return AddGeocodingCard(
                          setKeyboardIsOpen: _setKeyboardIsOpen,
                        );
                      } else {
                        return GeocodingCard(
                          state.geocodings[index],
                          pageController: _pageController,
                          index: index,
                          isShowingMenu: _showingMenu,
                          onPressShowMenu: _setShowingMenu,
                          onPressAdd: () => _goToAddGeocoding(
                            state.geocodings.length,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
