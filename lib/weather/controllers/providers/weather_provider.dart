import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/forecast_repo.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/geocoding_repo.dart';
import 'package:not_another_weather_app/weather/models/dummy_data.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/logics/selectable_forecast_fields.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// A provider class that manages the weather-related data and operations
class WeatherProvider extends ChangeNotifier {
  final ForecastRepo _forecastRepo = ForecastRepo();
  final GeocodingRepo _geocodingRepo = GeocodingRepo();
  final PageController _pageController = PageController();

  late Timer _onNewHourTimer;

  List<Geocoding> _geocodings = [];
  DateTime _currentHour = DateTime.now();
  DateTime _refreshTime = DateTime.now();

  // Getters
  PageController get pageController => _pageController;
  DateTime get refreshTime => _refreshTime;
  DateTime get currentHour => _currentHour;
  UnmodifiableListView<Geocoding> get geocodings =>
      UnmodifiableListView(_geocodings);

  WeatherProvider() {
    _startHourlyTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _onNewHourTimer.cancel();
  }

  /// Initializes weather-related data asynchronously.
  ///
  /// This function attempts to initialize geocoding data and forecasts.
  /// If an error occurs during initialization, the error is logged, and the
  /// exception is captured usign Sentry for monitoring.
  Future<void> initializeData() async {
    try {
      await _initializeGeocodingsAndForecasts();
    } catch (exception, stacktrace) {
      debugPrint("Error initializing data: $exception");
      Sentry.captureException(exception, stackTrace: stacktrace);
      rethrow;
    }
  }

  /// Refreshes the weather data if the last refresh was more than 5 minutes ago.
  ///
  /// This function checks if the last refresh time is more than 5 minutes old.
  /// If so, it updates the forecasts and sets the new refresh time to the current time.
  /// Any errors during the refresh process are logged and reported to Sentry.
  Future<void> refreshData() async {
    try {
      // If the last refresh is more than 5 minutes away refresh the data
      if (DateTime.now()
          .isAfter(_refreshTime.add(const Duration(minutes: 5)))) {
        _updateForecasts();
        _refreshTime = DateTime.now();
      }
    } catch (exception, stacktrace) {
      debugPrint("Error refreshing data: $exception");
      Sentry.captureException(exception, stackTrace: stacktrace);
    }
  }

  /// Adds dummy data to the geocodings list.
  ///
  /// This method clears any existing dummy data in the geocodings list and adds
  /// a new set of dummy geocoding entries for testing or demonstration purposes.
  /// After updating the geocodings list, it notifies listeners to update the UI.
  void addDummyData() {
    _geocodings.removeWhere((element) => element.isTestClass != TestClass.none);
    _geocodings.addAll([
      DummyData.colorSchemeGeocoding(TestClass.day),
      DummyData.colorSchemeGeocoding(TestClass.night),
      DummyData.clipperGeocoding(TestClass.day),
      DummyData.clipperGeocoding(TestClass.night),
    ]);

    notifyListeners();
  }

  /// Retrieves a specific geocoding by its ID.
  ///
  /// This method attemps to find a geocoding entry in the geocodings list that
  /// matches the provided [id]. If found, the geocoding is returned; otherwise,
  /// `null` is returned if an error occurs or if no match is found.
  ///
  /// - Parameters:
  ///   - [id]: The unique identifier of the geocoding to retrieve.
  Geocoding? getGeocoding(int id) {
    try {
      return _geocodings.firstWhere((geo) => geo.id == id);
    } catch (exception) {
      debugPrint('Error retrieving geocoding: $exception');
      return null;
    }
  }

  /// Adds a geocoding with forecast to the list.
  ///
  /// This method adds a new geocoding to the geocodings list and updates its
  /// ordering. After adding, it updates the forecasts and persists the updated
  /// geocodings list to the repository. If an error occurs, it is logged and
  /// captured using Sentry.
  ///
  /// - Parameters:
  ///   - [geocoding]: The geocoding entry to add to the list.
  Future<void> addGeocoding(Geocoding geocoding) async {
    try {
      geocoding.ordening = _geocodings.length;
      _geocodings.add(geocoding);
      await _updateForecasts();

      _geocodingRepo.updateGeocodings(_geocodings);
      notifyListeners();
    } catch (exception, stacktrace) {
      debugPrint("Error adding geocoding: $exception");
      Sentry.captureException(exception, stackTrace: stacktrace);
    }
  }

