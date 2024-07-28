import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/utilities/providers/device_provider.dart';
import 'package:not_another_weather_app/weather/controllers/providers/current_geocoding_provider.dart';
import 'package:not_another_weather_app/weather/views/components/sub_pages/summary_page.dart';
import 'package:not_another_weather_app/weather/views/components/sub_pages/details_page.dart';
import 'package:provider/provider.dart';
import 'package:not_another_weather_app/shared/utilities/providers/drawer_provider.dart';

class ForecastCard extends StatefulWidget {
  const ForecastCard({super.key});

  @override
  State<ForecastCard> createState() => ForecastCardState();
}

class ForecastCardState extends State<ForecastCard> {
  late CurrentGeocodingProvider _geocodingProvider;

  final List<String> _subPageButtonLabels = ["Summary", "Details"];

  @override
  void initState() {
    super.initState();
    _geocodingProvider =
        Provider.of<CurrentGeocodingProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _geocodingProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void toggleIsEditing() {
      _geocodingProvider.setIsEditing(!_geocodingProvider.isEditing);
    }

    return Consumer<CurrentGeocodingProvider>(
      builder: (context, state, child) => ColoredBox(
        color: state.geocoding.forecast?.weatherCode.colorScheme.mainColor ??
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    state.geocoding.forecast == null
                        ? Text("Loading",
                            style: Theme.of(context).textTheme.displayLarge)
                        : Text(
                            state.geocoding.name,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  color: state.geocoding.forecast!.weatherCode
                                      .colorScheme.accentColor,
                                ),
                          ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Provider.of<DeviceProvider>(context).hasInternet
                            ? const SizedBox.shrink()
                            : const Icon(
                                Icons.signal_wifi_connected_no_internet_4),
                        IconButton(
                          onPressed: () {
                            Provider.of<DrawerProvider>(context, listen: false)
                                .openDrawer();
                          },
                          visualDensity: VisualDensity.compact,
                          icon: Icon(Icons.reorder,
                              color: state.geocoding.forecast?.weatherCode
                                      .colorScheme.accentColor ??
                                  Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: state.subPageController,
                  onPageChanged: (index) => state.setSubPageIndex(index),
                  children: const <Widget>[SummaryPage(), PageTwo()],
                ),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: toggleIsEditing,
                        icon: Icon(
                          state.isEditing ? Icons.edit_off : Icons.edit,
                          color: state.geocoding.forecast?.weatherCode
                                  .colorScheme.accentColor ??
                              Colors.black,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          _subPageButtonLabels.length,
                          (index) => GestureDetector(
                            onTap: () {
                              state.subPageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              transform: state.isCurrentPage(index)
                                  ? Matrix4.identity()
                                  : (Matrix4.identity()..scale(0.9)),
                              child: Text(
                                _subPageButtonLabels[index],
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                        color: state.isCurrentPage(index)
                                            ? Colors.black
                                            : Colors.black45),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
