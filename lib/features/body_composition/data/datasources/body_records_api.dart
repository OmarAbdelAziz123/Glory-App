import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/endpoints.dart';
import '../models/body_record_api_responses.dart';

part 'body_records_api.g.dart';

@RestApi()
abstract class BodyRecordsApi {
  factory BodyRecordsApi(Dio dio, {String baseUrl}) = _BodyRecordsApi;

  @GET(Endpoints.mobileBodyRecords)
  Future<BodyRecordsApiResponse> getBodyRecords({
    @Query('type') required String type,
    @Query('page') int page = 1,
    @Query('limit') int limit = 10,
  });
}