  /// Moves a geocoding location from [oldIndex] to [newIndex] in the list.
  ///
  /// This method reorders the geocodings list by moving a geocoding from the
  /// specified [oldIndex] to the [newIndex]. It updates the ordering of all
  /// geocodings and persists the changes. If an error occurs, it is logged
  /// and captured using Sentry.
  ///
  /// - Parameters:
  ///   - [oldIndex]: The current index of the geocoding to move.
  ///   - [newIndex]: The new index to move the geocoding to.
  void moveGeocodings(int oldIndex, int newIndex) {
    if (!_isValidIndex(oldIndex) || !_isValidIndex(newIndex)) {
      debugPrint("Invalid index for moving geocodings: $oldIndex, $newIndex");
      return;
    }

    try {
      final oldItem = _geocodings.removeAt(oldIndex);
      _geocodings.insert(newIndex, oldItem);

      for (int i = 0; i < _geocodings.length; i++) {
        _geocodings[i].ordening = i;
      }

      _geocodingRepo.updateGeocodings(_geocodings);
      notifyListeners();
    } catch (exception, stacktrace) {
      debugPrint("Error moving geocodings: $exception");
      Sentry.captureException(exception, stackTrace: stacktrace);
    }
  }

  /// Removes the specified [geocoding] location from the list.
  ///
  /// This method removes a geocoding from the geocodings list based on the
  /// provided [geocoding] object. It also deletes the geocoding from the
  /// repository and notifies listeners. If an error occurs, it is logged
  /// and captured using Sentry.
  ///
  /// - Parameters:
  ///   - [geocoding]: The geocoding entry to remove from the list.
  void removeGeocoding(Geocoding geocoding) {
    int geoIndex = _geocodings.indexOf(geocoding);

    if (geoIndex == -1) {
      debugPrint("Error: Geocoding not found");
      return;
    }

    try {
      _geocodings.removeAt(geoIndex);
      _geocodingRepo.removeGeocoding(geocoding.id);
      notifyListeners();
    } catch (exception, stacktrace) {
      debugPrint("Error removing geocoding: $exception");
      Sentry.captureException(exception, stackTrace: stacktrace);
    }

    if (geoIndex != -1) {
    } else {
      debugPrint("Error: Geocoding not found");
    }
  }

  /// Checks if the provided index is valid within the geocodings list.
  ///
  /// This method verifies whether the given [index] is within the bounds
  /// of the current geocodings list.
  ///
  /// - Parameters:
  ///   - [index]: The index to validate.
  ///
  /// - Returns:
  ///   `true` if the index is valid; `false` otherwise.
  bool _isValidIndex(int index) {
    return index >= 0 && index < _geocodings.length;
  }

  /// Initializes geocodings and forecasts together.
  ///
  /// This method initializes the geocodings list by fetching stored geocodings
  /// from the repository and setting up the current location. It also fetches
  /// the latest weather forecasts for each geocoding. Errors are logged and
  /// captured using Sentry.
  Future<void> _initializeGeocodingsAndForecasts() async {
    try {
      _geocodings = _getStoredGeocodings();

      // Updates the coordinates of the current position
      await _updateLocalPosition();

      // Fetch and update all forecasts
      await _updateForecasts();
    } catch (exception, stacktrace) {
      debugPrint("Error initializing geocodings and forecasts: $exception");
      Sentry.captureException(exception, stackTrace: stacktrace);
    }
  }

  /// Fetches stored geocodings from the repository and initializes if empty.
  ///
  /// This method retrieves geocodings stored in the repository. If no geocodings
  /// are found, it initializes the list with a default current location entry.
  /// Errors are logged and captured using Sentry.
  ///
  /// - Returns:
  ///   A list of stored geocodings.
  List<Geocoding> _getStoredGeocodings() {
    try {
      List<Geocoding> storedGeocodings = _geocodingRepo.getStoredGeocodings();

      if (storedGeocodings.isEmpty) {
        storedGeocodings
            .add(Geocoding(1, "Current location", -1, -1, "Current location")
              ..isCurrentLocation = true
              ..ordening = 0
              ..forecast = Forecast.isLoadingData()
              ..selectedForecastItems = [
                SelectableForecastFields.windSpeed,
                SelectableForecastFields.precipitation,
                SelectableForecastFields.chainceOfRain,
                SelectableForecastFields.cloudCover
              ]);
      } else {
        storedGeocodings.sort((a, b) => a.ordening - b.ordening);
      }

      return storedGeocodings;
    } catch (exception, stacktrace) {
      debugPrint("Error fetching stored geocodings: $exception");
      Sentry.captureException(exception, stackTrace: stacktrace);
      return [];
    }
  }

