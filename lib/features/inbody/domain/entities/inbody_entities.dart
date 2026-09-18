enum InbodySource { inbody, manual }

abstract final class InbodyMetricKey {
  static const weight = 'weight';
  static const muscleMass = 'muscleMass';
  static const bodyFat = 'bodyFat';
  static const bodyWater = 'bodyWater';
  static const visceralFat = 'visceralFat';
  static const bmi = 'bmi';
  static const bmr = 'bmr';
  static const metabolicAge = 'metabolicAge';
  static const inbodyScore = 'inbodyScore';
  static const height = 'height';
  static const bodyFatMass = 'bodyFatMass';

  static const chartKeys = [weight, muscleMass, bodyFat];
  static const primaryKeys = [
    weight,
    muscleMass,
    bodyFat,
    bodyWater,
    visceralFat,
    bmi,
    bmr,
    metabolicAge,
  ];
}

enum InbodyMetricTone { lowerIsBetter, higherIsBetter, neutral }

InbodyMetricTone inbodyMetricTone(String key) {
  return switch (key) {
    InbodyMetricKey.muscleMass ||
    InbodyMetricKey.bodyWater ||
    InbodyMetricKey.bmr ||
    InbodyMetricKey.inbodyScore =>
      InbodyMetricTone.higherIsBetter,
    InbodyMetricKey.height => InbodyMetricTone.neutral,
    _ => InbodyMetricTone.lowerIsBetter,
  };
}

final class InbodyStaffEntity {
  const InbodyStaffEntity({required this.id, required this.fullName});

  final String id;
  final String fullName;
}

final class InbodyDeltaEntity {
  const InbodyDeltaEntity({this.previous, this.delta});

  final double? previous;
  final double? delta;
}

final class InbodyChangesEntity {
  const InbodyChangesEntity({
    this.previousId,
    this.previousAt,
    this.metrics = const {},
  });

  final String? previousId;
  final DateTime? previousAt;
  final Map<String, InbodyDeltaEntity> metrics;

  InbodyDeltaEntity? of(String key) => metrics[key];
}

final class InbodyMetricsEntity {
  const InbodyMetricsEntity({
    this.weight,
    this.muscleMass,
    this.bodyFat,
    this.bodyWater,
    this.visceralFat,
    this.bmi,
    this.bmr,
    this.metabolicAge,
  });

  final double? weight;
  final double? muscleMass;
  final double? bodyFat;
  final double? bodyWater;
  final double? visceralFat;
  final double? bmi;
  final double? bmr;
  final double? metabolicAge;

  double? valueOf(String key) => switch (key) {
        InbodyMetricKey.weight => weight,
        InbodyMetricKey.muscleMass => muscleMass,
        InbodyMetricKey.bodyFat => bodyFat,
        InbodyMetricKey.bodyWater => bodyWater,
        InbodyMetricKey.visceralFat => visceralFat,
        InbodyMetricKey.bmi => bmi,
        InbodyMetricKey.bmr => bmr,
        InbodyMetricKey.metabolicAge => metabolicAge,
        _ => null,
      };
}

final class InbodyExtrasEntity {
  const InbodyExtrasEntity({
    this.inbodyScore,
    this.height,
    this.bodyFatMass,
  });

  final double? inbodyScore;
  final double? height;
  final double? bodyFatMass;

  bool get hasAny =>
      inbodyScore != null || height != null || bodyFatMass != null;
}

final class InbodyTestEntity {
  const InbodyTestEntity({
    required this.id,
    required this.recordedAt,
    required this.source,
    this.device,
    this.enteredBy,
    this.pdfUrl,
    this.metrics = const InbodyMetricsEntity(),
    this.extras = const InbodyExtrasEntity(),
    this.changes,
    this.raw,
  });

  final String id;
  final DateTime recordedAt;
  final InbodySource source;
  final String? device;
  final InbodyStaffEntity? enteredBy;
  final String? pdfUrl;
  final InbodyMetricsEntity metrics;
  final InbodyExtrasEntity extras;
  final InbodyChangesEntity? changes;
  final Map<String, dynamic>? raw;

  bool get isDevice => source == InbodySource.inbody;
  bool get hasPdf => pdfUrl != null && pdfUrl!.isNotEmpty;
  bool get hasRaw => raw != null && raw!.isNotEmpty;
}

final class InbodySummaryEntity {
  const InbodySummaryEntity({
    required this.total,
    this.deviceCount = 0,
    this.manualCount = 0,
    this.firstAt,
    this.latestAt,
    this.latest,
    this.sinceFirst = const {},
  });

  final int total;
  final int deviceCount;
  final int manualCount;
  final DateTime? firstAt;
  final DateTime? latestAt;
  final InbodyTestEntity? latest;
  final Map<String, InbodyDeltaEntity> sinceFirst;

  bool get isEmpty => total == 0;
}

final class InbodyTrendPointEntity {
  const InbodyTrendPointEntity({
    required this.id,
    required this.recordedAt,
    required this.source,
    required this.values,
  });

  final String id;
  final DateTime recordedAt;
  final InbodySource source;
  final Map<String, double?> values;

  double? valueOf(String key) => values[key];
}

final class InbodyTrendsEntity {
  const InbodyTrendsEntity({
    this.metrics = const [],
    this.points = const [],
  });

  final List<String> metrics;
  final List<InbodyTrendPointEntity> points;
}

final class InbodyPageEntity {
  const InbodyPageEntity({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  final List<InbodyTestEntity> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  bool get hasMore => page < totalPages;
}
