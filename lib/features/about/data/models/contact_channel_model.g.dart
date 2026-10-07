// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactChannelModel _$ContactChannelModelFromJson(Map<String, dynamic> json) =>
    ContactChannelModel(
      id: json['id'] as String,
      icon: json['icon'] as String,
      labelEn: json['labelEn'] as String,
      labelAr: json['labelAr'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$ContactChannelModelToJson(ContactChannelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'icon': instance.icon,
      'labelEn': instance.labelEn,
      'labelAr': instance.labelAr,
      'value': instance.value,
    };
