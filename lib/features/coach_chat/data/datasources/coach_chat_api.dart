import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/endpoints.dart';
import '../models/chat_api_responses.dart';

part 'coach_chat_api.g.dart';

@RestApi()
abstract class CoachChatApi {
  factory CoachChatApi(Dio dio, {String baseUrl}) = _CoachChatApi;

  @GET(Endpoints.mobileChatConversations)
  Future<ChatConversationsApiResponse> getConversations();

  @GET(Endpoints.mobileChatConversationMessages)
  Future<ChatMessagesApiResponse> getMessages(
    @Path('id') String conversationId, {
    @Query('page') int page = 1,
    @Query('limit') int limit = 30,
  });

  @PATCH(Endpoints.mobileChatConversationRead)
  Future<ChatMarkReadApiResponse> markAsRead(@Path('id') String conversationId);

  @GET(Endpoints.mobileChatUnreadCount)
  Future<ChatUnreadCountApiResponse> getUnreadCount();
}
