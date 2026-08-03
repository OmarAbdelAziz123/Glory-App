import 'package:json_annotation/json_annotation.dart';

part 'contact_links_model.g.dart';

@JsonSerializable()
final class ContactLinksModel {
  const ContactLinksModel({
    @JsonKey(name: 'social.whatsapp') this.whatsapp,
    @JsonKey(name: 'social.facebook') this.facebook,
    @JsonKey(name: 'social.instagram') this.instagram,
    @JsonKey(name: 'social.twitter') this.twitter,
    @JsonKey(name: 'contact.phone') this.phone,
    @JsonKey(name: 'rating.appstore') this.appStore,
    @JsonKey(name: 'rating.playstore') this.playStore,
  });

  factory ContactLinksModel.fromJson(Map<String, dynamic> json) =>
      _$ContactLinksModelFromJson(json);

  final String? whatsapp;
  final String? facebook;
  final String? instagram;
  final String? twitter;
  final String? phone;
  final String? appStore;
  final String? playStore;
}
