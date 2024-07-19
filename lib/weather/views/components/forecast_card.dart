import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/shared/utilities/providers/drawer_provider.dart';
import 'package:weather/weather/models/forecast.dart';
import 'package:weather/weather/views/components/hour_card.dart';

class ForecastCard extends StatefulWidget {
  final Forecast? _forecast;

  const ForecastCard(this._forecast, {super.key});

  @override
  State<ForecastCard> createState() => ForecastCardState();
}

class ForecastCardState extends State<ForecastCard> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: widget._forecast?.weatherCode.colorScheme.mainColor ??
          Colors.grey.withOpacity(0.4),
      child: Padding(
        padding: EdgeInsets.only(
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          children: [
            SizedBox(
              height: Theme.of(context).appBarTheme.toolbarHeight,
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: NavigationToolbar.kMiddleSpacing,
                  right: NavigationToolbar.kMiddleSpacing,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: widget._forecast == null
                          ? Text("Loading",
                              style: Theme.of(context).textTheme.displayLarge)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget._forecast!.temperature.round()}º",
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                                Text(
                                  widget._forecast!.weatherCode.description
                                      .toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                        color: Colors.black45,
                                      ),
                                ),
                              ],
                            ),
                    ),
                    IconButton(
                      // onPressed: () => Scaffold.of(context).openEndDrawer(),
                      onPressed: () {
                        Provider.of<DrawerProvider>(context, listen: false)
                            .openDrawer();
                      },
                      icon: const Icon(Icons.reorder),
                    ),
                    // Text("Right")
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 24.0,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Material(
                            color: widget
                                ._forecast?.weatherCode.colorScheme.accentColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(18),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              weatherDetail(
                                "Wind",
                                "${widget._forecast?.windSpeed.round() ?? "XX"}km/h",
                              ),
                              const VerticalDivider(color: Colors.black54),
                              weatherDetail(
                                "Pressure",
                                "${widget._forecast?.pressure.round() ?? "XX"} mbar",
                              ),
                              const VerticalDivider(color: Colors.black54),
                              weatherDetail(
                                "Humidity",
                                "${widget._forecast?.humidity ?? "XX"}%",
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.separated(
                shrinkWrap: true,
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: widget._forecast?.hourlyTemperatures.length ?? 0,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) => WeatherHourCard(
                  widget._forecast!.hourlyTemperatures.entries.elementAt(index),
                ),
              ),
            )
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(description),
      ],
    );
  }
}
