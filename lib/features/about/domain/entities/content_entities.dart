final class InfoPageEntity {
  const InfoPageEntity({
    required this.id,
    required this.key,
    required this.titleEn,
    required this.titleAr,
    required this.contentEn,
    required this.contentAr,
    this.imageUrl,
    required this.updatedAt,
  });

  final String id;
  final String key;
  final String titleEn;
  final String titleAr;
  final String contentEn;
  final String contentAr;
  final String? imageUrl;
  final DateTime updatedAt;

  String titleFor({required bool isArabic}) =>
      isArabic ? titleAr : titleEn;

  String contentFor({required bool isArabic}) =>
      isArabic ? contentAr : contentEn;
}

final class FaqEntity {
  const FaqEntity({
    required this.id,
    required this.questionEn,
    required this.questionAr,
    required this.answerEn,
    required this.answerAr,
    required this.sortOrder,
  });

  final String id;
  final String questionEn;
  final String questionAr;
  final String answerEn;
  final String answerAr;
  final int sortOrder;

  String questionFor({required bool isArabic}) =>
      isArabic ? questionAr : questionEn;

  String answerFor({required bool isArabic}) =>
      isArabic ? answerAr : answerEn;
}

final class ContactLinksEntity {
  const ContactLinksEntity({
    this.whatsapp,
    this.facebook,
    this.instagram,
    this.twitter,
    this.phone,
    this.appStore,
    this.playStore,
  });

  final String? whatsapp;
  final String? facebook;
  final String? instagram;
  final String? twitter;
  final String? phone;
  final String? appStore;
  final String? playStore;
}
