import '../../domain/entities/inbody_entities.dart';

double? readInbodyNumber(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

DateTime? readInbodyDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

InbodySource readInbodySource(dynamic value) {
  final raw = value?.toString().toUpperCase();
  return raw == 'MANUAL' ? InbodySource.manual : InbodySource.inbody;
}

Map<String, dynamic> asStringKeyedMap(dynamic value) {
  if (value is! Map) return const {};
  return value.map((key, item) => MapEntry(key.toString(), item));
}

InbodyDeltaEntity readInbodyDelta(dynamic value) {
  final map = asStringKeyedMap(value);
  return InbodyDeltaEntity(
    previous: readInbodyNumber(map['previous']),
    delta: readInbodyNumber(map['delta']),
  );
}

Map<String, InbodyDeltaEntity> readInbodyDeltaMap(dynamic value) {
  final map = asStringKeyedMap(value);
  final deltas = <String, InbodyDeltaEntity>{};
  for (final entry in map.entries) {
    if (entry.key == 'previousId' || entry.key == 'previousAt') continue;
    if (entry.value is Map) {
      deltas[entry.key] = readInbodyDelta(entry.value);
    }
  }
  return deltas;
}

InbodyStaffEntity? readInbodyStaff(dynamic value) {
  final map = asStringKeyedMap(value);
  final id = map['id']?.toString();
  final fullName = map['fullName']?.toString();
  if (id == null || id.isEmpty || fullName == null || fullName.isEmpty) {
    return null;
  }
  return InbodyStaffEntity(id: id, fullName: fullName);
}

InbodyMetricsEntity readInbodyMetrics(dynamic value) {
  final map = asStringKeyedMap(value);
  return InbodyMetricsEntity(
    weight: readInbodyNumber(map[InbodyMetricKey.weight]),
    muscleMass: readInbodyNumber(map[InbodyMetricKey.muscleMass]),
    bodyFat: readInbodyNumber(map[InbodyMetricKey.bodyFat]),
    bodyWater: readInbodyNumber(map[InbodyMetricKey.bodyWater]),
    visceralFat: readInbodyNumber(map[InbodyMetricKey.visceralFat]),
    bmi: readInbodyNumber(map[InbodyMetricKey.bmi]),
    bmr: readInbodyNumber(map[InbodyMetricKey.bmr]),
    metabolicAge: readInbodyNumber(map[InbodyMetricKey.metabolicAge]),
  );
}

InbodyExtrasEntity readInbodyExtras(dynamic value) {
  final map = asStringKeyedMap(value);
  return InbodyExtrasEntity(
    inbodyScore: readInbodyNumber(map[InbodyMetricKey.inbodyScore]),
    height: readInbodyNumber(map[InbodyMetricKey.height]),
    bodyFatMass: readInbodyNumber(map[InbodyMetricKey.bodyFatMass]),
  );
}

InbodyChangesEntity? readInbodyChanges(dynamic value) {
  if (value == null) return null;
  final map = asStringKeyedMap(value);
  if (map.isEmpty) return null;
  return InbodyChangesEntity(
    previousId: map['previousId']?.toString(),
    previousAt: readInbodyDate(map['previousAt']),
    metrics: readInbodyDeltaMap(map),
  );
}

InbodyTestEntity readInbodyTest(dynamic value) {
  final map = asStringKeyedMap(value);
  final metricsMap = map['metrics'];
  final recordedAt = readInbodyDate(map['recordedAt']) ?? DateTime.now();

  return InbodyTestEntity(
    id: map['id']?.toString() ?? '',
    recordedAt: recordedAt,
    source: readInbodySource(map['source']),
    device: map['device']?.toString(),
    enteredBy: readInbodyStaff(map['enteredBy']),
    pdfUrl: map['pdfUrl']?.toString(),
    metrics: metricsMap is Map
        ? readInbodyMetrics(metricsMap)
        : readInbodyMetrics(map),
    extras: readInbodyExtras(map['extras']),
    changes: readInbodyChanges(map['changes']),
    raw: map['raw'] is Map ? asStringKeyedMap(map['raw']) : null,
  );
}

InbodySummaryEntity readInbodySummary(dynamic value) {
  final map = asStringKeyedMap(value);
  final bySource = asStringKeyedMap(map['bySource']);
  final latest = map['latest'];

  return InbodySummaryEntity(
    total: (map['total'] as num?)?.toInt() ?? 0,
    deviceCount: (bySource['inbody'] as num?)?.toInt() ?? 0,
    manualCount: (bySource['manual'] as num?)?.toInt() ?? 0,
    firstAt: readInbodyDate(map['firstAt']),
    latestAt: readInbodyDate(map['latestAt']),
    latest: latest == null ? null : readInbodyTest(latest),
    sinceFirst: readInbodyDeltaMap(map['sinceFirst']),
  );
}

InbodyTrendPointEntity readInbodyTrendPoint(dynamic value) {
  final map = asStringKeyedMap(value);
  final values = <String, double?>{};
  for (final key in [
    ...InbodyMetricKey.primaryKeys,
    InbodyMetricKey.inbodyScore,
    InbodyMetricKey.height,
    InbodyMetricKey.bodyFatMass,
  ]) {
    values[key] = readInbodyNumber(map[key]);
  }

  return InbodyTrendPointEntity(
    id: map['id']?.toString() ?? '',
    recordedAt: readInbodyDate(map['recordedAt']) ?? DateTime.now(),
    source: readInbodySource(map['source']),
    values: values,
  );
}

InbodyTrendsEntity readInbodyTrends(dynamic value) {
  final map = asStringKeyedMap(value);
  final metrics = (map['metrics'] as List?)
          ?.map((item) => item.toString())
          .toList(growable: false) ??
      const <String>[];
  final points = (map['points'] as List?)
          ?.map(readInbodyTrendPoint)
          .toList(growable: false) ??
      const <InbodyTrendPointEntity>[];

  return InbodyTrendsEntity(metrics: metrics, points: points);
}

InbodyPageEntity readInbodyPage(dynamic value) {
  final map = asStringKeyedMap(value);
  final items = (map['data'] as List?)
          ?.map(readInbodyTest)
          .toList(growable: false) ??
      const <InbodyTestEntity>[];
  final meta = asStringKeyedMap(map['meta']);

  return InbodyPageEntity(
    items: items,
    page: (meta['page'] as num?)?.toInt() ?? 1,
    limit: (meta['limit'] as num?)?.toInt() ?? items.length,
    total: (meta['total'] as num?)?.toInt() ?? items.length,
    totalPages: (meta['totalPages'] as num?)?.toInt() ?? 1,
  );
}
