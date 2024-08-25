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

import 'weather/models/forecast.dart';
import 'weather/models/geocoding.dart';
import 'weather/models/weather/forecast/daily_weather.dart';
import 'weather/models/weather/forecast/hourly_weather.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 8085940287060332242),
      name: 'Geocoding',
      lastPropertyId: const obx_int.IdUid(9, 1558887423139959226),
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
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(9, 1558887423139959226),
            name: 'isCurrentLocation',
            type: 1,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(3, 8473249143881802513),
      name: 'DailyWeatherData',
      lastPropertyId: const obx_int.IdUid(9, 5894981568594173386),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 1207902785540526508),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 965943071278988375),
            name: 'sunrise',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 1484612392393404729),
            name: 'sunset',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 3132488025131263583),
            name: 'uvIndex',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 5481371712891885672),
            name: 'clearSkyUvIndex',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 3556370642150461096),
            name: 'forecastId',
            type: 11,
            flags: 520,
            indexId: const obx_int.IdUid(2, 6844138676346082205),
            relationTarget: 'Forecast'),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 1134278265371922395),
            name: 'dbTime',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(9, 5894981568594173386),
            name: 'time',
            type: 10,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(4, 6420228095169690693),
      name: 'Forecast',
      lastPropertyId: const obx_int.IdUid(5, 3233924637434981959),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 164024686731217540),
            name: 'id',
            type: 6,
            flags: 129),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 2901474346780297146),
            name: 'latitude',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 1885365826762958758),
            name: 'longitude',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 934899536738238602),
            name: 'timezome',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 3233924637434981959),
            name: 'pressure',
            type: 8,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(5, 8173371938174065105),
      name: 'HourlyWeatherData',
      lastPropertyId: const obx_int.IdUid(14, 1342308400042582973),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 3187230548200897399),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 966557653877511998),
            name: 'time',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 7279000057536307706),
            name: 'temperature',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 4176908954404566916),
            name: 'apparentTemperature',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 3547794455906734640),
            name: 'humidity',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 3502222474914194231),
            name: 'rainProbability',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 4344479545282929369),
            name: 'rainInMM',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 3028885842851079330),
            name: 'weatherCodeNum',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(9, 8358054488921457027),
            name: 'cloudCover',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(10, 1253310253006595269),
            name: 'windSpeed',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(11, 8536476079822477782),
            name: 'windDirection',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(12, 8866942346576763698),
            name: 'windGusts',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(13, 8469159707373024134),
            name: 'forecastId',
            type: 11,
            flags: 520,
            indexId: const obx_int.IdUid(3, 2791591927145922910),
            relationTarget: 'Forecast'),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(14, 1342308400042582973),
            name: 'dbTime',
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
      lastEntityId: const obx_int.IdUid(5, 8173371938174065105),
      lastIndexId: const obx_int.IdUid(3, 2791591927145922910),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [4959212640223385591],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        2222587056346663194,
        5241379067991271440,
        3413672586752819897,
        2667735000207519754,
        3007341840825496508,
        6508642052868466290,
        2000977072288292402,
        6318597669143456282,
        471067176363371422,
        5787941398622077731,
        8035218165518029936,
        355656367909523738,
        8521224176931923367,
        2722435669115636181,
        3478895322221109934
      ],
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
          fbb.startTable(10);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addFloat64(2, object.latitude);
          fbb.addFloat64(3, object.longitude);
          fbb.addOffset(4, countryOffset);
          fbb.addInt64(5, object.selectedPage);
          fbb.addOffset(6, selectedForecastItemsDbOffset);
          fbb.addInt64(7, object.ordening);
          fbb.addBool(8, object.isCurrentLocation);
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
          final isCurrentLocationParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 20, false);
          final ordeningParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 18, 0);
          final object = Geocoding(
              idParam, nameParam, latitudeParam, longitudeParam, countryParam,
              isCurrentLocation: isCurrentLocationParam,
              ordening: ordeningParam)
            ..selectedPage =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0)
            ..selectedForecastItemsDb =
                const fb.ListReader<int>(fb.Int64Reader(), lazy: false)
                    .vTableGet(buffer, rootOffset, 16, []);

          return object;
        }),
    DailyWeatherData: obx_int.EntityDefinition<DailyWeatherData>(
        model: _entities[1],
        toOneRelations: (DailyWeatherData object) => [object.forecast],
        toManyRelations: (DailyWeatherData object) => {},
        getId: (DailyWeatherData object) => object.id,
        setId: (DailyWeatherData object, int id) {
          object.id = id;
        },
        objectToFB: (DailyWeatherData object, fb.Builder fbb) {
          fbb.startTable(10);
          fbb.addInt64(0, object.id);
          fbb.addInt64(2, object.sunrise.millisecondsSinceEpoch);
          fbb.addInt64(3, object.sunset.millisecondsSinceEpoch);
          fbb.addFloat64(4, object.uvIndex);
          fbb.addFloat64(5, object.clearSkyUvIndex);
          fbb.addInt64(6, object.forecast.targetId);
          fbb.addInt64(7, object.dbTime);
          fbb.addInt64(8, object.time.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final timeParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 20, 0));
          final sunriseParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0));
          final sunsetParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0));
          final uvIndexParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 12, 0);
          final clearSkyUvIndexParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 14, 0);
          final object = DailyWeatherData(timeParam, sunriseParam, sunsetParam,
              uvIndexParam, clearSkyUvIndexParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..dbTime =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 18, 0);
          object.forecast.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0);
          object.forecast.attach(store);
          return object;
        }),
    Forecast: obx_int.EntityDefinition<Forecast>(
        model: _entities[2],
        toOneRelations: (Forecast object) => [],
        toManyRelations: (Forecast object) => {},
        getId: (Forecast object) => object.id,
        setId: (Forecast object, int id) {
          object.id = id;
        },
        objectToFB: (Forecast object, fb.Builder fbb) {
          final timezomeOffset = fbb.writeString(object.timezome);
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addFloat64(1, object.latitude);
          fbb.addFloat64(2, object.longitude);
          fbb.addOffset(3, timezomeOffset);
          fbb.addFloat64(4, object.pressure);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final latitudeParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 6, 0);
          final longitudeParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 8, 0);
          final timezomeParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 10, '');
          final pressureParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 12, 0);
          final object = Forecast(
              latitudeParam, longitudeParam, timezomeParam, pressureParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    HourlyWeatherData: obx_int.EntityDefinition<HourlyWeatherData>(
        model: _entities[3],
        toOneRelations: (HourlyWeatherData object) => [object.forecast],
        toManyRelations: (HourlyWeatherData object) => {},
        getId: (HourlyWeatherData object) => object.id,
        setId: (HourlyWeatherData object, int id) {
          object.id = id;
        },
        objectToFB: (HourlyWeatherData object, fb.Builder fbb) {
          fbb.startTable(15);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.time.millisecondsSinceEpoch);
          fbb.addFloat64(2, object.temperature);
          fbb.addFloat64(3, object.apparentTemperature);
          fbb.addInt64(4, object.humidity);
          fbb.addInt64(5, object.rainProbability);
          fbb.addFloat64(6, object.rainInMM);
          fbb.addInt64(7, object.weatherCodeNum);
          fbb.addInt64(8, object.cloudCover);
          fbb.addFloat64(9, object.windSpeed);
          fbb.addInt64(10, object.windDirection);
          fbb.addFloat64(11, object.windGusts);
          fbb.addInt64(12, object.forecast.targetId);
          fbb.addInt64(13, object.dbTime);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final timeParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0));
          final temperatureParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 8, 0);
          final apparentTemperatureParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 10, 0);
          final humidityParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0);
          final rainProbabilityParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0);
          final rainInMMParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 16, 0);
          final weatherCodeNumParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 18, 0);
          final cloudCoverParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 20, 0);
          final windSpeedParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 22, 0);
          final windDirectionParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 24, 0);
          final windGustsParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 26, 0);
          final object = HourlyWeatherData(
              timeParam,
              temperatureParam,
              apparentTemperatureParam,
              humidityParam,
              rainProbabilityParam,
              rainInMMParam,
              weatherCodeNumParam,
              cloudCoverParam,
              windSpeedParam,
              windDirectionParam,
              windGustsParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..dbTime =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 30, 0);
          object.forecast.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 28, 0);
          object.forecast.attach(store);
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

  /// See [Geocoding.isCurrentLocation].
  static final isCurrentLocation =
      obx.QueryBooleanProperty<Geocoding>(_entities[0].properties[8]);
}

