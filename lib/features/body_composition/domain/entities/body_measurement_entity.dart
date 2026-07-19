final class BodyMeasurementEntity {
  const BodyMeasurementEntity({
    required this.id,
    required this.date,
    required this.weight,
    required this.bodyFatPercentage,
    required this.muscleMass,
    this.bmi,
  });

  final String id;
  final DateTime date;
  final double weight;
  final double bodyFatPercentage;
  final double muscleMass;
  final double? bmi;
}

final class SizeMeasurementEntity {
  const SizeMeasurementEntity({
    required this.id,
    required this.date,
    this.chest,
    this.waist,
    this.hips,
    this.leftArm,
    this.rightArm,
    this.leftThigh,
    this.rightThigh,
  });

  final String id;
  final DateTime date;
  final double? chest;
  final double? waist;
  final double? hips;
  final double? leftArm;
  final double? rightArm;
  final double? leftThigh;
  final double? rightThigh;
}
