import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:not_another_weather_app/shared/utilities/providers/device_provider.dart';
import 'package:not_another_weather_app/weather/controllers/providers/current_geocoding_provider.dart';
import 'package:not_another_weather_app/weather/models/colorscheme.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/views/components/scaling_time_slider.dart';
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
  final PageController _timeController = PageController(viewportFraction: 0.2);

  bool _showTimeSlider = false;

  @override
  void initState() {
    super.initState();

    _geocodingProvider =
        Provider.of<CurrentGeocodingProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void toggleIsEditing() {
      HapticFeedback.lightImpact();
      _geocodingProvider.setIsEditing(!_geocodingProvider.isEditing);
    }

    void onChangeSelectedHour(int value) {
      _geocodingProvider.setSelectedHour(value);
    }

    void toggleTimeSlider() {
      setState(() {
        _showTimeSlider = !_showTimeSlider;
      });
    }

    void resetSelectedTime() {
      onChangeSelectedHour(DateTime.now().hour);

      setState(() {
        _showTimeSlider = false;
      });
    }

    bool currentHourIsSelected() {
      DateTime now = DateTime.now();
      DateTime currentHour = DateTime(now.year, now.month, now.day, now.hour);

      return currentHour == _geocodingProvider.selectedHour;
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
                // Top bar
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
                          currentHourIsSelected()
                              ? const SizedBox.shrink()
                              : IconButton(
                                  onPressed: resetSelectedTime,
                                  icon: Icon(
                                    Icons.restore,
                                    color: currentHourData?.weatherCode
                                            .colorScheme.accentColor ??
                                        Colors.black,
                                  ),
                                ),
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
                // Page view
                Expanded(
                  child: PageView(
                    controller: state.subPageController,
                    onPageChanged: (index) => state.setSubPageIndex(index),
                    children: const <Widget>[SummaryPage(), PageTwo()],
                  ),
                ),
                AnimatedContainer(
                  height: _showTimeSlider ? 75 : 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      height: 75,
                      width: MediaQuery.of(context).size.width,
                      child: ScalingTimeSlider(
                        onChange: onChangeSelectedHour,
                        colorScheme: currentHourData?.weatherCode.colorScheme ??
                            WeatherColorScheme.gray,
                      ),
                    ),
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
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: toggleTimeSlider,
                          icon: Icon(
                            Icons.schedule,
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
