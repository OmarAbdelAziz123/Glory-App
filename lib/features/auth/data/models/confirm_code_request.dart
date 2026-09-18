import 'package:json_annotation/json_annotation.dart';

part 'confirm_code_request.g.dart';

@JsonSerializable(createFactory: false)
final class ConfirmCodeRequest {
  const ConfirmCodeRequest({required this.code});

  Map<String, dynamic> toJson() => _$ConfirmCodeRequestToJson(this);

  final String code;
}
