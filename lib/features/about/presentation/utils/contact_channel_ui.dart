import '../../domain/entities/content_entities.dart';

abstract final class ContactChannelUi {
  static String iconAsset(String icon) {
    return switch (icon.toUpperCase()) {
      'WHATSAPP' => 'whatsapp_icon.svg',
      'INSTAGRAM' => 'instgram_icon.svg',
      'FACEBOOK' => 'facebook_icon.svg',
      'X' || 'TWITTER' => 'twitter_icon.svg',
      'PHONE' => 'phone_icon.svg',
      'EMAIL' => 'contact_us_icon.svg',
      'APP_STORE' => 'apple_icon.svg',
      'GOOGLE_PLAY' => 'google_icon.svg',
      _ => 'contact_us_icon.svg',
    };
  }

  static String launchTarget(ContactChannelEntity channel) {
    final value = channel.value.trim();
    return switch (channel.icon.toUpperCase()) {
      'PHONE' => value.startsWith('tel:') ? value : 'tel:$value',
      'EMAIL' => value.startsWith('mailto:') ? value : 'mailto:$value',
      _ => value,
    };
  }
}
