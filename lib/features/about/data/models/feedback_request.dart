import 'package:json_annotation/json_annotation.dart';

part 'feedback_request.g.dart';

@JsonSerializable(createFactory: false)
final class FeedbackRequest {
  const FeedbackRequest({required this.message});

  Map<String, dynamic> toJson() => _$FeedbackRequestToJson(this);

  final String message;
}
