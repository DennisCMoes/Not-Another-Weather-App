import 'package:flutter/material.dart';
import 'package:not_another_weather_app/menu/models/units.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnitTileComponent<T extends IUnit> extends StatefulWidget {
  final String label;
  final String sharedPreferenceKey;
  final IconData icon;
  final List<T> enumValues;

  const UnitTileComponent(
      this.label, this.sharedPreferenceKey, this.icon, this.enumValues,
      {super.key});

  @override
  State<UnitTileComponent> createState() => _UnitTileComponentState();
}

class _UnitTileComponentState extends State<UnitTileComponent> {
  late IUnit _selected;
  late List<IUnit> _values;

  @override
  void initState() {
    super.initState();

    _values = widget.enumValues;
    _selected = widget.enumValues.first;

    initialize();
  }

  void initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var valueIndex = prefs.getInt(widget.sharedPreferenceKey);

    setState(() {
      _values = widget.enumValues;
      _selected = widget.enumValues[valueIndex ?? 0];
    });
  }

  void _cycleUnit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int currentIndex = _values.indexOf(_selected);
    int nextIndex = (currentIndex + 1) % _values.length;

    setState(() {
      _selected = _values[nextIndex];
      prefs.setInt(widget.sharedPreferenceKey, nextIndex);
    });

    if (mounted) context.read<WeatherProvider>().refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.icon),
      onTap: _cycleUnit,
      title: Text(widget.label),
      trailing: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.enumValues.length,
        separatorBuilder: (context, index) => const Center(child: Text(" | ")),
        itemBuilder: (context, index) {
          bool isSelected = _selected == _values[index];

          return Center(
            child: Text(
              widget.enumValues[index].label,
              style: TextStyle(
                  color: isSelected ? Colors.black : Colors.black54,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
            ),
          );
        },
      ),
    );
  }
}
