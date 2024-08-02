import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:not_another_weather_app/weather/controllers/providers/current_geocoding_provider.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:provider/provider.dart';

class SelectableWidgetGrid extends StatefulWidget {
  final SelectableForecastFields fieldToReplace;

  const SelectableWidgetGrid({required this.fieldToReplace, super.key});

  @override
  State<SelectableWidgetGrid> createState() => _SelectableWidgetGridState();
}

class _SelectableWidgetGridState extends State<SelectableWidgetGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentGeocodingProvider>(
      builder: (context, state, child) {
        return Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: NavigationToolbar.kMiddleSpacing),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Replacing",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(color: Colors.white),
                        ),
                        Text(
                          widget.fieldToReplace.label,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: SelectableForecastFields.values.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 16 / 9,
                    ),
                    padding: EdgeInsets.only(
                      top: NavigationToolbar.kMiddleSpacing,
                      left: NavigationToolbar.kMiddleSpacing,
                      right: NavigationToolbar.kMiddleSpacing,
                      bottom: MediaQuery.of(context).padding.bottom,
                    ),
                    itemBuilder: (context, index) {
                      SelectableForecastFields forecastField =
                          SelectableForecastFields.values[index];

                      return AnimatedBuilder(
                        animation: _animationController,
                        child: _fieldCard(state, forecastField),
                        builder: (context, child) {
                          final animation = Tween<Offset>(
                                  begin: const Offset(0, 0.1), end: Offset.zero)
                              .animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(
                              index / SelectableForecastFields.values.length,
                              1.0,
                              curve: Curves.easeOut,
                            ),
                          ));

                          final opacity = Tween<double>(begin: 0.0, end: 1.0)
                              .animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(
                              (index / SelectableForecastFields.values.length),
                              1.0,
                              curve: Curves.easeIn,
                            ),
                          ));

                          return SlideTransition(
                            position: animation,
                            child: FadeTransition(
                              opacity: opacity,
                              child: child,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _fieldCard(CurrentGeocodingProvider provider,
      SelectableForecastFields forecastField) {
    int index = provider.geocoding.selectedForecastItems.indexOf(forecastField);
    bool isCurrentField = forecastField == widget.fieldToReplace;

    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Material(
          clipBehavior: Clip.hardEdge,
          color: isCurrentField ? Colors.white60 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            splashColor: isCurrentField ? Colors.transparent : null,
            highlightColor: isCurrentField ? Colors.transparent : null,
            onTap: isCurrentField
                ? null
                : () {
                    provider.replaceSecondaryField(
                      widget.fieldToReplace,
                      forecastField,
                    );

                    Navigator.of(context).pop(forecastField);
                  },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(forecastField.icon,
                    size: 28,
                    weight: 500,
                    color: isCurrentField ? Colors.black45 : Colors.black),
                Text(
                  forecastField.label,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isCurrentField ? Colors.black45 : Colors.black),
                ),
              ],
            ),
          ),
        ),
        index != -1
            ? Positioned(
                right: -10,
                top: -10,
                child: Material(
                  color: Colors.blue,
                  shape: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
