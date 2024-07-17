import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherHourCard extends StatelessWidget {
  final MapEntry<DateTime, double> hourlyTemp;

  const WeatherHourCard(this.hourlyTemp, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isCurrentHour() => DateTime.now().hour == hourlyTemp.key.hour;

    return SizedBox(
      width: 75,
      child: Material(
        color: isCurrentHour() ? Colors.green : Colors.blue,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(Icons.sunny),
            Text("${hourlyTemp.value.round()}º"),
            Text(DateFormat("HH").format(hourlyTemp.key))
          ],
        ),
      ),
    );
  }
}
