import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather/shared/utilities/controllers/location_controller.dart';
import 'package:weather/shared/utilities/providers/device_provider.dart';
import 'package:weather/weather/views/home.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    ChangeNotifierProvider(
      create: (context) => DeviceProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LocationController _locationController = LocationController();

  @override
  void initState() {
    super.initState();

    initialization().whenComplete(() => FlutterNativeSplash.remove());
  }

  Future<void> initialization() async {
    // FIXME: The code isn't being reached when not in debug mode.
    Position position = await _locationController.getCurrentPosition();

    if (!mounted) return;
    Provider.of<DeviceProvider>(context, listen: false)
        .setCurrentLocation(position);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 42, fontWeight: FontWeight.w800),
          displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          displaySmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          // bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
