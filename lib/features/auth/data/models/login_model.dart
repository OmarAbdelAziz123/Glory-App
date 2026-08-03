import 'package:json_annotation/json_annotation.dart';

import 'member_model.dart';

part 'login_model.g.dart';

@JsonSerializable()
final class LoginModel {
  const LoginModel({
    required this.accessToken,
    required this.refreshToken,
    required this.member,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  final String accessToken;
  final String refreshToken;
  final MemberModel member;
}
