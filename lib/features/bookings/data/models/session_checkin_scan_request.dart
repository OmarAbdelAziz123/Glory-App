import 'package:json_annotation/json_annotation.dart';

part 'session_checkin_scan_request.g.dart';

@JsonSerializable()
final class SessionCheckinScanRequest {
  const SessionCheckinScanRequest({required this.token});

  factory SessionCheckinScanRequest.fromJson(Map<String, dynamic> json) =>
      _$SessionCheckinScanRequestFromJson(json);

  final String token;

  Map<String, dynamic> toJson() => _$SessionCheckinScanRequestToJson(this);
}
