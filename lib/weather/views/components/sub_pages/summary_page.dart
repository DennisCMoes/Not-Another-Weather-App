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
  final DateTime forecastHour;

  const SummaryPage(
      {super.key, required this.geocoding, required this.forecastHour});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  late Forecast _forecast;

  @override
  void initState() {
    super.initState();

    _forecast = widget.geocoding.forecast;
  }

  @override
  void dispose() {
    // TODO: Find another way to dispose of the provider without disposing it between subpages
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
          value: context.read<ForecastCardProvider>(),
          child: SelectableWidgetGrid(
            geocoding: widget.geocoding,
            fieldToReplace: field,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ForecastCardProvider>(
      builder: (context, state, child) {
        final colorPair = _forecast.getColorPair(widget.forecastHour);
        final weatherData = _forecast.getCurrentHourData(widget.forecastHour);

        bool isInvalidCurrent = widget.geocoding.isCurrentLocation &&
            widget.geocoding.latitude == -1 &&
            widget.geocoding.longitude == -1;

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
                              widget.forecastHour,
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
                                            color: colorPair.secondary,
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
                                .copyWith(color: colorPair.secondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom Text
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: widget.geocoding.selectedForecastItems
                            .map((e) => _weatherDetailItem(
                                context, state, _forecast, e))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "${_forecast.getField(SelectableForecastFields.temperature, widget.forecastHour) ?? "XX"}",
                      key: ValueKey(_forecast.getField(
                          SelectableForecastFields.temperature,
                          widget.forecastHour)),
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontSize: 128, color: colorPair.secondary),
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

  Widget _weatherDetailItem(
    BuildContext context,
    ForecastCardProvider provider,
    Forecast forecast,
    SelectableForecastFields field,
  ) {
    final colorPair = forecast.getColorPair(widget.forecastHour);

    return Material(
      key: ValueKey(field),
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: InkWell(
        splashColor: colorPair.primary.darkenColor(0.1),
        highlightColor: Colors.transparent,
        onTap: provider.isEditing
            ? () => _showSelectedFieldMenu(field, false)
            : null,
        child: DottedBorder(
          color: provider.isEditing ? colorPair.secondary : Colors.transparent,
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
                  color: colorPair.secondary,
                ),
                const SizedBox(width: 6),
                Text(
                  forecast.getField(field, widget.forecastHour).toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colorPair.secondary,
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