/// [DailyWeatherData] entity fields to define ObjectBox queries.
class DailyWeatherData_ {
  /// See [DailyWeatherData.id].
  static final id =
      obx.QueryIntegerProperty<DailyWeatherData>(_entities[1].properties[0]);

  /// See [DailyWeatherData.sunrise].
  static final sunrise =
      obx.QueryDateProperty<DailyWeatherData>(_entities[1].properties[1]);

  /// See [DailyWeatherData.sunset].
  static final sunset =
      obx.QueryDateProperty<DailyWeatherData>(_entities[1].properties[2]);

  /// See [DailyWeatherData.uvIndex].
  static final uvIndex =
      obx.QueryDoubleProperty<DailyWeatherData>(_entities[1].properties[3]);

  /// See [DailyWeatherData.clearSkyUvIndex].
  static final clearSkyUvIndex =
      obx.QueryDoubleProperty<DailyWeatherData>(_entities[1].properties[4]);

  /// See [DailyWeatherData.forecast].
  static final forecast = obx.QueryRelationToOne<DailyWeatherData, Forecast>(
      _entities[1].properties[5]);

  /// See [DailyWeatherData.dbTime].
  static final dbTime =
      obx.QueryIntegerProperty<DailyWeatherData>(_entities[1].properties[6]);

