import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/extensions/title_case.dart';
import 'package:not_another_weather_app/weather/controllers/providers/current_geocoding_provider.dart';
import 'package:not_another_weather_app/weather/models/widget_item.dart';
import 'package:provider/provider.dart';

class DetailWidgetsOverlay extends StatefulWidget {
  final WidgetItem selectedWidget;

  const DetailWidgetsOverlay(this.selectedWidget, {super.key});

  @override
  State<DetailWidgetsOverlay> createState() => _DetailWidgetsOverlayState();
}

class _DetailWidgetsOverlayState extends State<DetailWidgetsOverlay> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentGeocodingProvider>(builder: (context, state, child) {
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
                  "Widget: ${widget.selectedWidget.id}",
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: Colors.white),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                )
              ],
            ),
            _sectionTitle(
              label: "Widget size",
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _widgetSize(state, WidgetSize.small),
                  const SizedBox(width: 6),
                  _widgetSize(state, WidgetSize.medium),
                  const SizedBox(width: 6),
                  _widgetSize(state, WidgetSize.large),
                ],
              ),
            ),
            _sectionTitle(
              label: "Widget type",
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemCount: WidgetType.values.length,
                itemBuilder: (context, index) =>
                    _widgetType(state, WidgetType.values[index]),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _sectionTitle({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _widgetSize(CurrentGeocodingProvider provider, WidgetSize size) {
    bool isSize = widget.selectedWidget.size == size;

    void setSize() {
      provider.setGeocodingSize(widget.selectedWidget, size);
      Navigator.of(context).pop();
    }

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Material(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(8),
          color: isSize ? Colors.white60 : Colors.white,
          child: InkWell(
            onTap: setSize,
            child: Center(
              child: Text(
                size.toString().toTitleCase(),
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _widgetType(CurrentGeocodingProvider provider, WidgetType type) {
    bool isType = widget.selectedWidget.type == type;

    void setType() {
      provider.setGeocodingType(widget.selectedWidget, type);
      Navigator.of(context).pop();
    }

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Material(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(8),
          color: isType ? Colors.white60 : Colors.white,
          child: InkWell(
            onTap: setType,
            child: Center(
              child: Text(type.toString().toTitleCase()),
            ),
          ),
        ),
      ),
    );
  }
}
