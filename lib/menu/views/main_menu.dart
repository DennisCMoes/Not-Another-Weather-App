import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:not_another_weather_app/menu/models/units.dart';
import 'package:not_another_weather_app/menu/views/unit_tile.dart';
import 'package:not_another_weather_app/shared/extensions/color_extensions.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/geocoding_repo.dart';
import 'package:not_another_weather_app/weather/models/colorscheme.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:provider/provider.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  late FocusNode _focusNode;
  late TextEditingController _textEditingController;
  late WeatherProvider _weatherProvider;

  final GeocodingRepo _geocodingRepo = GeocodingRepo();

  bool _hasValue = false;
  bool _isPressingEdit = false;
  bool _isEditing = false;

  List<Geocoding> _searchedGeocodings = [];

  @override
  void initState() {
    super.initState();

    _weatherProvider = context.read<WeatherProvider>();

    _focusNode = FocusNode();
    _textEditingController = TextEditingController();

    _textEditingController.addListener(_onTextFieldValueChange);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();

    super.dispose();
  }

  void _onFocusChange() {
    print("Focus: ${_focusNode.hasFocus.toString()}");
  }

  void _onTextFieldValueChange() async {
    bool hasSearchValue = _textEditingController.text.isNotEmpty;

    setState(() {
      _hasValue = hasSearchValue;

      if (hasSearchValue) {
        _isEditing = false;
      }
    });

    var results =
        await _geocodingRepo.searchGeocodings(_textEditingController.text);

    setState(() {
      _searchedGeocodings = results;
    });
  }

  void _goToPage(int pageIndex) {
    HapticFeedback.lightImpact();
    Navigator.of(context).pop();

    _weatherProvider.pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  void _selectNewGeocoding(Geocoding geocoding) async {
    int index = _weatherProvider.getIndexOfGeocoding(geocoding);

    if (index == -1) {
      await _weatherProvider.addGeocoding(geocoding);
      _goToPage(_weatherProvider.geocodings.length - 1);
    } else {
      _goToPage(index);
    }
  }

  void _removeGeocoding(Geocoding geocoding) {
    HapticFeedback.lightImpact();
    _weatherProvider.removeGeocoding(geocoding);
  }

  void _setEditing(bool value, [bool withHaptics = false]) {
    if (withHaptics) {
      HapticFeedback.lightImpact();
    }

    setState(() {
      _isPressingEdit = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Not Another Weather App")),
      body: GestureDetector(
        child: Consumer<WeatherProvider>(
          builder: (context, state, child) {
            return SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ColoredBox(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 12.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: TextField(
                              controller: _textEditingController,
                              focusNode: _focusNode,
                              textInputAction: TextInputAction.newline,
                              onTapOutside: (event) => FocusScope.of(context)
                                  .requestFocus(FocusNode()),
                              decoration: const InputDecoration.collapsed(
                                border: InputBorder.none,
                                hintText: "Search...",
                              ),
                            ),
                          ),
                          _hasValue
                              ? const SizedBox.shrink()
                              : GestureDetector(
                                  onTapDown: (details) => _setEditing(true),
                                  onTapCancel: () => _setEditing(false),
                                  onTapUp: (details) => _setEditing(false),
                                  onTap: () =>
                                      _setEditing(!_isPressingEdit, true),
                                  child: Text(
                                    _isEditing ? "Done" : "Edit",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                          color: _isPressingEdit
                                              ? Colors.black45
                                              : Colors.black,
                                        ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        _hasValue ? _searchingLayout() : _nonSearchingLayout(),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _geocodingTile(Geocoding geocoding, int index) {
    ColorPair colorPair = geocoding.getColorSchemeOfForecast();

    return ListTile(
      key: ValueKey(geocoding),
      onTap: () => _goToPage(index),
      dense: true,
      tileColor: colorPair.main,
      splashColor: colorPair.main.lightenColor(0.1),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            geocoding.name,
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(color: colorPair.accent),
          ),
          const SizedBox(width: 6),
          geocoding.isCurrentLocation
              ? Icon(Icons.near_me, color: colorPair.accent)
              : const SizedBox.shrink(),
        ],
      ),
      subtitle: Text(
        geocoding.forecast?.getCurrentHourData().weatherCode.description ??
            "Unknown",
        style: Theme.of(context)
            .textTheme
            .displaySmall!
            .copyWith(color: colorPair.accent.withOpacity(0.6)),
      ),
      leading: _isEditing && !geocoding.isCurrentLocation
          ? Icon(Icons.drag_indicator, color: colorPair.accent)
          : null,
      trailing: _isEditing && !geocoding.isCurrentLocation
          ? IconButton(
              onPressed: () => _removeGeocoding(geocoding),
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.delete, color: colorPair.accent),
            )
          : Text(
              "${geocoding.forecast?.getCurrentHourData().temperature.round() ?? "XX"}º",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: colorPair.accent),
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

  Widget _nonSearchingLayout() {
    final state = context.read<WeatherProvider>();

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: [
              ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                header: state.geocodings.isEmpty
                    ? const SizedBox.shrink()
                    : _geocodingTile(state.geocodings[0], 0),
                onReorder: (oldIndex, newIndex) {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }

                  state.moveGeocodings(oldIndex + 1, newIndex + 1);
                },
                buildDefaultDragHandles: _isEditing,
                children: [
                  for (int i = 1; i < state.geocodings.length; i++)
                    _geocodingTile(state.geocodings[i], i)
                ],
              ),
              const Divider(thickness: 1),
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.tour),
                    onTap: () {},
                    title: const Text("Quick Guide"),
                  ),
                  const UnitTileComponent<WindspeedUnit>(
                    "Windspeed",
                    "wind_speed_unit",
                    Icons.speed,
                    WindspeedUnit.values,
                  ),
                  const UnitTileComponent<TemperatureUnit>(
                      "Temperature",
                      "temperature_unit",
                      Icons.thermostat,
                      TemperatureUnit.values),
                  const UnitTileComponent<PrecipitationUnit>(
                      "Precipitation",
                      "precipitation_unit",
                      Icons.water_drop,
                      PrecipitationUnit.values),
                  if (kDebugMode) _debugButtons(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchingLayout() {
    if (_searchedGeocodings.isEmpty) {
      return Center(
        child: Text(
          "No matching locations",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      );
    } else {
      return ListView.separated(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        itemCount: _searchedGeocodings.length,
        separatorBuilder: (context, index) => const Divider(height: 0),
        itemBuilder: (context, index) =>
            _searchedGeocodingTile(_searchedGeocodings[index]),
      );
    }
  }

  Widget _debugButtons() {
    return Column(
      children: [
        Text("DEBUG BUTTONS"),
      ],
    );
  }
}
