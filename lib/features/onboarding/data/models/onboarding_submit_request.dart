import 'package:json_annotation/json_annotation.dart';

part 'onboarding_submit_request.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false, explicitToJson: true)
final class OnboardingSubmitRequest {
  const OnboardingSubmitRequest({required this.answers});

  Map<String, dynamic> toJson() => _$OnboardingSubmitRequestToJson(this);

  final List<OnboardingAnswerModel> answers;
}

@JsonSerializable(createFactory: false, includeIfNull: false)
final class OnboardingAnswerModel {
  const OnboardingAnswerModel({
    required this.questionId,
    this.value,
    this.values,
    this.fileUrls,
  });

  Map<String, dynamic> toJson() => _$OnboardingAnswerModelToJson(this);

  final String questionId;
  final String? value;
  final List<String>? values;
  final List<String>? fileUrls;
}
