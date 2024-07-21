import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/shared/utilities/providers/drawer_provider.dart';
import 'package:weather/weather/controllers/providers/weather_provider.dart';
import 'package:weather/weather/models/forecast.dart';
import 'package:weather/weather/models/geocoding.dart';

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
                state.geocodings.isNotEmpty
                    ? _weatherListTile(0, state.geocodings[0])
                    : const SizedBox.shrink(),
                const SizedBox(height: 12),
                ReorderableListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }

                    state.moveGeocodings(oldIndex + 1, newIndex + 1);
                  },
                  children: [
                    for (int i = 1; i < state.geocodings.length; i++)
                      _weatherListTile(i, state.geocodings[i]),
                  ],
                ),
                _addNewTile(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _addNewTile() {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(width: 1),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }

  Widget _weatherListTile(int index, Geocoding geocoding) {
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
      key: ValueKey(geocoding),
      color: geocoding.forecast?.weatherCode.colorScheme.mainColor ??
          Colors.blueGrey,
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
                    geocoding.name,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: geocoding.forecast?.weatherCode.colorScheme
                                  .accentColor ??
                              Colors.white,
                        ),
                  ),
                  Text(
                    geocoding.forecast?.weatherCode.description ?? "XX",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: geocoding.forecast?.weatherCode.colorScheme
                                  .accentColor ??
                              Colors.white,
                        ),
                  )
                ],
              ),
              Text(
                "${geocoding.forecast?.temperature.round() ?? "XX"}º",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: geocoding
                            .forecast?.weatherCode.colorScheme.accentColor ??
                        Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
