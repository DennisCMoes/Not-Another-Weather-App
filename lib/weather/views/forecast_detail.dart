import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:not_another_weather_app/shared/extensions/color_extensions.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/logics/selectable_forecast_fields.dart';
import 'package:not_another_weather_app/weather/models/weather/colorscheme.dart';

class ForecastDetail extends StatefulWidget {
  final bool isEditing;
  final Geocoding geocoding;
  final SelectableForecastFields field;
  final ColorPair colorPair;
  final DateTime selectedTime;

  const ForecastDetail({
    super.key,
    required this.isEditing,
    required this.field,
    required this.geocoding,
    required this.colorPair,
    required this.selectedTime,
  });

  @override
  State<ForecastDetail> createState() => _ForecastDetailState();
}

class _ForecastDetailState extends State<ForecastDetail> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          widget.field.icon,
          color: widget.colorPair.secondary,
        ),
        const SizedBox(width: 6),
        Text(
          widget.geocoding.forecast.getField(widget.field, widget.selectedTime),
          style: TextStyle(
            color: widget.colorPair.secondary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