  /// Updates the local position of the device.
  ///
  /// This method checks the device's location permissions and availability,
  /// then attempts to fetch the current position. The position is used to
  /// update the current location geocoding in the list. Errors are logged and
  /// captured using Sentry, and the state is updated accordingly if the location
  /// cannot be determined.
  Future<void> _updateLocalPosition() async {
    try {
      final invalidPermissions = [
        LocationPermission.denied,
        LocationPermission.deniedForever,
        LocationPermission.unableToDetermine
      ];
      final permission = await Geolocator.checkPermission();
      final isAvailable = await Geolocator.isLocationServiceEnabled();

      if (!isAvailable || invalidPermissions.contains(permission)) {
        throw Exception("No location services available");
      }

      Position position = await Geolocator.getCurrentPosition(
          timeLimit: const Duration(seconds: 5));

      int currentLocationIndex =
          _geocodings.indexWhere((geocode) => geocode.isCurrentLocation);

      if (currentLocationIndex != -1) {
        _geocodings[currentLocationIndex]
          ..latitude = position.latitude
          ..longitude = position.longitude;
      } else {
        // TODO: Add a function to add the current geolocation if it wasn't found
        debugPrint("Current location geocoding not found");
      }
    } catch (exception, stacktrace) {
      debugPrint("Error updating local position: $exception");
      Sentry.captureException(exception, stackTrace: stacktrace);

      int currentLocationIndex =
          _geocodings.indexWhere((geocode) => geocode.isCurrentLocation);
      if (currentLocationIndex != -1) {
        _geocodings[currentLocationIndex]
          ..latitude = -1
          ..longitude = -1;
      } else {
        debugPrint(
            'Current location geocoding not found to update error state');
      }
    }
  }

  /// Updates the forecasts for all geocodings asynchronously.
  ///
  /// This method fetches the latest weather forecasts for each geocoding
  /// in the geocodings list. If an error occurs while fetching a forecast,
  /// a placeholder forecast indicating no internet is used. All updates
  /// are persisted to the repository. Errors are logged and captured using Sentry.
  Future<void> _updateForecasts() async {
    try {
      _geocodings = await Future.wait(_geocodings.map((geocode) async {
        try {
          geocode.forecast = await _forecastRepo.getForecastById(geocode);
          _geocodingRepo.storeGeocoding(geocode);
        } catch (exception) {
          debugPrint(
              "Error fetching forecast for geocoding ${geocode.id}: $exception");
          geocode.forecast = Forecast.noInternet();
        }

        return geocode;
      }).toList());
    } catch (exception, stacktrace) {
      debugPrint("Error updating forecasts: $exception");
      Sentry.captureException(exception, stackTrace: stacktrace);
    }
  }

  /// Starts a timer that triggers an action at the start of every new hour.
  ///
  /// This method calculates the duration until the next full hour and sets
  /// a timer to call [_onHourChange] when that time is reached. It ensures
  /// that actions or updates that should occur at the start of each hour
  /// are executed on time.
  void _startHourlyTimer() {
    DateTime now = DateTime.now();
    DateTime nextHour = DateTime(now.year, now.month, now.day, now.hour + 1);

    Duration timeUntilNextHour = nextHour.difference(now);
    _onNewHourTimer = Timer(timeUntilNextHour, _onHourChange);
  }

  /// Called at the start of each new hour to perform necessary updates.
  ///
  /// This method is triggered by a timer set in [_startHourlyTimer]. It updates
  /// the [_currentHour] and [_refreshTime] to the current time, triggers a forecast
  /// update by calling [_updateForecasts], and then notifies listeners of the changes
  /// to ensure that the UI or other listening components are updated accordingly.
  void _onHourChange() {
    _currentHour = DateTime.now();
    _refreshTime = DateTime.now();
    _updateForecasts();
    notifyListeners();
  }
}
