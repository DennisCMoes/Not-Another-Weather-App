import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:not_another_weather_app/shared/extensions/context_extensions.dart';
import 'package:not_another_weather_app/weather/controllers/providers/forecast_card_provider.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/views/home.dart';
import 'package:provider/provider.dart';

class GeocodingTile extends StatefulWidget {
  final int pageIndex;
  final Geocoding geocoding;
  final bool isEditing;

  const GeocodingTile({
    super.key,
    required this.pageIndex,
    required this.geocoding,
    required this.isEditing,
  });

  @override
  State<GeocodingTile> createState() => _GeocodingTileState();
}

class _GeocodingTileState extends State<GeocodingTile> {
  late WeatherProvider _weatherProvider;

  @override
  void initState() {
    super.initState();

    _weatherProvider = context.read<WeatherProvider>();
  }

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
            child: child,
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
        child: InkWell(
          onTap: () => widget.isEditing
              ? _weatherProvider.removeGeocoding(widget.geocoding)
              : _goToPage(),
          child: SizedBox(
            height: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${currentHourly.temperature.round()}º",
                          style: context.textTheme.displayLarge!
                              .copyWith(color: colorPair.accent),
                        ),
                        Text(
                          currentHourly.weatherCode.description,
                          style: context.textTheme.displaySmall!
                              .copyWith(color: colorPair.accent, fontSize: 14),
                        ),
                        Text(
                          widget.geocoding.name,
                          style: context.textTheme.displaySmall!
                              .copyWith(color: colorPair.accent, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.isEditing
                    ? const Positioned.fill(
                        child: Material(
                          color: Colors.black54,
                          child: Center(
                            child: Icon(
                              Icons.delete,
                              size: 58,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
