import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/shared/utilities/providers/drawer_provider.dart';
import 'package:weather/weather/models/forecast.dart';
import 'package:weather/weather/models/geocoding.dart';
import 'package:weather/weather/models/weather_code.dart';
import 'package:weather/weather/views/components/hour_card.dart';

class ForecastCard extends StatefulWidget {
  final Geocoding _geocoding;

  const ForecastCard(this._geocoding, {super.key});

  @override
  State<ForecastCard> createState() => ForecastCardState();
}

class ForecastCardState extends State<ForecastCard> {
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: ClipPath(
                        clipper: WeatherCode.getClipper(
                            widget._geocoding.forecast!.weatherCode),
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
                                            .forecast!
                                            .weatherCode
                                            .colorScheme
                                            .accentColor,
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
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  weatherDetail(
                    "Wind",
                    "${widget._geocoding.forecast?.windSpeed.round() ?? "XX"}km/h",
                  ),
                  VerticalDivider(
                    color: widget._geocoding.forecast?.weatherCode.colorScheme
                        .accentColor
                        .withOpacity(0.6),
                  ),
                  weatherDetail(
                    "Pressure",
                    "${widget._geocoding.forecast?.pressure.round() ?? "XX"} mbar",
                  ),
                  VerticalDivider(
                    color: widget._geocoding.forecast?.weatherCode.colorScheme
                        .accentColor
                        .withOpacity(0.6),
                  ),
                  weatherDetail(
                    "Humidity",
                    "${widget._geocoding.forecast?.humidity ?? "XX"}%",
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 6),
            // const SizedBox(
            //   height: 150,
            //   child: Material(
            //     color: Colors.amber,
            //     child: Text("Chart"),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget weatherDetail(String description, String value) {
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
}
