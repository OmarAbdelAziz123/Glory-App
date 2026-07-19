// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'غلوري جيم';

  @override
  String get ok => 'موافق';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get add => 'إضافة';

  @override
  String get update => 'تحديث';

  @override
  String get submit => 'إرسال';

  @override
  String get confirm => 'تأكيد';

  @override
  String get close => 'إغلاق';

  @override
  String get back => 'رجوع';

  @override
  String get next => 'التالي';

  @override
  String get done => 'تم';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get search => 'بحث';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get noInternet => 'لا يوجد اتصال بالإنترنت';

  @override
  String get errorGeneral => 'حدث خطأ ما';

  @override
  String get errorServer => 'خطأ في الخادم، يرجى المحاولة مرة أخرى';

  @override
  String get errorUnauthorized => 'انتهت الجلسة، يرجى تسجيل الدخول مجدداً';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get phone => 'رقم الهاتف';

  @override
  String get welcomeBack => 'مرحباً بعودتك!';

  @override
  String get loginSubtitle => 'سجّل دخولك للمتابعة';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ سجّل دخولك';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ أنشئ حساباً';

  @override
  String get home => 'الرئيسية';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get totalMembers => 'إجمالي الأعضاء';

  @override
  String get activeSubscriptions => 'الاشتراكات النشطة';

  @override
  String get todayAttendance => 'حضور اليوم';

  @override
  String get expiringSubscriptions => 'تنتهي قريباً';

  @override
  String get recentActivity => 'النشاط الأخير';

  @override
  String get members => 'الأعضاء';

  @override
  String get addMember => 'إضافة عضو';

  @override
  String get editMember => 'تعديل بيانات العضو';

  @override
  String get deleteMember => 'حذف العضو';

  @override
  String get memberName => 'اسم العضو';

  @override
  String get memberDetails => 'تفاصيل العضو';

  @override
  String get noMembers => 'لا يوجد أعضاء';

  @override
  String get memberAdded => 'تمت إضافة العضو بنجاح';

  @override
  String get memberUpdated => 'تم تحديث بيانات العضو بنجاح';

  @override
  String get memberDeleted => 'تم حذف العضو بنجاح';

  @override
  String get deleteConfirmMember => 'هل أنت متأكد من حذف هذا العضو؟';

  @override
  String get subscriptions => 'الاشتراكات';

  @override
  String get addSubscription => 'إضافة اشتراك';

  @override
  String get subscriptionPlan => 'خطة الاشتراك';

  @override
  String get startDate => 'تاريخ البداية';

  @override
  String get endDate => 'تاريخ الانتهاء';

  @override
  String get active => 'نشط';

  @override
  String get expired => 'منتهي';

  @override
  String get expiringSoon => 'ينتهي قريباً';

  @override
  String daysLeft(int count) {
    return 'متبقي $count يوم';
  }

  @override
  String get subscriptionAdded => 'تمت إضافة الاشتراك بنجاح';

  @override
  String get renewSubscription => 'تجديد الاشتراك';

  @override
  String get attendance => 'الحضور';

  @override
  String get checkIn => 'تسجيل حضور';

  @override
  String get checkOut => 'تسجيل انصراف';

  @override
  String get checkedIn => 'تم تسجيل الحضور';

  @override
  String get checkedOut => 'تم تسجيل الانصراف';

  @override
  String get attendanceHistory => 'سجل الحضور';

  @override
  String get noAttendance => 'لا توجد سجلات حضور';

  @override
  String attendanceAt(String time) {
    return 'الساعة $time';
  }

  @override
  String get workouts => 'التمارين';

  @override
  String get addWorkout => 'إضافة تمرين';

  @override
  String get workoutName => 'اسم التمرين';

  @override
  String get duration => 'المدة';

  @override
  String minutes(int count) {
    return '$count دقيقة';
  }

  @override
  String get noWorkouts => 'لا توجد تمارين';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get aboutApp => 'عن التطبيق';

  @override
  String version(String version) {
    return 'الإصدار $version';
  }

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get invalidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get passwordTooShort => 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';

  @override
  String get passwordsNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get invalidPhone => 'يرجى إدخال رقم هاتف صحيح';
}
