import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:not_another_weather_app/shared/views/custom_multi_sized_grid.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/views/painters/compass_painter.dart';
import 'package:not_another_weather_app/weather/views/painters/line_chart.dart';
import 'package:not_another_weather_app/weather/views/painters/pressure_gauge_painter.dart';
import 'package:not_another_weather_app/weather/views/painters/sun_painter.dart';

class PageTwo extends StatefulWidget {
  final Geocoding geocoding;

  const PageTwo({required this.geocoding, super.key});

  @override
  State<PageTwo> createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  @override
  Widget build(BuildContext context) {
    List<GridItem> items = [
      GridItem(
        id: 1,
        rowSpan: 1,
        colSpan: 2,
        child: _feelAndSightCard(
            "${widget.geocoding.forecast?.apparentTemperature.round()}º",
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
            "${widget.geocoding.forecast?.cloudCover ?? "XX"}%",
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
        child: _pressureCard(),
        label: "",
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
      color: widget.geocoding.forecast?.weatherCode.colorScheme
              .darkenMainColor(0.1) ??
          Colors.blueGrey,
      clipBehavior: Clip.hardEdge,
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
      color: widget.geocoding.forecast?.weatherCode.colorScheme
              .darkenMainColor(0.1) ??
          Colors.blueGrey,
      borderRadius: BorderRadius.circular(8),
      child: CustomPaint(
        foregroundPainter: CompassPainter(
          angle: widget.geocoding.forecast?.windDirection.toDouble() ?? 0.0,
          ringColor:
              widget.geocoding.forecast?.weatherCode.colorScheme.accentColor ??
                  Colors.black,
        ),
        child: Center(
          child: Text(
            "${widget.geocoding.forecast?.windDirection ?? "XX"}º",
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ),
    );
  }

  Widget _rainForecastCard() {
    return CustomPaint(
      painter:
          LineChartPainter(widget.geocoding.forecast?.rainProbabilities ?? {}),
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
                  formatTime(widget.geocoding.forecast?.sunrise),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
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
                  formatTime(widget.geocoding.forecast?.sunset),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
          ),
          CustomPaint(
            painter: SunPainter(currentTime: DateTime.now()),
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _pressureCard() {
    return CustomPaint(
      painter: PressureGaugePainter(pressure: 1015),
      child: Container(),
    );
  }
}
