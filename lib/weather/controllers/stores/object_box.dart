import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:not_another_weather_app/objectbox.g.dart';

class ObjectBox {
  late final Store _store;

  // late final Box<Forecast> _forecastBox;
  late final Box<Geocoding> _geocodingBox;

  ObjectBox._create(this._store) {
    _geocodingBox = Box<Geocoding>(_store);
    // _forecastBox = Box<Forecast>(_store);
  }

  Box<Geocoding> get geocodingBox => _geocodingBox;
  // Box<Forecast> get forecastBox => _forecastBox;

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(
      directory: p.join(docsDir.path, 'obx-example'),
    );

    return ObjectBox._create(store);
  }
}
