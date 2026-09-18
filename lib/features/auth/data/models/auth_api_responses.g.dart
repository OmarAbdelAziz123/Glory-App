// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpSentApiResponse _$OtpSentApiResponseFromJson(Map<String, dynamic> json) =>
    OtpSentApiResponse(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : OtpSentModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$OtpSentApiResponseToJson(OtpSentApiResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'message': instance.message,
    };

VerifyOtpApiResponse _$VerifyOtpApiResponseFromJson(
  Map<String, dynamic> json,
) => VerifyOtpApiResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : VerifyOtpModel.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$VerifyOtpApiResponseToJson(
  VerifyOtpApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

MemberApiResponse _$MemberApiResponseFromJson(Map<String, dynamic> json) =>
    MemberApiResponse(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : MemberModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$MemberApiResponseToJson(MemberApiResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'message': instance.message,
    };

LoginApiResponse _$LoginApiResponseFromJson(Map<String, dynamic> json) =>
    LoginApiResponse(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : LoginModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$LoginApiResponseToJson(LoginApiResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'message': instance.message,
    };

LogoutApiResponse _$LogoutApiResponseFromJson(Map<String, dynamic> json) =>
    LogoutApiResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$LogoutApiResponseToJson(LogoutApiResponse instance) =>
    <String, dynamic>{'success': instance.success, 'message': instance.message};

ResetPasswordApiResponse _$ResetPasswordApiResponseFromJson(
  Map<String, dynamic> json,
) => ResetPasswordApiResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : ResetPasswordModel.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$ResetPasswordApiResponseToJson(
  ResetPasswordApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

NotificationsApiResponse _$NotificationsApiResponseFromJson(
  Map<String, dynamic> json,
) => NotificationsApiResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : NotificationsModel.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$NotificationsApiResponseToJson(
  NotificationsApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

MessageApiResponse _$MessageApiResponseFromJson(Map<String, dynamic> json) =>
    MessageApiResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$MessageApiResponseToJson(MessageApiResponse instance) =>
    <String, dynamic>{'success': instance.success, 'message': instance.message};
