/// Holds the active language code for layers without [BuildContext].
abstract final class LocaleHolder {
  static String languageCode = 'ar';
}

/// Localized fallback strings for data/services layers.
abstract final class FallbackMessages {
  static bool get _isEnglish => LocaleHolder.languageCode == 'en';

  static String get errorTryAgain => _isEnglish
      ? 'An error occurred, please try again'
      : 'حدث خطأ، حاول مرة أخرى';

  static String get errorGeneral =>
      _isEnglish ? 'Something went wrong' : 'حدث خطأ ما';

  static String get errorServer => _isEnglish
      ? 'Server error, please try again'
      : 'خطأ في الخادم، يرجى المحاولة مرة أخرى';

  static String get errorUnauthorized => _isEnglish
      ? 'Session expired, please login again'
      : 'انتهت الجلسة، يرجى تسجيل الدخول مجدداً';

  static String get requestCancelled =>
      _isEnglish ? 'Request cancelled' : 'تم إلغاء الطلب';

  static String get clientError =>
      _isEnglish ? 'Client error' : 'خطأ في الطلب';

  static String get validationFailed =>
      _isEnglish ? 'Validation failed' : 'فشل التحقق';

  static String get cacheError =>
      _isEnglish ? 'Cache error occurred' : 'حدث خطأ في التخزين المؤقت';

  static String get noInternet =>
      _isEnglish ? 'No internet connection' : 'لا يوجد اتصال بالإنترنت';

  static String get appName =>
      _isEnglish ? 'Glory Gym' : 'غلوري جيم';

  static String get notificationsChannelDescription => _isEnglish
      ? 'Glory Gym notifications'
      : 'إشعارات جلوري جيم';

  static String get invalidQrCode =>
      _isEnglish ? 'Invalid QR code' : 'رمز QR غير صالح';

  static String get fileTooLarge => _isEnglish
      ? 'File is too large. Maximum size is 15 MB.'
      : 'حجم الملف كبير جداً. الحد الأقصى 15 ميجابايت.';

  static String get unsupportedFileType => _isEnglish
      ? 'Unsupported file. Please upload a PDF or an image.'
      : 'نوع الملف غير مدعوم. ارفع ملف PDF أو صورة.';

  static String get sandyUploadedFile =>
      _isEnglish ? 'Uploaded a medical file' : 'تم رفع ملف طبي';
}
