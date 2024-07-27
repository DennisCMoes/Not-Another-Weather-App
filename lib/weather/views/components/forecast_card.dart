import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/utilities/providers/device_provider.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/views/components/forecast_components/page_one.dart';
import 'package:not_another_weather_app/weather/views/components/forecast_components/page_two.dart';
import 'package:provider/provider.dart';
import 'package:not_another_weather_app/shared/utilities/providers/drawer_provider.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';

class ForecastCard extends StatefulWidget {
  final Geocoding _geocoding;

  const ForecastCard(this._geocoding, {super.key});

  @override
  State<ForecastCard> createState() => ForecastCardState();
}

class ForecastCardState extends State<ForecastCard> {
  late PageController _pageController;

  final ScrollController _scrollController = ScrollController();
  final PageController _subPageController = PageController();

  final List<String> _subPageButtonLabels = ["Summary", "Details"];

  int _selectedSubPage = 0;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    _selectedSubPage = widget._geocoding.selectedPage;
    _pageController =
        PageController(initialPage: widget._geocoding.selectedPage);
    _subPageController.addListener(_scrollToSelectedPage);
  }

  @override
  void dispose() {
    _subPageController.removeListener(_scrollToSelectedPage);
    _pageController.dispose();
    _subPageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedPage() {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = 100.0 + 12.0;
    double targetScrollOffset =
        (_selectedSubPage * itemWidth) - (screenWidth / 2 - itemWidth / 2);

    _scrollController.animateTo(
      targetScrollOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onSubPageScroll(int index) {
    Provider.of<WeatherProvider>(context, listen: false)
        .changeSelectedPage(widget._geocoding, index);
  }

  @override
  Widget build(BuildContext context) {
    void toggleIsEditing() {
      setState(() {
        isEditing = !isEditing;
      });
    }

    return ColoredBox(
      color: widget._geocoding.forecast?.weatherCode.colorScheme.mainColor ??
          Colors.blueGrey,
      child: Padding(
        padding: EdgeInsets.only(
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: NavigationToolbar.kMiddleSpacing,
                right: NavigationToolbar.kMiddleSpacing,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  widget._geocoding.forecast == null
                      ? Text("Loading",
                          style: Theme.of(context).textTheme.displayLarge)
                      : Text(
                          widget._geocoding.name,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color: widget._geocoding.forecast!.weatherCode
                                    .colorScheme.accentColor,
                              ),
                        ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Provider.of<DeviceProvider>(context).hasInternet
                          ? const SizedBox.shrink()
                          : const Icon(
                              Icons.signal_wifi_connected_no_internet_4),
                      IconButton(
                        onPressed: () {
                          Provider.of<DrawerProvider>(context, listen: false)
                              .openDrawer();
                        },
                        visualDensity: VisualDensity.compact,
                        icon: Icon(Icons.reorder,
                            color: widget._geocoding.forecast?.weatherCode
                                    .colorScheme.accentColor ??
                                Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (value) {
                  _onSubPageScroll(value);

                  setState(() {
                    _selectedSubPage = value;
                  });
                },
                children: [
                  PageOne(
                    geocoding: widget._geocoding,
                    isEditing: isEditing,
                  ),
                  PageTwo(
                    geocoding: widget._geocoding,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: toggleIsEditing,
                      icon: Icon(
                        isEditing ? Icons.edit_off : Icons.edit,
                        color: widget._geocoding.forecast?.weatherCode
                                .colorScheme.accentColor ??
                            Colors.black,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        2,
                        (index) => GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            transform: _selectedSubPage == index
                                ? Matrix4.identity()
                                : (Matrix4.identity()..scale(0.9)),
                            child: Text(
                              _subPageButtonLabels[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: _selectedSubPage == index
                                        ? Colors.black
                                        : Colors.black45,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
