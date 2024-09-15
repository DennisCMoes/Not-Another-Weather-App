import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/extensions/context_extensions.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/geocoding_repo.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:provider/provider.dart';

class AddGeocodingCard extends StatefulWidget {
  const AddGeocodingCard({super.key});

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

  void _onFocusChange() {}

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
    int index = _weatherProvider.geocodings
        .indexWhere((element) => element.id == geocoding.id);

    if (index == -1) {
      await _weatherProvider.addGeocoding(geocoding);
      index = _weatherProvider.geocodings
          .indexWhere((element) => element.id == geocoding.id);
    }

    // Navigator.of(context).pop(index);
    Navigator.pop(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: NavigationToolbar.kMiddleSpacing,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add Geolocation",
                  style: context.textTheme.displayMedium!.copyWith(
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  visualDensity: VisualDensity.compact,
                  highlightColor: Colors.white24,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            TextField(
              controller: _editingController,
              focusNode: _focus,
              onTapOutside: _onTapOutsideKeyboard,
              decoration: InputDecoration(
                hintText: "Location name",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _searchedGeocodings.length,
              separatorBuilder: (context, index) => const SizedBox(height: 6),
              itemBuilder: (context, index) =>
                  _searchedGeocodingTile(_searchedGeocodings[index]),
            )
          ],
        ),
      ),
    );
  }

  Widget _searchedGeocodingTile(Geocoding geocoding) {
    return ListTile(
      tileColor: Colors.white,
      onTap: () => _selectNewGeocoding(geocoding),
      visualDensity: VisualDensity.compact,
      title: Text(geocoding.name),
      subtitle: Text(geocoding.country),
    );
  }
}
