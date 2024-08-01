import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:not_another_weather_app/shared/extensions/color_extensions.dart';
import 'package:not_another_weather_app/weather/controllers/providers/current_geocoding_provider.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/widget_item.dart';
import 'package:not_another_weather_app/weather/views/components/overlays/detail_widgets_overlay.dart';
import 'package:not_another_weather_app/weather/views/routes/widget_overlay.dart';
import 'package:provider/provider.dart';

class PageTwo extends StatefulWidget {
  const PageTwo({super.key});

  @override
  State<PageTwo> createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  late CurrentGeocodingProvider _geocodingProvider;

  @override
  void initState() {
    _geocodingProvider =
        Provider.of<CurrentGeocodingProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: Find another way to dispose of the provider without disposing it between subpages
    // _geocodingProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void openWidgetDetail(WidgetItem selectedWidget) {
      Navigator.of(context).push(
        WidgetOverlay(
          overlayChild: ChangeNotifierProvider.value(
            value: _geocodingProvider,
            child: DetailWidgetsOverlay(selectedWidget),
          ),
        ),
      );
    }

    return Consumer<CurrentGeocodingProvider>(
      builder: (context, state, child) {
        HourlyWeatherData? currentHourData =
            state.geocoding.forecast?.getCurrentHourData(state.selectedHour);

        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: NavigationToolbar.kMiddleSpacing, vertical: 6),
          child: StaggeredGrid.count(
            axisDirection: AxisDirection.down,
            crossAxisCount: 4,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            children: [
              for (int i = 0; i < state.geocoding.detailWidgets.length; i++)
                StaggeredGridTile.count(
                  crossAxisCellCount:
                      state.geocoding.detailWidgets[i].size.colSpan,
                  mainAxisCellCount:
                      state.geocoding.detailWidgets[i].size.rowSpan,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        width: 2,
                        color:
                            state.getWeatherColorScheme().main.darkenColor(0.1),
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: state.isEditing ? null : Colors.transparent,
                      highlightColor:
                          state.isEditing ? null : Colors.transparent,
                      onTap: () {
                        if (state.isEditing) {
                          openWidgetDetail(state.geocoding.detailWidgets[i]);
                        }
                      },
                      child: state.geocoding.detailWidgets[i]
                          .getWidget(state.geocoding),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
