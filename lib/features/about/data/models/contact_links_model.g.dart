// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_links_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactLinksModel _$ContactLinksModelFromJson(Map<String, dynamic> json) =>
    ContactLinksModel(
      whatsapp: json['social.whatsapp'] as String?,
      facebook: json['social.facebook'] as String?,
      instagram: json['social.instagram'] as String?,
      twitter: json['social.twitter'] as String?,
      phone: json['contact.phone'] as String?,
      appStore: json['rating.appstore'] as String?,
      playStore: json['rating.playstore'] as String?,
    );

Map<String, dynamic> _$ContactLinksModelToJson(ContactLinksModel instance) =>
    <String, dynamic>{
      'social.whatsapp': instance.whatsapp,
      'social.facebook': instance.facebook,
      'social.instagram': instance.instagram,
      'social.twitter': instance.twitter,
      'contact.phone': instance.phone,
      'rating.appstore': instance.appStore,
      'rating.playstore': instance.playStore,
    };
