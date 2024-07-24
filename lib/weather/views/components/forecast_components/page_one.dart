import 'package:flutter/material.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/weather_code.dart';

class PageOne extends StatefulWidget {
  final Geocoding geocoding;

  const PageOne({required this.geocoding, super.key});

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  bool isEditing = false;

  void toggleIsEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void showSelectedFieldMenu(SelectableForecastFields field, bool isMainField) {
    List<SelectableForecastFields> fieldList = isMainField
        ? SelectableForecastFields.values
            .where((e) => e.mainFieldAccessible == true)
            .toList()
        : SelectableForecastFields.values;

    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Padding(
          padding: const EdgeInsets.all(NavigationToolbar.kMiddleSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Replacing ${field.label.toLowerCase()}"),
              Expanded(
                child: GridView.builder(
                  itemCount: fieldList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 21 / 9,
                  ),
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
                  itemBuilder: (context, index) {
                    SelectableForecastFields forecastField = fieldList[index];
                    bool alreadyIncluded;

                    if (isMainField) {
                      alreadyIncluded =
                          widget.geocoding.selectedMainField == forecastField;
                    } else {
                      alreadyIncluded = widget.geocoding.selectedForecastItems
                          .contains(forecastField);
                    }

                    return Material(
                      color:
                          alreadyIncluded ? Colors.blue[200] : Colors.blue[800],
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        splashColor:
                            alreadyIncluded ? Colors.transparent : null,
                        highlightColor:
                            alreadyIncluded ? Colors.transparent : null,
                        onTap: () {
                          if (alreadyIncluded) {
                            return;
                          }

                          if (isMainField) {
                            setState(() {
                              widget.geocoding.selectedMainField =
                                  forecastField;
                            });
                          } else {
                            int index = widget.geocoding.selectedForecastItems
                                .indexOf(field);

                            setState(() {
                              widget.geocoding.selectedForecastItems[index] =
                                  forecastField;
                            });
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
              ),
            ],
          ),
        ),
      ),
    );
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
                IconButton(
                  onPressed: toggleIsEditing,
                  icon: Icon(
                    isEditing ? Icons.edit_off : Icons.edit,
                    color: widget.geocoding.forecast?.weatherCode.colorScheme
                            .accentColor ??
                        Colors.grey,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
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
                    if (isEditing) {
                      showSelectedFieldMenu(
                          widget.geocoding.selectedMainField, true);
                    }
                  },
                  child: Container(
                    decoration: isEditing
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

  // Widget _weatherDetailItem(BuildContext context, IconData icon, String value) {
  Widget _weatherDetailItem(
      BuildContext context, SelectableForecastFields field) {
    return GestureDetector(
      onTap: () {
        if (isEditing) {
          showSelectedFieldMenu(field, false);
        }
      },
      child: Container(
        decoration: isEditing
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
