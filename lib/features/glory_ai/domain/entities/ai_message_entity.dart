enum AiMessageRole { user, assistant }

final class AiMessageEntity {
  const AiMessageEntity({
    required this.id,
    required this.content,
    required this.role,
    required this.createdAt,
  });

  final String id;
  final String content;
  final AiMessageRole role;
  final DateTime createdAt;
}
