import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:not_another_weather_app/main.dart';
import 'package:not_another_weather_app/menu/models/units.dart';
import 'package:not_another_weather_app/menu/views/unit_tile.dart';
import 'package:not_another_weather_app/shared/extensions/color_extensions.dart';
import 'package:not_another_weather_app/shared/extensions/context_extensions.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/geocoding_repo.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();

    super.dispose();
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
    int index = _weatherProvider.geocodings.indexOf(geocoding);

    if (index == -1) {
      _weatherProvider.addGeocoding(geocoding);
      _goToPage(_weatherProvider.geocodings.length - 1);
    } else {
      _goToPage(index);
    }
  }

  void _removeGeocoding(Geocoding geocoding) {
    HapticFeedback.lightImpact();
    _weatherProvider.removeGeocoding(geocoding);
  }

  void _setEditing(bool value) {
    setState(() {
      _isPressingEdit = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RawGestureDetector(
          gestures: {
            SerialTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                SerialTapGestureRecognizer>(
              SerialTapGestureRecognizer.new,
              (instance) {
                instance.onSerialTapDown = (details) {
                  if (details.count == 3) {
                    context.read<WeatherProvider>().addDummyData();
                  }
                };
              },
            )
          },
          child: const Text("Yet Another Weather App"),
        ),
      ),
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
                        horizontal: 16.0,
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
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      _isEditing = !_isEditing;
                                    });
                                  },
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
    final colorPair = geocoding.forecast.getColorPair();

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
          Flexible(
            child: Text(
              geocoding.name,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: colorPair.accent),
            ),
          ),
          const SizedBox(width: 6),
          geocoding.isCurrentLocation
              ? Icon(Icons.near_me, color: colorPair.accent)
              : const SizedBox.shrink(),
        ],
      ),
      subtitle: Text(
        geocoding.forecast.getCurrentHourData().weatherCode.description,
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
              "${geocoding.forecast.getCurrentHourData().temperature.round()}º",
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
      padding: EdgeInsets.only(bottom: context.padding.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: [
              ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                header: _geocodingTile(state.geocodings[0], 0),
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
              const Divider(),
              Column(
                children: [
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
                  // If we are in debug mode and not release display the debug buttons
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
          style: context.textTheme.displayMedium,
        ),
      );
    } else {
      return ListView.separated(
        padding: EdgeInsets.only(bottom: context.padding.bottom),
        itemCount: _searchedGeocodings.length,
        separatorBuilder: (context, index) => const Divider(height: 0),
        itemBuilder: (context, index) =>
            _searchedGeocodingTile(_searchedGeocodings[index]),
      );
    }
  }

  Widget _debugButtons() {
    void clearSharedPrefs() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
    }

    void clearAllGeocodings() {
      objectBox.geocodingBox.removeAll();
    }

    void clearAllForecasts() {
      objectBox.forecastBox.removeAll();
    }

    void clearAllDaily() {
      objectBox.dailyBox.removeAll();
    }

    void clearAllHourly() {
      objectBox.hourlyBox.removeAll();
    }

    return Column(
      children: [
        const Divider(),
        ListTile(
          title: const Text("Clear Shared Preferences"),
          leading: const Icon(Icons.delete),
          onTap: clearSharedPrefs,
        ),
        ListTile(
          title: const Text("Clear Persisted Forecasts"),
          leading: const Icon(Icons.delete),
          onTap: clearAllForecasts,
        ),
        ListTile(
          title: const Text("Clear Persisted Geocodings"),
          leading: const Icon(Icons.delete),
          onTap: clearAllGeocodings,
        ),
        ListTile(
          title: const Text("Clear Persisted Hourly Data"),
          leading: const Icon(Icons.delete),
          onTap: clearAllHourly,
        ),
        ListTile(
          title: const Text("Clear Persisted Daily Data"),
          leading: const Icon(Icons.delete),
          onTap: clearAllDaily,
        ),
        ListTile(
          title: const Text("Clear All Persisted Data"),
          leading: const Icon(Icons.delete),
          onTap: () {
            clearAllForecasts();
            clearAllGeocodings();
            clearAllHourly();
            clearAllDaily();
          },
        ),
      ],
    );
  }
}
