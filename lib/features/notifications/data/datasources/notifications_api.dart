import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/endpoints.dart';
import '../models/notifications_api_responses.dart';

part 'notifications_api.g.dart';

@RestApi()
abstract class NotificationsApi {
  factory NotificationsApi(Dio dio, {String baseUrl}) = _NotificationsApi;

  @GET(Endpoints.mobileNotifications)
  Future<NotificationsApiResponse> getNotifications({
    @Query('page') int page = 1,
    @Query('limit') int limit = 20,
    @Query('unreadOnly') bool? unreadOnly,
  });

  @GET(Endpoints.mobileNotificationsUnreadCount)
  Future<UnreadCountApiResponse> getUnreadCount();

  @GET(Endpoints.mobileNotificationById)
  Future<NotificationApiResponse> getNotificationById(@Path('id') String id);

  @PATCH(Endpoints.mobileNotificationsReadAll)
  Future<ReadAllApiResponse> markAllAsRead();
}
