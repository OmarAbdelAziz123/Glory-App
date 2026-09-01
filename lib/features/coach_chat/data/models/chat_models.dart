import 'package:json_annotation/json_annotation.dart';

part 'chat_models.g.dart';

@JsonSerializable()
final class ChatParticipantModel {
  const ChatParticipantModel({
    required this.id,
    required this.fullName,
    this.avatarUrl,
  });

  factory ChatParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$ChatParticipantModelFromJson(json);

  final String id;
  final String fullName;
  final String? avatarUrl;
}

@JsonSerializable()
final class ChatConversationModel {
  const ChatConversationModel({
    required this.id,
    required this.memberId,
    required this.instructorId,
    required this.createdAt,
    this.lastMessageAt,
    required this.instructor,
    required this.unreadCount,
  });

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ChatConversationModelFromJson(json);

  final String id;
  final String memberId;
  final String instructorId;
  final DateTime createdAt;
  final DateTime? lastMessageAt;
  final ChatParticipantModel instructor;
  final int unreadCount;
}

@JsonSerializable()
final class ChatMessageModel {
  const ChatMessageModel({
    required this.id,
    required this.conversationId,
    required this.senderType,
    required this.sender,
    required this.body,
    required this.read,
    this.readAt,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  final String id;
  final String conversationId;
  final String senderType;
  final ChatParticipantModel sender;
  final String body;
  final bool read;
  final DateTime? readAt;
  final DateTime createdAt;
}

@JsonSerializable()
final class ChatUnreadCountModel {
  const ChatUnreadCountModel({required this.count});

  factory ChatUnreadCountModel.fromJson(Map<String, dynamic> json) =>
      _$ChatUnreadCountModelFromJson(json);

  final int count;
}

@JsonSerializable()
final class ChatMarkReadModel {
  const ChatMarkReadModel({required this.updated});

  factory ChatMarkReadModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMarkReadModelFromJson(json);

  final int updated;
}
