import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:not_another_weather_app/shared/extensions/context_extensions.dart';
import 'package:not_another_weather_app/weather/controllers/providers/forecast_card_provider.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/views/home.dart';
import 'package:provider/provider.dart';

class GeocodingTile extends StatefulWidget {
  final int pageIndex;
  final Geocoding geocoding;

  const GeocodingTile(
      {super.key, required this.pageIndex, required this.geocoding});

  @override
  State<GeocodingTile> createState() => _GeocodingTileState();
}

class _GeocodingTileState extends State<GeocodingTile> {
  void _goToPage() {
    HapticFeedback.lightImpact();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) {
          return HomeScreen(initialIndex: widget.pageIndex);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                ),
              ),
              child: child,
            ),
          );
        },
      ),
    );

    context.read<ForecastCardProvider>().setGeocoding(widget.geocoding);
  }

  @override
  Widget build(BuildContext context) {
    final colorPair = widget.geocoding.forecast.getColorPair();
    final currentHourly = widget.geocoding.forecast.getCurrentHourData();

    return Hero(
      tag: 'geocoding-${widget.geocoding.id}',
      child: Material(
        color: colorPair.main,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.hardEdge,
        // TODO: Change to GestureDetector with pressing down animations
        child: InkWell(
          onTap: _goToPage,
          child: SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "${currentHourly.temperature.round()}º",
                      style: context.textTheme.displayLarge!.copyWith(
                        color: colorPair.accent,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      widget.geocoding.name,
                      style: context.textTheme.displaySmall!.copyWith(
                        color: colorPair.accent,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
