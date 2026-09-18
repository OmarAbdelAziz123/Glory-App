import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/endpoints.dart';
import '../models/onboarding_api_responses.dart';
import '../models/onboarding_question_model.dart';
import '../models/onboarding_request.dart';
import '../models/onboarding_submit_request.dart';

part 'onboarding_api.g.dart';

@RestApi()
abstract class OnboardingApi {
  factory OnboardingApi(Dio dio, {String baseUrl}) = _OnboardingApi;

  @GET(Endpoints.onboardingStatus)
  Future<OnboardingStatusApiResponse> getStatus();

  @GET(Endpoints.onboardingQuestions)
  Future<OnboardingQuestionsApiResponse> getQuestions();

  @POST(Endpoints.onboarding)
  Future<OnboardingSubmitApiResponse> submit(@Body() OnboardingSubmitRequest body);

  @POST(Endpoints.onboarding)
  Future<OnboardingSubmitApiResponse> submitLegacy(@Body() OnboardingRequest body);

  @GET(Endpoints.onboarding)
  Future<OnboardingSubmitApiResponse> getSaved();
}