  /// See [DailyWeatherData.time].
  static final time =
      obx.QueryDateProperty<DailyWeatherData>(_entities[1].properties[7]);
}

/// [Forecast] entity fields to define ObjectBox queries.
class Forecast_ {
  /// See [Forecast.id].
  static final id =
      obx.QueryIntegerProperty<Forecast>(_entities[2].properties[0]);

  /// See [Forecast.latitude].
  static final latitude =
      obx.QueryDoubleProperty<Forecast>(_entities[2].properties[1]);

  /// See [Forecast.longitude].
  static final longitude =
      obx.QueryDoubleProperty<Forecast>(_entities[2].properties[2]);

  /// See [Forecast.timezome].
  static final timezome =
      obx.QueryStringProperty<Forecast>(_entities[2].properties[3]);

  /// See [Forecast.pressure].
  static final pressure =
      obx.QueryDoubleProperty<Forecast>(_entities[2].properties[4]);
}

/// [HourlyWeatherData] entity fields to define ObjectBox queries.
class HourlyWeatherData_ {
  /// See [HourlyWeatherData.id].
  static final id =
      obx.QueryIntegerProperty<HourlyWeatherData>(_entities[3].properties[0]);

  /// See [HourlyWeatherData.time].
  static final time =
      obx.QueryDateProperty<HourlyWeatherData>(_entities[3].properties[1]);

  /// See [HourlyWeatherData.temperature].
  static final temperature =
      obx.QueryDoubleProperty<HourlyWeatherData>(_entities[3].properties[2]);

  /// See [HourlyWeatherData.apparentTemperature].
  static final apparentTemperature =
      obx.QueryDoubleProperty<HourlyWeatherData>(_entities[3].properties[3]);

  /// See [HourlyWeatherData.humidity].
  static final humidity =
      obx.QueryIntegerProperty<HourlyWeatherData>(_entities[3].properties[4]);

  /// See [HourlyWeatherData.rainProbability].
  static final rainProbability =
      obx.QueryIntegerProperty<HourlyWeatherData>(_entities[3].properties[5]);

  /// See [HourlyWeatherData.rainInMM].
  static final rainInMM =
      obx.QueryDoubleProperty<HourlyWeatherData>(_entities[3].properties[6]);

  /// See [HourlyWeatherData.weatherCodeNum].
  static final weatherCodeNum =
      obx.QueryIntegerProperty<HourlyWeatherData>(_entities[3].properties[7]);

  /// See [HourlyWeatherData.cloudCover].
  static final cloudCover =
      obx.QueryIntegerProperty<HourlyWeatherData>(_entities[3].properties[8]);

  /// See [HourlyWeatherData.windSpeed].
  static final windSpeed =
      obx.QueryDoubleProperty<HourlyWeatherData>(_entities[3].properties[9]);

  /// See [HourlyWeatherData.windDirection].
  static final windDirection =
      obx.QueryIntegerProperty<HourlyWeatherData>(_entities[3].properties[10]);

  /// See [HourlyWeatherData.windGusts].
  static final windGusts =
      obx.QueryDoubleProperty<HourlyWeatherData>(_entities[3].properties[11]);

  /// See [HourlyWeatherData.forecast].
  static final forecast = obx.QueryRelationToOne<HourlyWeatherData, Forecast>(
      _entities[3].properties[12]);

  /// See [HourlyWeatherData.dbTime].
  static final dbTime =
      obx.QueryIntegerProperty<HourlyWeatherData>(_entities[3].properties[13]);
}
