import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/endpoints.dart';
import '../models/onboarding_api_responses.dart';
import '../models/onboarding_request.dart';

part 'onboarding_api.g.dart';

@RestApi()
abstract class OnboardingApi {
  factory OnboardingApi(Dio dio, {String baseUrl}) = _OnboardingApi;

  @GET(Endpoints.onboardingStatus)
  Future<OnboardingStatusApiResponse> getStatus();

  @POST(Endpoints.onboarding)
  Future<OnboardingSubmitApiResponse> submit(@Body() OnboardingRequest body);

  @GET(Endpoints.onboarding)
  Future<OnboardingSubmitApiResponse> getSaved();
}
