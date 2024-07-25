import 'package:flutter/material.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:provider/provider.dart';

class SelectableWidgetGrid extends StatefulWidget {
  final Geocoding geocoding;
  final SelectableForecastFields fieldToReplace;
  final List<SelectableForecastFields> fields;
  final bool isMainField;

  const SelectableWidgetGrid(
      {required this.geocoding,
      required this.fieldToReplace,
      required this.fields,
      required this.isMainField,
      super.key});

  @override
  State<SelectableWidgetGrid> createState() => _SelectableWidgetGridState();
}

class _SelectableWidgetGridState extends State<SelectableWidgetGrid> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: NavigationToolbar.kMiddleSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Replacing ${widget.fieldToReplace.label}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: widget.fields.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 16 / 9,
              ),
              itemBuilder: (context, index) {
                SelectableForecastFields forecastField = widget.fields[index];
                bool alreadyIncluded;

                if (widget.isMainField) {
                  alreadyIncluded =
                      widget.geocoding.selectedMainField == forecastField;
                } else {
                  alreadyIncluded = widget.geocoding.selectedForecastItems
                      .contains(forecastField);
                }

                return Material(
                  color: alreadyIncluded ? Colors.blue[200] : Colors.blue[800],
                  borderRadius: BorderRadius.circular(8),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: alreadyIncluded ? Colors.transparent : null,
                    highlightColor: alreadyIncluded ? Colors.transparent : null,
                    onTap: () {
                      if (alreadyIncluded) {
                        return;
                      }

                      if (widget.isMainField) {
                        Provider.of<WeatherProvider>(context, listen: false)
                            .changeSelectedMainField(
                                widget.geocoding, forecastField);
                      } else {
                        int index = widget.geocoding.selectedForecastItems
                            .indexOf(widget.fieldToReplace);

                        Provider.of<WeatherProvider>(context, listen: false)
                            .replaceSelectedForecastItem(
                                widget.geocoding, forecastField, index);
                      }

                      Navigator.of(context).pop();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(forecastField.icon,
                            color: alreadyIncluded
                                ? Colors.white54
                                : Colors.white),
                        Text(forecastField.label,
                            style: TextStyle(
                                color: alreadyIncluded
                                    ? Colors.white54
                                    : Colors.white)),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
