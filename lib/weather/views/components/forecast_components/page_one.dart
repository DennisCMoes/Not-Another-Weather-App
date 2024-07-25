import 'package:flutter/material.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/weather_code.dart';
import 'package:not_another_weather_app/weather/views/components/forecast_components/selectable_widget_grid.dart';
import 'package:not_another_weather_app/weather/views/routes/widget_overlay.dart';

class PageOne extends StatefulWidget {
  final Geocoding geocoding;
  final bool isEditing;

  const PageOne({required this.geocoding, required this.isEditing, super.key});

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  void showSelectedFieldMenu(SelectableForecastFields field, bool isMainField) {
    List<SelectableForecastFields> fieldList = isMainField
        ? SelectableForecastFields.values
            .where((e) => e.mainFieldAccessible == true)
            .toList()
        : SelectableForecastFields.values;

    Navigator.of(context).push(
      WidgetOverlay(
        overlayChild: SelectableWidgetGrid(
          geocoding: widget.geocoding,
          fieldToReplace: field,
          fields: fieldList,
          isMainField: isMainField,
        ),
      ),
    );

    return;
  }

  @override
  Widget build(BuildContext context) {
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
                        clipper: WeatherCode.getClipper(
                            widget.geocoding.forecast?.weatherCode),
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
                                                .geocoding
                                                .forecast
                                                ?.weatherCode
                                                .colorScheme
                                                .accentColor ??
                                            Colors.black,
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
                        widget.geocoding.forecast?.weatherCode.description ??
                            "Unknown",
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  color: widget.geocoding.forecast?.weatherCode
                                          .colorScheme.accentColor ??
                                      Colors.white,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: widget.geocoding.selectedForecastItems
                        .map((e) => _weatherDetailItem(context, e))
                        .toList(),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    if (widget.isEditing) {
                      showSelectedFieldMenu(
                          widget.geocoding.selectedMainField, true);
                    }
                  },
                  child: Container(
                    decoration: widget.isEditing
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black, width: 1))
                        : null,
                    child: Text(
                      "${widget.geocoding.forecast?.getField(widget.geocoding.selectedMainField) ?? "XX"}",
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontSize: 128,
                            color: widget.geocoding.forecast?.weatherCode
                                    .colorScheme.accentColor ??
                                Colors.white,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _weatherDetailItem(
      BuildContext context, SelectableForecastFields field) {
    return GestureDetector(
      onTap: () {
        if (widget.isEditing) {
          showSelectedFieldMenu(field, false);
        }
      },
      child: Container(
        width: 100,
        decoration: widget.isEditing
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black, width: 1))
            : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              field.icon,
              color: widget.geocoding.forecast?.weatherCode.colorScheme
                      .accentColor ??
                  Colors.white,
            ),
            Text(
              widget.geocoding.forecast?.getField(field).toString() ?? "XX",
              // field.label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: widget
                      .geocoding.forecast?.weatherCode.colorScheme.accentColor),
            ),
          ],
        ),
      ),
    );
  }
}
