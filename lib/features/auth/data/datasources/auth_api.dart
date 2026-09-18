import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/endpoints.dart';
import '../models/auth_api_responses.dart';
import '../models/complete_registration_request.dart';
import '../models/confirm_code_request.dart';
import '../models/forgot_password_request.dart';
import '../models/login_request.dart';
import '../models/logout_request.dart';
import '../models/refresh_token_request.dart';
import '../models/register_request.dart';
import '../models/resend_otp_request.dart';
import '../models/reset_password_request.dart';
import '../models/update_notifications_request.dart';
import '../models/verify_otp_request.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST(Endpoints.register)
  Future<OtpSentApiResponse> register(@Body() RegisterRequest body);

  @POST(Endpoints.verifyOtp)
  Future<VerifyOtpApiResponse> verifyOtp(@Body() VerifyOtpRequest body);

  @POST(Endpoints.resendOtp)
  Future<OtpSentApiResponse> resendOtp(@Body() ResendOtpRequest body);

  @POST(Endpoints.completeRegistration)
  Future<MemberApiResponse> completeRegistration(
    @Body() CompleteRegistrationRequest body,
  );

  @POST(Endpoints.forgotPassword)
  Future<OtpSentApiResponse> forgotPassword(@Body() ForgotPasswordRequest body);

  @POST(Endpoints.resetPassword)
  Future<ResetPasswordApiResponse> resetPassword(
    @Body() ResetPasswordRequest body,
  );

  @POST(Endpoints.login)
  Future<LoginApiResponse> login(@Body() LoginRequest body);

  @GET(Endpoints.mobileProfile)
  Future<MemberApiResponse> getProfile();

  @PATCH(Endpoints.mobileProfileNotifications)
  Future<NotificationsApiResponse> updateNotifications(
    @Body() UpdateNotificationsRequest body,
  );

  @POST(Endpoints.refreshToken)
  Future<LoginApiResponse> refreshToken(@Body() RefreshTokenRequest body);

  @POST(Endpoints.logout)
  Future<LogoutApiResponse> logout(@Body() LogoutRequest body);

  @POST(Endpoints.mobileProfileDeleteAccountRequest)
  Future<OtpSentApiResponse> requestDeleteAccount();

  @DELETE(Endpoints.mobileProfileDeleteAccountConfirm)
  Future<MessageApiResponse> confirmDeleteAccount(
    @Body() ConfirmCodeRequest body,
  );
}
