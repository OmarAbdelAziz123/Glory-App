final class WorkoutEntity {
  const WorkoutEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.category,
    this.thumbnailUrl,
    this.videoUrl,
  });

  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final String category;
  final String? thumbnailUrl;
  final String? videoUrl;
}
