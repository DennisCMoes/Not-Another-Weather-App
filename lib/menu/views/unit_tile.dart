import 'package:flutter/material.dart';
import 'package:not_another_weather_app/menu/models/units.dart';

class UnitTileComponent<T> extends StatefulWidget {
  final String label;
  final IconData icon;
  final IUnit initialValue;
  final List<IUnit> enumValues;

  const UnitTileComponent(
      this.label, this.icon, this.initialValue, this.enumValues,
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

    _selected = widget.initialValue;
    _values = widget.enumValues;
  }

  void _cycleUnit() {
    setState(() {
      int currentIndex = _values.indexOf(_selected);
      int nextIndex = (currentIndex + 1) % _values.length;
      _selected = _values[nextIndex];
    });
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
