import 'package:flutter/material.dart';
import 'package:not_another_weather_app/weather/controllers/providers/current_geocoding_provider.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/weather_code.dart';
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

  void showSelectedFieldMenu(SelectableForecastFields field, bool isMainField) {
    List<SelectableForecastFields> fieldList = isMainField
        ? SelectableForecastFields.values
            .where((e) => e.mainFieldAccessible == true)
            .toList()
        : SelectableForecastFields.values;

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
      builder: (context, state, child) => Padding(
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
                              state.geocoding.forecast?.weatherCode),
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
                          state.geocoding.forecast?.weatherCode.description ??
                              "Unknown",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color: state.geocoding.forecast?.weatherCode
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
                      children: state.geocoding.selectedForecastItems
                          .map((e) => _weatherDetailItem(context, state, e))
                          .toList(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      if (state.isEditing) {
                        showSelectedFieldMenu(
                            state.geocoding.selectedMainField, true);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: state.isEditing
                              ? Colors.black
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "${state.geocoding.forecast?.getField(state.geocoding.selectedMainField) ?? "XX"}",
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  fontSize: 128,
                                  color: state.geocoding.forecast?.weatherCode
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
      ),
    );
  }

  Widget _weatherDetailItem(BuildContext context,
      CurrentGeocodingProvider provider, SelectableForecastFields field) {
    // TODO: Change to InkWell for pressure animation
    return GestureDetector(
      onTap: () {
        if (provider.isEditing) {
          showSelectedFieldMenu(field, false);
        }
      },
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: provider.isEditing ? Colors.black : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              field.icon,
              color: provider.geocoding.forecast?.weatherCode.colorScheme
                      .accentColor ??
                  Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              provider.geocoding.forecast?.getField(field).toString() ?? "XX",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: provider
                      .geocoding.forecast?.weatherCode.colorScheme.accentColor),
            ),
          ],
        ),
      ),
    );
  }
}
