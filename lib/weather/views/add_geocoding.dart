import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/extensions/context_extensions.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/geocoding_repo.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:provider/provider.dart';

class AddGeocodingCard extends StatefulWidget {
  final ValueSetter<bool> setKeyboardIsOpen;

  const AddGeocodingCard({super.key, required this.setKeyboardIsOpen});

  @override
  State<AddGeocodingCard> createState() => _AddGeocodingCardState();
}

class _AddGeocodingCardState extends State<AddGeocodingCard> {
  final GeocodingRepo _geocodingRepo = GeocodingRepo();

  late WeatherProvider _weatherProvider;

  FocusNode _focus = FocusNode();
  TextEditingController _editingController = TextEditingController();

  List<Geocoding> _searchedGeocodings = [];

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    _editingController.addListener(_onTextFieldValueChange);

    _weatherProvider = context.read<WeatherProvider>();
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _editingController.removeListener(_onTextFieldValueChange);

    _focus.dispose();
    _editingController.dispose();
    super.dispose();
  }

  void _onTapOutsideKeyboard(PointerDownEvent event) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _onFocusChange() {
    widget.setKeyboardIsOpen(_focus.hasFocus);
  }

  void _onTextFieldValueChange() async {
    print(_editingController.text);
    // TODO: Remove the await and add some error handling for if we wait to long
    var results =
        await _geocodingRepo.searchGeocodings(_editingController.text);

    setState(() {
      _searchedGeocodings = results;
    });
  }

  void _selectNewGeocoding(Geocoding geocoding) async {
    int index = _weatherProvider.geocodings.indexOf(geocoding);

    if (index == -1) {
      await _weatherProvider.addGeocoding(geocoding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              focusNode: _focus,
              controller: _editingController,
              onTapOutside: _onTapOutsideKeyboard,
              decoration: const InputDecoration.collapsed(
                border: OutlineInputBorder(),
                hintText: "Search...",
              ),
            ),
            Builder(
              builder: (context) {
                if (_searchedGeocodings.isEmpty) {
                  return Text("No matching locations",
                      style: context.textTheme.displayMedium);
                } else {
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _searchedGeocodings.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) =>
                        _searchedGeocodingTile(_searchedGeocodings[index]),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchedGeocodingTile(Geocoding geocoding) {
    return ListTile(
      onTap: () => _selectNewGeocoding(geocoding),
      visualDensity: VisualDensity.compact,
      title: Text(geocoding.name),
      subtitle: Text(geocoding.country),
    );
  }
}
