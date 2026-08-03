import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/endpoints.dart';
import '../models/checkin_api_responses.dart';

part 'checkin_api.g.dart';

@RestApi()
abstract class CheckinApi {
  factory CheckinApi(Dio dio, {String baseUrl}) = _CheckinApi;

  @POST(Endpoints.mobileCheckinQr)
  Future<QrGenerateApiResponse> generateQr();

  @GET(Endpoints.mobileCheckinQrStatus)
  Future<QrStatusApiResponse> getQrStatus(@Path('id') String id);
}
