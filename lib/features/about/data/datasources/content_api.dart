import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/endpoints.dart';
import '../models/content_api_responses.dart';
import '../models/feedback_request.dart';

part 'content_api.g.dart';

@RestApi()
abstract class ContentApi {
  factory ContentApi(Dio dio, {String baseUrl}) = _ContentApi;

  @GET(Endpoints.contentPages)
  Future<InfoPagesApiResponse> getInfoPages();

  @GET(Endpoints.contentPageByKey)
  Future<InfoPageApiResponse> getInfoPageByKey(@Path('key') String key);

  @GET(Endpoints.contentFaqs)
  Future<FaqsApiResponse> getFaqs();

  @GET(Endpoints.contentContact)
  Future<ContactApiResponse> getContactLinks();

  @POST(Endpoints.feedback)
  Future<FeedbackApiResponse> submitFeedback(@Body() FeedbackRequest body);
}
