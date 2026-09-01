import 'package:json_annotation/json_annotation.dart';

import '../../../../core/network/models/pagination_meta_model.dart';
import 'sandy_models.dart';

part 'sandy_api_responses.g.dart';

@JsonSerializable()
final class SandyChatApiResponse {
  const SandyChatApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory SandyChatApiResponse.fromJson(Map<String, dynamic> json) =>
      _$SandyChatApiResponseFromJson(json);

  final bool success;
  final SandyChatResponseModel? data;
  final String? message;
}

@JsonSerializable()
final class SandySuggestionsApiResponse {
  const SandySuggestionsApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory SandySuggestionsApiResponse.fromJson(Map<String, dynamic> json) =>
      _$SandySuggestionsApiResponseFromJson(json);

  final bool success;
  final List<String>? data;
  final String? message;
}

@JsonSerializable()
final class SandyConversationsApiResponse {
  const SandyConversationsApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory SandyConversationsApiResponse.fromJson(Map<String, dynamic> json) =>
      _$SandyConversationsApiResponseFromJson(json);

  final bool success;
  final List<SandyConversationModel>? data;
  final String? message;
}

@JsonSerializable()
final class SandyMessagesApiResponse {
  const SandyMessagesApiResponse({
    required this.success,
    this.data,
    this.meta,
    this.message,
  });

  factory SandyMessagesApiResponse.fromJson(Map<String, dynamic> json) =>
      _$SandyMessagesApiResponseFromJson(json);

  final bool success;
  final List<SandyMessageModel>? data;
  final PaginationMetaModel? meta;
  final String? message;
}

@JsonSerializable()
final class SandyVoidApiResponse {
  const SandyVoidApiResponse({
    required this.success,
    this.message,
  });

  factory SandyVoidApiResponse.fromJson(Map<String, dynamic> json) =>
      _$SandyVoidApiResponseFromJson(json);

  final bool success;
  final String? message;
}
