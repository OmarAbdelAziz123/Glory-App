import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/content_entities.dart';

part 'contact_channel_model.g.dart';

@JsonSerializable()
final class ContactChannelModel {
  const ContactChannelModel({
    required this.id,
    required this.icon,
    required this.labelEn,
    required this.labelAr,
    required this.value,
  });

  factory ContactChannelModel.fromJson(Map<String, dynamic> json) =>
      _$ContactChannelModelFromJson(json);

  final String id;
  final String icon;
  final String labelEn;
  final String labelAr;
  final String value;
}

extension ContactChannelModelMapper on ContactChannelModel {
  ContactChannelEntity toEntity() => ContactChannelEntity(
        id: id,
        icon: icon,
        labelEn: labelEn,
        labelAr: labelAr,
        value: value,
      );
}
