import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/endpoints.dart';
import '../models/add_family_member_request.dart';
import '../models/family_api_responses.dart';
import '../models/update_family_member_request.dart';

part 'family_api.g.dart';

@RestApi()
abstract class FamilyApi {
  factory FamilyApi(Dio dio, {String baseUrl}) = _FamilyApi;

  @GET(Endpoints.mobileFamily)
  Future<FamilyMembersApiResponse> getFamilyMembers({
    @Query('page') int page = 1,
    @Query('limit') int limit = 10,
  });

  @POST(Endpoints.mobileFamily)
  Future<FamilyMemberApiResponse> addFamilyMember(
    @Body() AddFamilyMemberRequest body,
  );

  @PATCH(Endpoints.mobileFamilyMember)
  Future<FamilyMemberApiResponse> updateFamilyMember(
    @Path('id') String id,
    @Body() UpdateFamilyMemberRequest body,
  );

  @DELETE(Endpoints.mobileFamilyMember)
  Future<FamilyActionApiResponse> deleteFamilyMember(@Path('id') String id);
}
