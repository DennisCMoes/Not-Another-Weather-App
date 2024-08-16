// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again
// with `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'weather/models/geocoding.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 8085940287060332242),
      name: 'Geocoding',
      lastPropertyId: const obx_int.IdUid(8, 5291511106960012626),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 7054998796814959178),
            name: 'id',
            type: 6,
            flags: 129),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 5494809353542255611),
            name: 'name',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 7850404958651001704),
            name: 'latitude',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 3272231588208254688),
            name: 'longitude',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 785092990110049512),
            name: 'country',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 732950383778108936),
            name: 'selectedPage',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 973518960355281142),
            name: 'selectedForecastItemsDb',
            type: 27,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 5291511106960012626),
            name: 'ordening',
            type: 6,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [obx.Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [obx.Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
Future<obx.Store> openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(getObjectBoxModel(),
      directory: directory ?? (await defaultStoreDirectory()).path,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [obx.Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(1, 8085940287060332242),
      lastIndexId: const obx_int.IdUid(0, 0),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    Geocoding: obx_int.EntityDefinition<Geocoding>(
        model: _entities[0],
        toOneRelations: (Geocoding object) => [],
        toManyRelations: (Geocoding object) => {},
        getId: (Geocoding object) => object.id,
        setId: (Geocoding object, int id) {
          object.id = id;
        },
        objectToFB: (Geocoding object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final countryOffset = fbb.writeString(object.country);
          final selectedForecastItemsDbOffset =
              fbb.writeListInt64(object.selectedForecastItemsDb);
          fbb.startTable(9);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addFloat64(2, object.latitude);
          fbb.addFloat64(3, object.longitude);
          fbb.addOffset(4, countryOffset);
          fbb.addInt64(5, object.selectedPage);
          fbb.addOffset(6, selectedForecastItemsDbOffset);
          fbb.addInt64(7, object.ordening);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final nameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final latitudeParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 8, 0);
          final longitudeParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 10, 0);
          final countryParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 12, '');
          final ordeningParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 18, 0);
          final object = Geocoding(
              idParam, nameParam, latitudeParam, longitudeParam, countryParam,
              ordening: ordeningParam)
            ..selectedPage =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0)
            ..selectedForecastItemsDb =
                const fb.ListReader<int>(fb.Int64Reader(), lazy: false)
                    .vTableGet(buffer, rootOffset, 16, []);

          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [Geocoding] entity fields to define ObjectBox queries.
class Geocoding_ {
  /// See [Geocoding.id].
  static final id =
      obx.QueryIntegerProperty<Geocoding>(_entities[0].properties[0]);

  /// See [Geocoding.name].
  static final name =
      obx.QueryStringProperty<Geocoding>(_entities[0].properties[1]);

  /// See [Geocoding.latitude].
  static final latitude =
      obx.QueryDoubleProperty<Geocoding>(_entities[0].properties[2]);

  /// See [Geocoding.longitude].
  static final longitude =
      obx.QueryDoubleProperty<Geocoding>(_entities[0].properties[3]);

  /// See [Geocoding.country].
  static final country =
      obx.QueryStringProperty<Geocoding>(_entities[0].properties[4]);

  /// See [Geocoding.selectedPage].
  static final selectedPage =
      obx.QueryIntegerProperty<Geocoding>(_entities[0].properties[5]);

  /// See [Geocoding.selectedForecastItemsDb].
  static final selectedForecastItemsDb =
      obx.QueryIntegerVectorProperty<Geocoding>(_entities[0].properties[6]);

  /// See [Geocoding.ordening].
  static final ordening =
      obx.QueryIntegerProperty<Geocoding>(_entities[0].properties[7]);
}
