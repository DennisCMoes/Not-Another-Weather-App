import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/shared/utilities/providers/drawer_provider.dart';
import 'package:weather/weather/controllers/providers/weather_provider.dart';
import 'package:weather/weather/models/forecast.dart';

class WeatherDrawer extends StatefulWidget {
  const WeatherDrawer({super.key});

  @override
  State<WeatherDrawer> createState() => _WeatherDrawerState();
}

class _WeatherDrawerState extends State<WeatherDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: NavigationToolbar.kMiddleSpacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Locations",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: state.forecasts.length,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      _weatherListTile(index, state.forecasts[index]),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _weatherListTile(int index, Forecast forecast) {
    void goToPage() {
      Provider.of<WeatherProvider>(context, listen: false)
          .pageController
          .animateToPage(
            index,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 600),
          );

      Provider.of<DrawerProvider>(context, listen: false).closeDrawer();
    }

    return Material(
      color: forecast.weatherCode.colorScheme.mainColor,
      clipBehavior: Clip.hardEdge,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: InkWell(
        onTap: goToPage,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Amsterdam",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: forecast.weatherCode.colorScheme.accentColor),
                  ),
                  Text(
                    forecast.weatherCode.description,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: forecast.weatherCode.colorScheme.accentColor),
                  )
                ],
              ),
              Text(
                "${forecast.temperature.round()}º",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: forecast.weatherCode.colorScheme.accentColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
