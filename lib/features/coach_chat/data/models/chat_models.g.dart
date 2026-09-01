// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatParticipantModel _$ChatParticipantModelFromJson(
  Map<String, dynamic> json,
) => ChatParticipantModel(
  id: json['id'] as String,
  fullName: json['fullName'] as String,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$ChatParticipantModelToJson(
  ChatParticipantModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'avatarUrl': instance.avatarUrl,
};

ChatConversationModel _$ChatConversationModelFromJson(
  Map<String, dynamic> json,
) => ChatConversationModel(
  id: json['id'] as String,
  memberId: json['memberId'] as String,
  instructorId: json['instructorId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastMessageAt: json['lastMessageAt'] == null
      ? null
      : DateTime.parse(json['lastMessageAt'] as String),
  instructor: ChatParticipantModel.fromJson(
    json['instructor'] as Map<String, dynamic>,
  ),
  unreadCount: (json['unreadCount'] as num).toInt(),
);

Map<String, dynamic> _$ChatConversationModelToJson(
  ChatConversationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'memberId': instance.memberId,
  'instructorId': instance.instructorId,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
  'instructor': instance.instructor,
  'unreadCount': instance.unreadCount,
};

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    ChatMessageModel(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderType: json['senderType'] as String,
      sender: ChatParticipantModel.fromJson(
        json['sender'] as Map<String, dynamic>,
      ),
      body: json['body'] as String,
      read: json['read'] as bool,
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'senderType': instance.senderType,
      'sender': instance.sender,
      'body': instance.body,
      'read': instance.read,
      'readAt': instance.readAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

ChatUnreadCountModel _$ChatUnreadCountModelFromJson(
  Map<String, dynamic> json,
) => ChatUnreadCountModel(count: (json['count'] as num).toInt());

Map<String, dynamic> _$ChatUnreadCountModelToJson(
  ChatUnreadCountModel instance,
) => <String, dynamic>{'count': instance.count};

ChatMarkReadModel _$ChatMarkReadModelFromJson(Map<String, dynamic> json) =>
    ChatMarkReadModel(updated: (json['updated'] as num).toInt());

Map<String, dynamic> _$ChatMarkReadModelToJson(ChatMarkReadModel instance) =>
    <String, dynamic>{'updated': instance.updated};
