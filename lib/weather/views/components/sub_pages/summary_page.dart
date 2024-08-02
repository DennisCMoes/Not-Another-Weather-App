import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/extensions/color_extensions.dart';
import 'package:not_another_weather_app/weather/controllers/providers/current_geocoding_provider.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/weather_clipper.dart';
import 'package:not_another_weather_app/weather/views/components/overlays/selectable_widget_grid.dart';
import 'package:not_another_weather_app/weather/views/routes/widget_overlay.dart';
import 'package:provider/provider.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  late CurrentGeocodingProvider _geocodingProvider;

  void _showSelectedFieldMenu(
      SelectableForecastFields field, bool isMainField) {
    List<SelectableForecastFields> fieldList = isMainField
        ? SelectableForecastFields.values
            .where((e) => e.mainFieldAccessible == true)
            .toList()
        : SelectableForecastFields.values;

    // TODO: Return the value via the pop function
    Navigator.of(context).push(
      WidgetOverlay(
        overlayChild: ChangeNotifierProvider.value(
          value: _geocodingProvider,
          child: SelectableWidgetGrid(
            fieldToReplace: field,
            fields: fieldList,
            isMainField: isMainField,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _geocodingProvider =
        Provider.of<CurrentGeocodingProvider>(context, listen: false);
  }

  @override
  void dispose() {
    // TODO: Find another way to dispose of the provider without disposing it between subpages
    // _geocodingProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentGeocodingProvider>(
      builder: (context, state, child) {
        HourlyWeatherData? currentHourData =
            state.geocoding.forecast?.getCurrentHourData(state.selectedHour);
        Forecast? currentForecast = state.geocoding.forecast;

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
                            clipper: currentForecast
                                    ?.getClipperOfHour(state.selectedHour) ??
                                WeatherClipper.unknown.getClipper(),
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
                                            color: state
                                                .getWeatherColorScheme()
                                                .accent,
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
                            currentHourData?.weatherCode.description ??
                                "Unknown",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  color: state.getWeatherColorScheme().accent,
                                ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: state.geocoding.selectedForecastItems
                            .map((e) => _weatherDetailItem(context, state, e))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        final inAnimation = Tween<Offset>(
                          begin: const Offset(0.0, 1.0),
                          end: Offset.zero,
                        ).animate(animation);

                        final outAnimation = Tween<Offset>(
                          begin: const Offset(0.0, -1.0),
                          end: Offset.zero,
                        ).animate(animation);

                        ValueKey key = ValueKey(currentForecast?.getField(
                            SelectableForecastFields.temperature,
                            state.selectedHour));

                        // TODO: If the new value is lower slide in from the top, if larger slide in from the bottom
                        return ClipRect(
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              if (child.key != key)
                                SlideTransition(
                                    position: outAnimation, child: child),
                              if (child.key == key)
                                SlideTransition(
                                    position: inAnimation, child: child),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        "${currentForecast?.getField(SelectableForecastFields.temperature, state.selectedHour) ?? "XX"}",
                        key: ValueKey(currentForecast?.getField(
                            SelectableForecastFields.temperature,
                            state.selectedHour)),
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  fontSize: 128,
                                  color: state.getWeatherColorScheme().accent,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _weatherDetailItem(BuildContext context,
      CurrentGeocodingProvider provider, SelectableForecastFields field) {
    HourlyWeatherData? currentHour =
        provider.geocoding.forecast?.getCurrentHourData(provider.selectedHour);

    return GestureDetector(
      key: ValueKey(field),
      onTap: () {
        if (provider.isEditing) {
          _showSelectedFieldMenu(field, false);
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: provider.isEditing
                ? provider.getWeatherColorScheme().accent
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              field.icon,
              color: provider.getWeatherColorScheme().accent,
            ),
            const SizedBox(width: 6),
            Text(
              provider.geocoding.forecast
                      ?.getField(field, provider.selectedHour)
                      .toString() ??
                  "XX",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: provider.getWeatherColorScheme().accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
