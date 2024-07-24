import 'package:flutter/material.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/weather_code.dart';

class PageOne extends StatelessWidget {
  final Geocoding geocoding;

  const PageOne({required this.geocoding, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipPath(
                        clipper: WeatherCode.getClipper(
                            geocoding.forecast?.weatherCode),
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
                                        color: geocoding.forecast?.weatherCode
                                                .colorScheme.accentColor ??
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
                      Text(
                        geocoding.forecast?.weatherCode.description ??
                            "Unknown",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _weatherDetailItem(
                        // "Wind",
                        Icons.air,
                        "${geocoding.forecast?.windSpeed.round() ?? "XX"}km/h",
                      ),
                      _weatherDetailItem(
                        // "Rain in MM",
                        Icons.water_drop_outlined,
                        "${geocoding.forecast?.getCurrentHourData().rainInMM ?? "XX"}mm",
                      ),
                      _weatherDetailItem(
                          // "Chance of rain",
                          Icons.umbrella,
                          "${geocoding.forecast?.getCurrentHourData().rainProbability ?? "XX"}%"),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "${geocoding.forecast?.temperature.round() ?? "XX"}º",
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 128),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _weatherDetailItem(IconData icon, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: geocoding.forecast?.weatherCode.colorScheme.accentColor),
        ),
      ],
    );
  }
}
