import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:not_another_weather_app/shared/views/custom_multi_sized_grid.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/widget_item.dart';
import 'package:not_another_weather_app/weather/views/components/overlays/detail_widgets_overlay.dart';
import 'package:not_another_weather_app/weather/views/painters/compass_painter.dart';
import 'package:not_another_weather_app/weather/views/painters/line_chart.dart';
import 'package:not_another_weather_app/weather/views/painters/pressure_gauge_painter.dart';
import 'package:not_another_weather_app/weather/views/painters/sun_painter.dart';
import 'package:not_another_weather_app/weather/views/routes/widget_overlay.dart';

class PageTwo extends StatefulWidget {
  final Geocoding geocoding;
  final bool isEditing;

  const PageTwo({required this.geocoding, required this.isEditing, super.key});

  @override
  State<PageTwo> createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  @override
  Widget build(BuildContext context) {
    void openWidgetDetail(WidgetItem selectedWidget) {
      Navigator.of(context).push(WidgetOverlay(
        overlayChild: DetailWidgetsOverlay(widget.geocoding, selectedWidget),
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: NavigationToolbar.kMiddleSpacing),
      child: StaggeredGrid.count(
        axisDirection: AxisDirection.down,
        crossAxisCount: 4,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        children: [
          for (int i = 0; i < widget.geocoding.detailWidgets.length; i++)
            StaggeredGridTile.count(
              crossAxisCellCount:
                  widget.geocoding.detailWidgets[i].size.colSpan,
              mainAxisCellCount: widget.geocoding.detailWidgets[i].size.rowSpan,
              child: Material(
                color: Colors.blue[900],
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: widget.isEditing ? null : Colors.transparent,
                  highlightColor: widget.isEditing ? null : Colors.transparent,
                  onTap: () {
                    if (widget.isEditing) {
                      openWidgetDetail(widget.geocoding.detailWidgets[i]);
                    }
                  },
                  child: widget.geocoding.detailWidgets[i].getWidget(),
                ),
              ),
            ),
        ],
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
