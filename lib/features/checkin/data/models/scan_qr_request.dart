import 'package:json_annotation/json_annotation.dart';

part 'scan_qr_request.g.dart';

@JsonSerializable()
final class ScanQrRequest {
  const ScanQrRequest({required this.token});

  factory ScanQrRequest.fromJson(Map<String, dynamic> json) =>
      _$ScanQrRequestFromJson(json);

  final String token;

  Map<String, dynamic> toJson() => _$ScanQrRequestToJson(this);
}
