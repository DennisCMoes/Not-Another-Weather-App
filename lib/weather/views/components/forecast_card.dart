import 'package:flutter/material.dart';
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
  final PageController _pageController = PageController(initialPage: 0);
  final ScrollController _scrollController = ScrollController();
  final PageController _subPageController = PageController();

  int _selectedSubPage = 0;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
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
                  IconButton(
                    onPressed: () {
                      Provider.of<DrawerProvider>(context, listen: false)
                          .openDrawer();
                    },
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.reorder,
                        color: widget._geocoding.forecast?.weatherCode
                                .colorScheme.accentColor ??
                            Colors.grey),
                  ),
                  // Text("Right")
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _selectedSubPage = value;
                  });
                },
                children: [
                  // pageOne(),
                  PageOne(geocoding: widget._geocoding),
                  PageTwo(
                    geocoding: widget._geocoding,
                  ),
                  // _pageTwo(),
                ],
              ),
            ),
            SizedBox(
              height: 30,
              width: double.infinity,
              child: LayoutBuilder(builder: (context, constraints) {
                return Center(
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: constraints.maxWidth / 2,
                        // color: Colors.blue,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          transform: Matrix4.translationValues(
                            (index - _selectedSubPage) * 20.0,
                            0,
                            0,
                          ),
                          child: Text(
                            "Page ${index + 1}",
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
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
