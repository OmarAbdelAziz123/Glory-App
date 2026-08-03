import 'package:json_annotation/json_annotation.dart';

import 'contact_links_model.dart';
import 'faq_model.dart';
import 'info_page_model.dart';

part 'content_api_responses.g.dart';

@JsonSerializable()
final class InfoPageApiResponse {
  const InfoPageApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory InfoPageApiResponse.fromJson(Map<String, dynamic> json) =>
      _$InfoPageApiResponseFromJson(json);

  final bool success;
  final InfoPageModel? data;
  final String? message;
}

@JsonSerializable()
final class InfoPagesApiResponse {
  const InfoPagesApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory InfoPagesApiResponse.fromJson(Map<String, dynamic> json) =>
      _$InfoPagesApiResponseFromJson(json);

  final bool success;
  final List<InfoPageModel>? data;
  final String? message;
}

@JsonSerializable()
final class FaqsApiResponse {
  const FaqsApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory FaqsApiResponse.fromJson(Map<String, dynamic> json) =>
      _$FaqsApiResponseFromJson(json);

  final bool success;
  final List<FaqModel>? data;
  final String? message;
}

@JsonSerializable()
final class ContactApiResponse {
  const ContactApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory ContactApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactApiResponseFromJson(json);

  final bool success;
  final ContactLinksModel? data;
  final String? message;
}

@JsonSerializable()
final class FeedbackApiResponse {
  const FeedbackApiResponse({
    required this.success,
    this.message,
  });

  factory FeedbackApiResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedbackApiResponseFromJson(json);

  final bool success;
  final String? message;
}
