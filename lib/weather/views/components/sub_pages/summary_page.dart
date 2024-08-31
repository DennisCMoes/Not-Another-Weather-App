import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:not_another_weather_app/shared/extensions/color_extensions.dart';
import 'package:not_another_weather_app/shared/extensions/context_extensions.dart';
import 'package:not_another_weather_app/weather/controllers/providers/forecast_card_provider.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/logics/selectable_forecast_fields.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/views/components/overlays/selectable_widget_grid.dart';
import 'package:not_another_weather_app/shared/views/overlays/modal_overlay.dart';
import 'package:provider/provider.dart';

class SummaryPage extends StatefulWidget {
  final Geocoding geocoding;

  const SummaryPage({super.key, required this.geocoding});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  late ForecastCardProvider _geocodingProvider;
  late Forecast _forecast;

  @override
  void initState() {
    super.initState();

    _forecast = widget.geocoding.forecast;
    _geocodingProvider = context.read<ForecastCardProvider>();
  }

  @override
  void dispose() {
    // TODO: Find another way to dispose of the provider without disposing it between subpages
    // _geocodingProvider.dispose();
    super.dispose();
  }

  void _showSelectedFieldMenu(
    SelectableForecastFields field,
    bool isMainField,
  ) {
    HapticFeedback.lightImpact();

    Navigator.of(context).push(
      ModalOverlay(
        overlayChild: ChangeNotifierProvider.value(
          value: _geocodingProvider,
          child: SelectableWidgetGrid(fieldToReplace: field),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ForecastCardProvider>(
      builder: (context, state, child) {
        final colorPair = _forecast.getColorPair(state.selectedHour);
        final weatherData = _forecast.getCurrentHourData(state.selectedHour);

        bool isInvalidCurrent = state.geocoding.isCurrentLocation &&
            state.geocoding.latitude == -1 &&
            state.geocoding.longitude == -1;

        if (isInvalidCurrent) {
          return noLocationCard(context);
        }

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
                            clipper: _forecast.getClipperOfHour(
                              state.selectedHour,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              height: MediaQuery.of(context).size.width - 100,
                              child: RepaintBoundary(
                                child: CustomScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  slivers: [
                                    SliverGrid(
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) => ClipOval(
                                          child: Material(
                                            color: colorPair.accent,
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
                            weatherData.weatherCode.description,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(color: colorPair.accent),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom Text
              IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: state.geocoding.selectedForecastItems
                              .map((e) => _weatherDetailItem(
                                  context, state, _forecast, e))
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

                          ValueKey key = ValueKey(_forecast.getField(
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
                          "${_forecast.getField(SelectableForecastFields.temperature, state.selectedHour) ?? "XX"}",
                          key: ValueKey(_forecast.getField(
                              SelectableForecastFields.temperature,
                              state.selectedHour)),
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                fontSize: 128,
                                color: colorPair.accent,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _weatherDetailItem(
    BuildContext context,
    ForecastCardProvider provider,
    Forecast forecast,
    SelectableForecastFields field,
  ) {
    final colorPair = forecast.getColorPair(provider.selectedHour);

    return Material(
      key: ValueKey(field),
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: InkWell(
        splashColor: colorPair.main.darkenColor(0.1),
        highlightColor: Colors.transparent,
        onTap: provider.isEditing
            ? () => _showSelectedFieldMenu(field, false)
            : null,
        child: DottedBorder(
          color: provider.isEditing ? colorPair.accent : Colors.transparent,
          strokeWidth: 3,
          radius: const Radius.circular(8),
          dashPattern: const [4],
          borderType: BorderType.RRect,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  field.icon,
                  color: colorPair.accent,
                ),
                const SizedBox(width: 6),
                Text(
                  forecast.getField(field, provider.selectedHour).toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colorPair.accent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget noLocationCard(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            TablerIcons.location_off,
            size: 64,
          ),
          Text(
            "Location services are turned off",
            style: context.textTheme.displayMedium,
          ),
          TextButton(
            onPressed: () async => await Geolocator.openLocationSettings(),
            style: TextButton.styleFrom(
              side: const BorderSide(width: 2),
            ),
            child: const Text("Open Settings"),
          )
        ],
      ),
    );
  }
}
