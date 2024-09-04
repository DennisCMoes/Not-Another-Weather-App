import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:not_another_weather_app/shared/utilities/observer_utils.dart';
import 'package:not_another_weather_app/weather/controllers/providers/forecast_card_provider.dart';
import 'package:not_another_weather_app/weather/controllers/stores/object_box.dart';
import 'package:provider/provider.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/views/home.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:timezone/data/latest_all.dart' as tz;

late ObjectBox objectBox;

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  objectBox = await ObjectBox.create();

  tz.initializeTimeZones();

  // TODO: initialze geolocation services
  var locationPermission = await Geolocator.checkPermission();

  if (locationPermission == LocationPermission.denied) {
    locationPermission = await Geolocator.requestPermission();
  }

  await SentryFlutter.init(
    (options) {
      if (!kDebugMode) {
        options.dsn =
            'https://651efbc91f853e3074e8e10f8d985226@o4507785869000704.ingest.de.sentry.io/4507785870573648';
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 1.0;
        // The sampling rate for profiling is relative to tracesSampleRate
        // Setting to 1.0 will profile 100% of sampled transactions:
        options.profilesSampleRate = 1.0;
      } else {
        options.dsn = '';
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 0.0;
        // The sampling rate for profiling is relative to tracesSampleRate
        // Setting to 1.0 will profile 100% of sampled transactions:
        options.profilesSampleRate = 0.0;
      }
    },
    appRunner: () => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => WeatherProvider()),
          ChangeNotifierProvider(create: (context) => ForecastCardProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorObservers: [ObserverUtils.routeObserver],
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 42, fontWeight: FontWeight.w800),
          displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          displaySmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
