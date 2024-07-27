import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/extensions/title_case.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/widget_item.dart';
import 'package:provider/provider.dart';

class DetailWidgetsOverlay extends StatefulWidget {
  final Geocoding geocoding;
  final WidgetItem selectedWidget;

  const DetailWidgetsOverlay(this.geocoding, this.selectedWidget, {super.key});

  @override
  State<DetailWidgetsOverlay> createState() => _DetailWidgetsOverlayState();
}

class _DetailWidgetsOverlayState extends State<DetailWidgetsOverlay> {
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
                _widgetSize(WidgetSize.small),
                const SizedBox(width: 6),
                _widgetSize(WidgetSize.medium),
                const SizedBox(width: 6),
                _widgetSize(WidgetSize.large),
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
                  _widgetType(WidgetType.values[index]),
            ),
          ),
        ],
      ),
    );
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

  Widget _widgetSize(WidgetSize size) {
    bool isSize = widget.selectedWidget.size == size;

    void setSize() {
      Provider.of<WeatherProvider>(context, listen: false).changeGeocodingSize(
        widget.geocoding,
        widget.selectedWidget,
        size,
      );
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

  Widget _widgetType(WidgetType type) {
    bool isType = widget.selectedWidget.type == type;

    void setType() {
      Provider.of<WeatherProvider>(context, listen: false)
          .changeGeocodingType(widget.geocoding, widget.selectedWidget, type);
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
