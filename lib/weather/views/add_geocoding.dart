import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
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

    _popNavigator(index);
  }

  void _popNavigator(int index) {
    Navigator.of(context).pop(index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: NavigationToolbar.kMiddleSpacing,
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              children: [
                // Search Input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _editingController,
                          focusNode: _focus,
                          onTapOutside: _onTapOutsideKeyboard,
                          decoration: const InputDecoration(
                            icon: Icon(TablerIcons.search),
                            // hintText: "Type a name of an location",
                            hintText: "Search",
                            border: InputBorder.none,
                            isCollapsed: true,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // List of locations
                Expanded(
                  child: Builder(
                    builder: (context) {
                      String label = _editingController.text.isEmpty
                          ? "Type a name of an location"
                          : "No locations found";

                      if (_searchedGeocodings.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 64.0),
                          child: Column(
                            children: [
                              Material(
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    width: 1,
                                    color: Colors.grey[400]!,
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Icon(
                                    TablerIcons.map_2,
                                    size: 32,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  label,
                                  style: context.textTheme.displaySmall,
                                ),
                              ),
                              _editingController.text.isEmpty
                                  ? const SizedBox.shrink()
                                  : Text(
                                      "\"${_editingController.text}\" did not match any location.\nPlease try again",
                                      textAlign: TextAlign.center,
                                    ),
                              _editingController.text.isEmpty
                                  ? const SizedBox.shrink()
                                  : TextButton(
                                      onPressed: () {
                                        _editingController.clear();
                                      },
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          side: const BorderSide(
                                              width: 1, color: Colors.grey),
                                        ),
                                      ),
                                      child: const Text(
                                        "Clear search",
                                        style: TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        );
                      } else {
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          shrinkWrap: true,
                          itemCount: _searchedGeocodings.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 6),
                          itemBuilder: (context, index) =>
                              _searchedGeocodingTile(
                                  _searchedGeocodings[index]),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
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
