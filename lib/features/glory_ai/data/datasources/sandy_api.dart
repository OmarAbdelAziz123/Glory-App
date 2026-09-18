import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/endpoints.dart';
import '../models/sandy_api_responses.dart';
import '../models/sandy_models.dart';

part 'sandy_api.g.dart';

@RestApi()
abstract class SandyApi {
  factory SandyApi(Dio dio, {String baseUrl}) = _SandyApi;

  @POST(Endpoints.mobileSandyChat)
  Future<SandyChatApiResponse> sendMessage(@Body() SandyChatRequest body);

  @GET(Endpoints.mobileSandySuggestions)
  Future<SandySuggestionsApiResponse> getSuggestions({
    @Query('lang') String? lang,
  });

  @GET(Endpoints.mobileSandyConversations)
  Future<SandyConversationsApiResponse> getConversations();

  @GET(Endpoints.mobileSandyConversationMessages)
  Future<SandyMessagesApiResponse> getMessages(
    @Path('id') String conversationId, {
    @Query('page') int page = 1,
    @Query('limit') int limit = 30,
  });

  @PATCH(Endpoints.mobileSandyConversationById)
  Future<SandyVoidApiResponse> renameConversation(
    @Path('id') String conversationId,
    @Body() SandyRenameConversationRequest body,
  );

  @DELETE(Endpoints.mobileSandyConversationById)
  Future<SandyVoidApiResponse> deleteConversation(
    @Path('id') String conversationId,
  );

  @POST(Endpoints.mobileSandyDocuments)
  Future<SandyAnalyzeDocumentApiResponse> analyzeDocument(
    @Body() SandyAnalyzeDocumentRequest body,
  );

  @GET(Endpoints.mobileSandyDocuments)
  Future<SandyDocumentsApiResponse> getDocuments({
    @Query('page') int page = 1,
    @Query('limit') int limit = 20,
  });

  @GET(Endpoints.mobileSandyDocumentById)
  Future<SandyDocumentApiResponse> getDocument(@Path('id') String documentId);

  @DELETE(Endpoints.mobileSandyDocumentById)
  Future<SandyVoidApiResponse> deleteDocument(@Path('id') String documentId);
}
