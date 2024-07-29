import 'package:flutter/material.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/geocoding_repo.dart';
import 'package:provider/provider.dart';
import 'package:not_another_weather_app/shared/utilities/providers/drawer_provider.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';

class WeatherDrawer extends StatefulWidget {
  const WeatherDrawer({super.key});

  @override
  State<WeatherDrawer> createState() => _WeatherDrawerState();
}

class _WeatherDrawerState extends State<WeatherDrawer> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  final GeocodingRepo _geocodingRepo = GeocodingRepo();

  List<Geocoding> searchedGeocodings = [];

  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();

    super.dispose();
  }

  void _searchGeocodings(String searchValue) async {
    var results = await _geocodingRepo.getGeocodings(searchValue);

    setState(() {
      searchedGeocodings = results;
    });
  }

  void _onFocusChange() {
    setState(() {
      isSearching = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  focusNode: _focusNode,
                  controller: _textEditingController,
                  onChanged: _searchGeocodings,
                  onTapOutside: (event) =>
                      FocusScope.of(context).requestFocus(FocusNode()),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                    hintText: "Enter a city name",
                  ),
                ),
                Builder(
                  builder: (context) {
                    if (searchedGeocodings.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchedGeocodings.length,
                        itemBuilder: (context, index) => _weatherListTile(
                            index, searchedGeocodings[index], true),
                      );
                    } else {
                      return ReorderableListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        header: state.geocodings.isNotEmpty
                            ? _weatherListTile(0, state.geocodings[0])
                            : const SizedBox.shrink(),
                        onReorder: (oldIndex, newIndex) {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }

                          state.moveGeocodings(oldIndex + 1, newIndex + 1);
                        },
                        children: [
                          for (int i = 1; i < state.geocodings.length; i++)
                            _weatherListTile(i, state.geocodings[i])
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _weatherListTile(int index, Geocoding geocoding,
      [bool isSearching = false]) {
    final WeatherProvider weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    final DrawerProvider drawerProvider =
        Provider.of<DrawerProvider>(context, listen: false);

    void scrollToPage(int pageIndex) {
      Provider.of<WeatherProvider>(context, listen: false)
          .pageController
          .animateToPage(
            pageIndex,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 600),
          );
    }

    void onClick() async {
      if (isSearching) {
        _textEditingController.clear();

        setState(() {
          searchedGeocodings = [];
        });

        weatherProvider.addGeocoding(geocoding);
        scrollToPage(weatherProvider.geocodings.length - 1);
        drawerProvider.closeDrawer();
      } else {
        scrollToPage(index);
        drawerProvider.closeDrawer();
      }
    }

    Widget listChild = Material(
      key: ValueKey(geocoding),
      color: geocoding.forecast
              ?.getCurrentHourData()
              .weatherCode
              .colorScheme
              .mainColor ??
          Colors.blueGrey,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      geocoding.name,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                color: geocoding.forecast
                                        ?.getCurrentHourData()
                                        .weatherCode
                                        .colorScheme
                                        .accentColor ??
                                    Colors.white,
                              ),
                    ),
                    Text(
                      isSearching
                          ? geocoding.country
                          : geocoding.forecast
                                  ?.getCurrentHourData()
                                  .weatherCode
                                  .description ??
                              "XX",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: geocoding.forecast
                                    ?.getCurrentHourData()
                                    .weatherCode
                                    .colorScheme
                                    .accentColor ??
                                Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
              isSearching
                  ? const SizedBox.shrink()
                  : Text(
                      "${geocoding.forecast?.getCurrentHourData().temperature.round() ?? "XX"}º",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: geocoding.forecast
                                      ?.getCurrentHourData()
                                      .weatherCode
                                      .colorScheme
                                      .accentColor ??
                                  Colors.white),
                    )
            ],
          ),
        ),
      ),
    );

    if (geocoding.isCurrentLocation) {
      return listChild;
    } else {
      return Dismissible(
        direction: DismissDirection.endToStart,
        behavior: HitTestBehavior.translucent,
        key: ValueKey(geocoding),
        background: const Material(
          color: Colors.red,
          child: Icon(Icons.delete),
        ),
        onDismissed: (direction) {
          Provider.of<WeatherProvider>(context, listen: false)
              .removeGeocoding(geocoding);
        },
        child: listChild,
      );
    }
  }
}
