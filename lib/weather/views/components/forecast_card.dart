import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:not_another_weather_app/shared/extensions/color_extensions.dart';
import 'package:not_another_weather_app/shared/utilities/providers/device_provider.dart';
import 'package:not_another_weather_app/weather/controllers/providers/current_geocoding_provider.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/views/components/slider/hour_slider_thumb_shape.dart';
import 'package:not_another_weather_app/weather/views/components/slider/hour_slider_track_shape.dart';
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

  double _currentSliderValue = 0;

  @override
  void initState() {
    super.initState();

    _currentSliderValue = DateTime.now().hour.toDouble();
    _geocodingProvider =
        Provider.of<CurrentGeocodingProvider>(context, listen: false);
  }

  @override
  void dispose() {
    // _geocodingProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void toggleIsEditing() {
      HapticFeedback.lightImpact();
      _geocodingProvider.setIsEditing(!_geocodingProvider.isEditing);
    }

    void onChangeSelectedHour(double value) {
      setState(() {
        _currentSliderValue = value;
      });

      _geocodingProvider.setSelectedHour(value.toInt());
    }

    return Consumer<CurrentGeocodingProvider>(
      builder: (context, state, child) {
        HourlyWeatherData? currentHourData = state.geocoding.forecast
            ?.getCurrentHourData(state.selectedHour.hour);

        return ColoredBox(
          color: currentHourData?.weatherCode.colorScheme.mainColor ??
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
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.geocoding.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        color: currentHourData?.weatherCode
                                            .colorScheme.accentColor,
                                      ),
                                ),
                                Text(
                                  "Today at ${state.selectedHour.hour}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                        color: currentHourData?.weatherCode
                                            .colorScheme.accentColor
                                            .withOpacity(0.6),
                                      ),
                                ),
                              ],
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
                              Provider.of<DrawerProvider>(context,
                                      listen: false)
                                  .openDrawer();
                            },
                            visualDensity: VisualDensity.compact,
                            icon: Icon(Icons.reorder,
                                color: currentHourData
                                        ?.weatherCode.colorScheme.accentColor ??
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
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                            thumbColor: currentHourData
                                ?.weatherCode.colorScheme.mainColor
                                .darkenColor(0.4),
                            activeTrackColor: currentHourData
                                ?.weatherCode.colorScheme.mainColor
                                .darkenColor(0.1),
                            trackShape: HourSliderTrackShape(),
                            thumbShape: HourSliderThumbShape(),
                            // tickMarkShape: HourSliderTickShape(),
                          ),
                          child: Slider(
                            value: _currentSliderValue,
                            max: 23,
                            divisions: 23,
                            onChanged: onChangeSelectedHour,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed:
                            _currentSliderValue.toInt() == DateTime.now().hour
                                ? null
                                : () => onChangeSelectedHour(
                                    DateTime.now().hour.toDouble()),
                        visualDensity: VisualDensity.compact,
                        disabledColor: currentHourData
                            ?.weatherCode.colorScheme.accentColor
                            .withOpacity(0.4),
                        color: currentHourData
                            ?.weatherCode.colorScheme.accentColor,
                        icon: const Icon(Icons.restore),
                      ),
                    ],
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
                            color: currentHourData
                                    ?.weatherCode.colorScheme.accentColor ??
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
        );
      },
    );
  }
}
