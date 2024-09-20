import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/extensions/color_extensions.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/weather/colorscheme.dart';
import 'package:not_another_weather_app/weather/views/card.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ForecastListScreen extends StatefulWidget {
  const ForecastListScreen({super.key});

  @override
  State<ForecastListScreen> createState() => _ForecastListScreenState();
}

class _ForecastListScreenState extends State<ForecastListScreen> {
  final PageController _pageController = PageController();

  bool _isShowingEditMenu = false;
  int sliderOffset = 0;

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
      _isShowingEditMenu = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, state, child) {
        return Scaffold(
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: state.geocodings.length,
                  physics: _isShowingEditMenu
                      ? const NeverScrollableScrollPhysics()
                      : const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) => GeocodingCard(
                    state.geocodings[index],
                    pageController: _pageController,
                    isEditing: _isShowingEditMenu,
                    onPressEdit: _setShowingMenu,
                  ),
                ),
                AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutQuint,
                  offset: Offset(_isShowingEditMenu ? 0.1 : 0.0, 0.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: state.geocodings.length,
                        axisDirection: Axis.vertical,
                        effect: const ScrollingDotsEffect(
                          fixedCenter: true,
                          maxVisibleDots: 7,
                          dotHeight: 10,
                          dotWidth: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
