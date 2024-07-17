import 'package:geolocator/geolocator.dart';

class LocationController {
  Future<Position> getCurrentPosition() async {
    var isEnabled = await Geolocator.isLocationServiceEnabled();
    var permissions = await Geolocator.checkPermission();

    if (!isEnabled) {
      print("Not enabled!");
    }

    if (permissions == LocationPermission.denied) {
      permissions = await Geolocator.requestPermission();

      if (permissions == LocationPermission.denied) {
        print("Location permissions are denied");
      }
    }

    if (permissions == LocationPermission.deniedForever) {
      print(
          "Location permissions are permanently denied, we cannot request permissions");
    }

    return await Geolocator.getCurrentPosition();
  }
}
