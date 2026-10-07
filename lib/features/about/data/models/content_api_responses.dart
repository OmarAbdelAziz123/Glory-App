import 'package:json_annotation/json_annotation.dart';

import 'contact_channel_model.dart';
import 'contact_links_parser.dart';
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

final class ContactApiResponse {
  const ContactApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory ContactApiResponse.fromJson(Map<String, dynamic> json) {
    return ContactApiResponse(
      success: json['success'] as bool,
      data: readContactChannelsData(json['data']),
      message: json['message'] as String?,
    );
  }

  final bool success;
  final List<ContactChannelModel>? data;
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
