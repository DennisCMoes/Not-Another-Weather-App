import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:objectbox/objectbox.dart';
import 'package:not_another_weather_app/objectbox.g.dart';

class ObjectBox {
  late final Store _store;
  late final Box<Geocoding> _geoBox;

  ObjectBox._create(this._store) {
    _geoBox = Box<Geocoding>(_store);
  }

  Box<Geocoding> get geoBox => _geoBox;

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store =
        await openStore(directory: p.join(docsDir.path, 'obx-example'));
    return ObjectBox._create(store);
  }
}
