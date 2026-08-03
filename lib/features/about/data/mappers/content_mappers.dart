import '../../domain/entities/content_entities.dart';
import '../models/contact_links_model.dart';
import '../models/faq_model.dart';
import '../models/info_page_model.dart';

extension InfoPageModelMapper on InfoPageModel {
  InfoPageEntity toEntity() => InfoPageEntity(
        id: id,
        key: key,
        titleEn: titleEn,
        titleAr: titleAr,
        contentEn: contentEn,
        contentAr: contentAr,
        imageUrl: imageUrl,
        updatedAt: DateTime.parse(updatedAt),
      );
}

extension FaqModelMapper on FaqModel {
  FaqEntity toEntity() => FaqEntity(
        id: id,
        questionEn: questionEn,
        questionAr: questionAr,
        answerEn: answerEn,
        answerAr: answerAr,
        sortOrder: sortOrder,
      );
}

extension ContactLinksModelMapper on ContactLinksModel {
  ContactLinksEntity toEntity() => ContactLinksEntity(
        whatsapp: whatsapp,
        facebook: facebook,
        instagram: instagram,
        twitter: twitter,
        phone: phone,
        appStore: appStore,
        playStore: playStore,
      );
}
