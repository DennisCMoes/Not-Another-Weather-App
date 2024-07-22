import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:not_another_weather_app/shared/views/custom_multi_sized_grid.dart';
import 'package:not_another_weather_app/weather/views/painters/line_chart.dart';
import 'package:not_another_weather_app/weather/views/painters/sun_painter.dart';
import 'package:provider/provider.dart';
import 'package:not_another_weather_app/shared/utilities/providers/drawer_provider.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/weather_code.dart';
import 'package:not_another_weather_app/weather/views/components/hour_card.dart';
import 'package:not_another_weather_app/weather/views/painters/compass_painter.dart';

class ForecastCard extends StatefulWidget {
  final Geocoding _geocoding;

  const ForecastCard(this._geocoding, {super.key});

  @override
  State<ForecastCard> createState() => ForecastCardState();
}

class ForecastCardState extends State<ForecastCard> {
  final PageController _pageController = PageController(initialPage: 1);

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: widget._geocoding.forecast == null
                        ? Text("Loading",
                            style: Theme.of(context).textTheme.displayLarge)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget._geocoding.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      color: widget._geocoding.forecast!
                                          .weatherCode.colorScheme.accentColor,
                                    ),
                              ),
                              Text(
                                "${widget._geocoding.forecast!.temperature.round()}º ${widget._geocoding.forecast!.weatherCode.description}",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      color: widget._geocoding.forecast!
                                          .weatherCode.colorScheme.accentColor
                                          .withOpacity(0.6),
                                    ),
                              ),
                            ],
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
                children: [
                  _pageOne(),
                  _pageTwo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _weatherDetailItem(String description, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: widget
                  ._geocoding.forecast?.weatherCode.colorScheme.accentColor),
        ),
        Text(
          description,
          style: TextStyle(
              color: widget
                  ._geocoding.forecast?.weatherCode.colorScheme.accentColor),
        ),
      ],
    );
  }

  Widget _pageOne() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: <Widget>[
                Center(
                  child: ClipPath(
                    clipper: WeatherCode.getClipper(
                        widget._geocoding.forecast?.weatherCode),
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: RepaintBoundary(
                        child: CustomScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          slivers: [
                            SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => ClipOval(
                                  child: Material(
                                    color: widget
                                            ._geocoding
                                            .forecast
                                            ?.weatherCode
                                            .colorScheme
                                            .accentColor ??
                                        Colors.black,
                                  ),
                                ),
                                childCount: 400, // 20 * 20
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 20,
                                crossAxisSpacing: 6,
                                mainAxisSpacing: 6,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _weatherDetailItem(
                  "Wind",
                  "${widget._geocoding.forecast?.windSpeed.round() ?? "XX"}km/h",
                ),
                VerticalDivider(
                  color: widget
                      ._geocoding.forecast?.weatherCode.colorScheme.accentColor
                      .withOpacity(0.6),
                ),
                _weatherDetailItem(
                  "Pressure",
                  "${widget._geocoding.forecast?.pressure.round() ?? "XX"} mbar",
                ),
                VerticalDivider(
                  color: widget
                      ._geocoding.forecast?.weatherCode.colorScheme.accentColor
                      .withOpacity(0.6),
                ),
                _weatherDetailItem(
                  "Humidity",
                  "${widget._geocoding.forecast?.humidity ?? "XX"}%",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageTwo() {
    List<GridItem> items = [
      GridItem(
        id: 1,
        rowSpan: 1,
        colSpan: 2,
        child: _feelAndSightCard(
            "${widget._geocoding.forecast?.apparentTemperature.round()}º",
            Icons.thermostat),
        label: "Apparent feel",
      ),
      GridItem(
        id: 3,
        rowSpan: 2,
        colSpan: 2,
        child: _compassCard(),
        label: "Wind",
        icon: Icons.air,
      ),
      GridItem(
        id: 2,
        rowSpan: 1,
        colSpan: 2,
        child: _feelAndSightCard(
            "${widget._geocoding.forecast?.cloudCover ?? "XX"}%",
            Icons.cloud_outlined),
        label: "Cloud cover",
      ),
      GridItem(
        id: 4,
        rowSpan: 2,
        colSpan: 4,
        child: _rainForecastCard(),
        label: "Rain forecast",
        icon: Icons.water_drop_outlined,
      ),
      GridItem(
        id: 5,
        rowSpan: 2,
        colSpan: 2,
        child: _isDayCard(),
        label: "",
        icon: Icons.wb_sunny_outlined,
      ),
      GridItem(
        id: 6,
        rowSpan: 2,
        colSpan: 2,
        child: const Text("Child 7"),
        label: "Air Pressure",
        icon: Icons.speed,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: CustomMultiChildLayout(
        delegate: CustomMultiSizedGridDelegate(items, padding: 12),
        children: items.map((item) {
          return LayoutId(
            id: item.id,
            child: _forecastCardWrapper(
              value: item.label!,
              child: item.child,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _forecastCardWrapper({required String value, required Widget child}) {
    return Material(
      borderRadius: BorderRadius.circular(6),
      color: widget._geocoding.forecast?.weatherCode.colorScheme
              .darkenMainColor(0.1) ??
          Colors.blueGrey,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(value),
            ),
          ),
          Center(child: child),
        ],
      ),
    );
  }

  Widget _feelAndSightCard(String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value, style: Theme.of(context).textTheme.displayLarge),
        // const SizedBox(width: 4),
        // Icon(icon, size: 32),
      ],
    );
  }

  Widget _compassCard() {
    return Material(
      color: widget._geocoding.forecast?.weatherCode.colorScheme
              .darkenMainColor(0.1) ??
          Colors.blueGrey,
      borderRadius: BorderRadius.circular(8),
      child: CustomPaint(
        foregroundPainter: CompassPainter(
          angle: widget._geocoding.forecast?.windDirection.toDouble() ?? 0.0,
          ringColor:
              widget._geocoding.forecast?.weatherCode.colorScheme.accentColor ??
                  Colors.black,
        ),
        child: Center(
          child: Text(
            "${widget._geocoding.forecast?.windDirection ?? "XX"}º",
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ),
    );
  }

  Widget _rainForecastCard() {
    return CustomPaint(
      painter: LineChartPainter(
          widget._geocoding.forecast?.hourlyRainProbability ?? {}),
      child: Container(),
    );
  }

  Widget _isDayCard() {
    String formatTime(DateTime? dateTime) {
      return dateTime == null
          ? "Invalid time"
          : DateFormat.Hm().format(dateTime);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Sunrise"),
                Text(
                  formatTime(widget._geocoding.forecast?.sunrise),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomPaint(
              painter: SunPainter(currentTime: DateTime.now()),
              child: Container(),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Sunset"),
                Text(
                  formatTime(widget._geocoding.forecast?.sunset),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
