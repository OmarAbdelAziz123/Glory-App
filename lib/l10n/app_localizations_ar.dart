// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get aboutApp => 'عن التطبيق';

  @override
  String get aboutGloryGymInfo => 'من نحن';

  @override
  String get aboutUs => 'من نحن';

  @override
  String get active => 'نشط';

  @override
  String get activeSubscriptions => 'الاشتراكات النشطة';

  @override
  String get activityModerate => 'حركة متوسطة';

  @override
  String get add => 'إضافة';

  @override
  String get addFamilyMember => 'اضافة فرد للعائلة';

  @override
  String get addMember => 'إضافة عضو';

  @override
  String get addNewMember => 'إضافة عضو جديد';

  @override
  String get addNewMemberAlt => 'أضافة عضو جديد';

  @override
  String get addStrongPasswordHint =>
      'يرجي إضافة كلمة مرور قوية للحفاظ علي بياناتك';

  @override
  String get addSubscription => 'إضافة اشتراك';

  @override
  String get addWeight => 'اضافة وزن';

  @override
  String get addWorkout => 'إضافة تمرين';

  @override
  String get addWorkoutWeight => 'اضافة وزن ( للتمرين )';

  @override
  String get afternoon => 'ظهراً';

  @override
  String get age => 'العمر';

  @override
  String get agreeToPrefix => 'أوافق على ';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ سجّل دخولك';

  @override
  String get alreadyHaveAccountPrefix => 'لدي حساب بالفعل ؟ ';

  @override
  String get appName => 'غلوري جيم';

  @override
  String get appReviews => 'تقييمات التطبيق';

  @override
  String get appointment => 'موعد';

  @override
  String get appointments => 'المواعيد';

  @override
  String get arabic => 'العربية';

  @override
  String get armCircumference => 'محيط الذراع';

  @override
  String get askSandyHint => 'اسأل ساندي عن التمارين، التغذية، أو اشتراكك';

  @override
  String get attendance => 'الحضور';

  @override
  String attendanceAt(String time) {
    return 'الساعة $time';
  }

  @override
  String get attendanceHistory => 'سجل الحضور';

  @override
  String get average => 'متوسط';

  @override
  String get back => 'رجوع';

  @override
  String get basalMetabolicRate => 'معدل الايض الاساسي';

  @override
  String get biologicalAge => 'العمر البيضي';

  @override
  String get bmi => 'مؤشر كتلة الجسم';

  @override
  String get bodyCompositionScan => 'فحص تكوين الجسم';

  @override
  String get bodyFatPercentage => 'نسبة الدهون في الجسم';

  @override
  String get bodyFatPercentageIfAny => 'نسبة الدهون (إن وجدت)';

  @override
  String get bookings => 'الحجوزات';

  @override
  String get cancel => 'إلغاء';

  @override
  String get cameraPermissionRequired => 'يلزم السماح بالكاميرا لمسح QR';

  @override
  String get cameraPermissionRationale =>
      'نحتاج الوصول للكاميرا لمسح رمز QR وتسجيل حضورك للحصة الفردية.';

  @override
  String get cameraPermissionDeniedMessage =>
      'لم يتم منح صلاحية الكاميرا. يمكنك المحاولة مرة أخرى أو تفعيلها من الإعدادات.';

  @override
  String get cameraPermissionSettingsMessage =>
      'افتح الإعدادات وفعّل صلاحية الكاميرا للمتابعة.';

  @override
  String get allowCameraAccess => 'السماح بالكاميرا';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get scanQrCode => 'مسح QR كود';

  @override
  String get pointCameraAtQr => 'وجّه الكاميرا نحو رمز QR';

  @override
  String get qrScanSuccess => 'تم مسح الرمز بنجاح';

  @override
  String get invalidQrCode => 'رمز QR غير صالح';

  @override
  String get cancelClass => 'الغاء الحصة';

  @override
  String get cannotAccessEmailNow =>
      'لا تستطيع الوصول إلى بريدك الإلكتروني الآن؟';

  @override
  String get cardio => 'كارديو';

  @override
  String get changeEmail => 'تغير البريد الالكتروني';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get checkIn => 'تسجيل حضور';

  @override
  String get checkOut => 'تسجيل انصراف';

  @override
  String get checkedIn => 'تم تسجيل الحضور';

  @override
  String get checkedOut => 'تم تسجيل الانصراف';

  @override
  String checkinClassWelcomePrefix(String packageName) {
    return 'أهلاً بك في عائلة جلوري جيم! لقد تم تسجيل دخول لحصة ($packageName) ';
  }

  @override
  String checkinClassWelcomeSuffix(
    String instructorName,
    String remainingSessions,
  ) {
    return 'مع الكوتش ($instructorName) متبقي معك $remainingSessions حصص';
  }

  @override
  String get chestCircumference => 'محيط الصدر';

  @override
  String get chooseAction => 'اختر إجراء';

  @override
  String get chooseCountry => 'اختر الدولة';

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get classCancelledSuccess => 'تم الغاء الحصة بنجاح';

  @override
  String get classCheckInSuccess => 'لقد تم دخولك للحصة بنجاح!';

  @override
  String get classEvaluatedSuccess => 'لقد تم تقييم الحصة بنجاح!';

  @override
  String get classEvaluation => 'تقييم الحصة';

  @override
  String get close => 'إغلاق';

  @override
  String codeExpiresInSeconds(String secondsLabel) {
    return 'ستنتهي صلاحية الكود خلال ( $secondsLabel ثانية )';
  }

  @override
  String codeExpiresInTimer(String timerText) {
    return 'ستنتهي صلاحية الكود خلال ( $timerText ثانية ) ';
  }

  @override
  String get complaintOrSuggestion => 'الشكوى أو الاقتراح';

  @override
  String get complaintReviewMessage =>
      'سنقوم بمراجعة شكواك أو اقتراحك والرد عليك في أقرب وقت.';

  @override
  String get complaintsAndSuggestions => 'شكاوي و اقتراحات';

  @override
  String get completedWorkout => 'تمرين مكتمل';

  @override
  String get confirm => 'تأكيد';

  @override
  String get confirmCancelClass => 'هل أنت متأكد أنك تريد الغاء هذه الحصة؟';

  @override
  String get confirmLogout => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordAlt => 'تاكيد كلمة المرور';

  @override
  String get contactUs => 'تواصل معنا';

  @override
  String get contentUnavailable => 'محتوى غير متاح حالياً';

  @override
  String get couldNotOpenEvaluationLink => 'تعذر فتح رابط التقييم';

  @override
  String get couldNotOpenLink => 'تعذر فتح الرابط';

  @override
  String get countryAlgeria => 'الجزائر';

  @override
  String get countryBahrain => 'البحرين';

  @override
  String get countryComoros => 'جزر القمر';

  @override
  String get countryDjibouti => 'جيبوتي';

  @override
  String get countryEgypt => 'مصر';

  @override
  String get countryIraq => 'العراق';

  @override
  String get countryJordan => 'الأردن';

  @override
  String get countryKuwait => 'الكويت';

  @override
  String get countryLebanon => 'لبنان';

  @override
  String get countryLibya => 'ليبيا';

  @override
  String get countryMauritania => 'موريتانيا';

  @override
  String get countryMorocco => 'المغرب';

  @override
  String get countryOman => 'عُمان';

  @override
  String get countryPalestine => 'فلسطين';

  @override
  String get countryQatar => 'قطر';

  @override
  String get countrySaudiArabia => 'المملكة العربية السعودية';

  @override
  String get countrySomalia => 'الصومال';

  @override
  String get countrySudan => 'السودان';

  @override
  String get countrySyria => 'سوريا';

  @override
  String get countryTunisia => 'تونس';

  @override
  String get countryUAE => 'الإمارات العربية المتحدة';

  @override
  String get countryYemen => 'اليمن';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get createNewPassword => 'انشاء كلمة مرور جديدة';

  @override
  String get createPassword => 'انشاء كلمة مرور';

  @override
  String get currentActivityLevelSubtitle => 'مستوى نشاطك في الوقت الراهن.';

  @override
  String get currentPhysicalActivity => 'النشاط البدني الحالي';

  @override
  String get currentlyExercisingQuestion => 'هل تمارس الرياضة حالياً؟';

  @override
  String get dailyMealsCount => 'عدد الوجبات اليومية';

  @override
  String get dailyNutritionHabitsSubtitle => 'عاداتك الغذائية اليومية.';

  @override
  String get dailyWaterIntake => 'كمية الماء اليومية';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get dataSavedSuccess => 'تم حفظ بياناتك بنجاح';

  @override
  String get date => 'التاريخ';

  @override
  String get dateAdded => 'تاريخ الاضافة';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get day => 'يوم';

  @override
  String daysCountLabel(String days) {
    return '$days يوم';
  }

  @override
  String daysLeft(int count) {
    return 'متبقي $count يوم';
  }

  @override
  String get daysYouCanCommitWeekly =>
      'عدد الأيام التي تستطيع الالتزام بها أسبوعياً';

  @override
  String get delete => 'حذف';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteConfirmMember => 'هل أنت متأكد من حذف هذا العضو؟';

  @override
  String get deleteMember => 'حذف العضو';

  @override
  String get deleteMemberAlt => 'حذف عضو';

  @override
  String deleteMemberConfirm(String fullName) {
    return 'هل أنت متأكد أنك تريد حذف \"$fullName\"؟';
  }

  @override
  String get deskJob => 'مكتبي';

  @override
  String get details => 'التفاصيل';

  @override
  String get done => 'تم';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ أنشئ حساباً';

  @override
  String get dontHaveAccountPrefix => 'ليس لديك حساب ؟';

  @override
  String get duration => 'المدة';

  @override
  String get edit => 'تعديل';

  @override
  String get editFamilyMember => 'تعديل فرد العائلة';

  @override
  String get editMember => 'تعديل بيانات العضو';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailOrPhone => 'البريد الإلكتروني او رقم الهاتف';

  @override
  String get endDate => 'تاريخ الانتهاء';

  @override
  String get english => 'الإنجليزية';

  @override
  String get enterArmCircumference => 'قم بإدخال محيط الذراع';

  @override
  String get enterBodyFatPercentage => 'قم بإدخال نسبة الدهون';

  @override
  String get enterChestCircumference => 'قم بإدخال محيط الصدر';

  @override
  String get enterConfirmPasswordHere =>
      'قم بإدخال تاكيد كلمة المرور الخاصة بك هنا';

  @override
  String get enterDateOfBirth => 'قم بإدخال تاريخ الميلاد';

  @override
  String get enterEmailOrPhone => 'قم بإدخال او رقم الهاتف الخاصة بك';

  @override
  String get enterFullName => 'قم بإدخال الاسم الكامل';

  @override
  String get enterNewPasswordHere =>
      'قم بإدخال كلمة المرور الجديدة الخاصة بك هنا';

  @override
  String get enterNumberOfDays => 'قم بإدخال عدد الأيام';

  @override
  String get enterNumberOfHours => 'قم بإدخال عدد الساعات';

  @override
  String get enterNumberOfMeals => 'قم بإدخال عدد الوجبات';

  @override
  String get enterOccupation => 'قم بإدخال المهنة';

  @override
  String get enterPasswordHere => 'قم بإدخال كلمة المرور الخاصة بك هنا';

  @override
  String get enterSuggestedWeightForWorkout =>
      'قم بإدخال الوزن المقترح الخاص بك لهذه التمرين';

  @override
  String get enterThighCircumference => 'قم بإدخال محيط الفخذ';

  @override
  String get enterWaistCircumference => 'قم بإدخال محيط الخصر';

  @override
  String get enterWaterAmount => 'قم بإدخال كمية الماء';

  @override
  String get enterYourAge => 'قم بإدخال العمر الخاص بك';

  @override
  String get enterYourEmail => 'قم بإدخال بريدك الإلكتروني الخاصة بك';

  @override
  String get enterYourEmailOrPhone =>
      'قم بإدخال بريدك الإلكتروني او رقم الهاتف الخاصة بك';

  @override
  String get enterYourPassword => 'قم بإدخال كلمة المرور الخاصة بك';

  @override
  String get enterYourPhone => 'قم بإدخال رقم الهاتف الخاصة بك';

  @override
  String get enterYourUsername => 'قم بإدخال اسم المستخدم الخاصة بك';

  @override
  String get equipmentMachines => 'أجهزة';

  @override
  String get errorGeneral => 'حدث خطأ ما';

  @override
  String get errorServer => 'خطأ في الخادم، يرجى المحاولة مرة أخرى';

  @override
  String get errorTryAgain => 'حدث خطأ، حاول مرة أخرى';

  @override
  String get errorUnauthorized => 'انتهت الجلسة، يرجى تسجيل الدخول مجدداً';

  @override
  String get evaluateClass => 'تقييم للحصة';

  @override
  String get classSatisfactionQuestion => 'ما مدى رضاك عن الحصة ؟';

  @override
  String get evaluationLinkUnavailable => 'رابط التقييم غير متاح حالياً';

  @override
  String get evening => 'مساءً';

  @override
  String get exampleOneYearThreeMonths => 'مثال: سنة وثلاثة أشهر';

  @override
  String get exampleWeightsCardioSwimming => 'مثال: أوزان، كارديو، سباحة';

  @override
  String get expired => 'منتهي';

  @override
  String get expiringSoon => 'ينتهي قريباً';

  @override
  String get expiringSubscriptions => 'تنتهي قريباً';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get familyAddMembersHint =>
      'ابدأ بإضافة أفراد عائلتك للمتابعة من التطبيق';

  @override
  String get familyMembers => 'أفراد العائلة';

  @override
  String get faq => 'الأسئلة الشائعة';

  @override
  String get favoriteWorkouts => 'التمارين المفضلة';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get flexibility => 'مرونة';

  @override
  String get followDietQuestion => 'هل تتبع نظاماً غذائياً؟';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get forgotPasswordEmailHint =>
      'الرجاء إدخال بريدك الإلكتروني وسنرسل رمز التأكيد إلى بريدك الإلكتروني';

  @override
  String get forgotPasswordEmailOrPhoneHint =>
      'الرجاء إدخال بريدك الإلكتروني او رقم هاتفك لإرسال رمز التأكيد إليه';

  @override
  String get freeWeights => 'أوزان حرة';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get gender => 'الجنس';

  @override
  String get genderBoth => 'الاثنان';

  @override
  String get genderFemale => 'أنثى';

  @override
  String get genderMale => 'ذكر';

  @override
  String get generalWorkoutInstructions => 'تعليمات التمرين العامة';

  @override
  String get generateNewQrCode => 'توليد QR كود اخر';

  @override
  String get getToKnowGloryGym => 'تعرف علي جلوري جيم';

  @override
  String get goalBodyToning => 'شد الجسم';

  @override
  String get goalFatLoss => 'خسارة دهون';

  @override
  String get goalImproveFitness => 'تحسين اللياقة';

  @override
  String get goalIncreaseStrength => 'زيادة القوة';

  @override
  String get goalInjuryRehab => 'إعادة تأهيل بعد إصابة';

  @override
  String get goalMuscleGain => 'زيادة كتلة عضلية';

  @override
  String get goodEvening => 'مساء الخير';

  @override
  String get goodMorning => 'صباح الخير';

  @override
  String get groupClass => 'حصة جماعية';

  @override
  String get groupClasses => 'الحصص الجماعية';

  @override
  String get individualSessions => 'الحصص الفردية';

  @override
  String get gym => 'جيم';

  @override
  String get gymCheckIn => 'تسجيل للجيم';

  @override
  String get gymCheckInSuccess => 'لقد تم دخول الجيم بنجاح!';

  @override
  String get hadSurgeryQuestion => 'هل أجريت أي عملية جراحية؟';

  @override
  String get haveChronicDiseaseQuestion =>
      'هل لديك أي مرض مزمن؟ (سكري، ضغط، قلب…)';

  @override
  String get haveInjuriesQuestion => 'هل لديك أي إصابات حالية أو سابقة؟';

  @override
  String get healthHistory => 'التاريخ الصحي';

  @override
  String get healthStatus => 'الحالة الصحية';

  @override
  String get healthyNutritionTips => 'نصائح للتغذية الصحية';

  @override
  String get high => 'مرتفع';

  @override
  String get home => 'الرئيسية';

  @override
  String get hour => 'ساعة';

  @override
  String get howLongHaveYouBeenTraining => 'منذ متى تتمرن؟';

  @override
  String get inactive => 'غير مفعل';

  @override
  String get instagram => 'انستجرام';

  @override
  String get instructorName => 'اسم المدرب';

  @override
  String get invalidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get invalidPhone => 'يرجى إدخال رقم هاتف صحيح';

  @override
  String get invalidVerificationCode => 'رمز التحقق غير صالح، حاول مرة أخرى';

  @override
  String get issuedBy => 'اصدرت بواسطة';

  @override
  String get issuedByAhmedHossam => 'اصدار بواسطة: احمد حسام';

  @override
  String get keepPasswordSafeHint =>
      'حاول الاحتفاظ بكلمة المرور بعيدا لتفادي سرقة حسابك و بياناتك';

  @override
  String get language => 'اللغة';

  @override
  String get lifestyle => 'نمط الحياة';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get liter => 'لتر';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get loginEmailOrPhoneHint =>
      'الرجاء إدخال بريدك الإلكتروني او رقم هاتفك ومع كلمة المرور للوصول إلى حسابك.';

  @override
  String get loginSubtitle => 'سجّل دخولك للمتابعة';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get low => 'منخفض';

  @override
  String get maritalDivorced => 'مطلق';

  @override
  String get maritalMarried => 'متزوج';

  @override
  String get maritalSingle => 'أعزب';

  @override
  String get maritalStatus => 'الحالة الاجتماعية';

  @override
  String get maritalWidowed => 'أرمل';

  @override
  String maxCharsValidation(String max) {
    return 'يجب ألا يزيد عن $max حرفاً';
  }

  @override
  String get meal => 'وجبة';

  @override
  String get measurements => 'القياسات';

  @override
  String get measurementsCmOptionalPhotos =>
      'القياسات الحالية بوحدة السنتيمتر. الصور اختيارية.';

  @override
  String get memberAdded => 'تمت إضافة العضو بنجاح';

  @override
  String get memberDeleted => 'تم حذف العضو بنجاح';

  @override
  String get memberDetails => 'تفاصيل العضو';

  @override
  String get memberName => 'اسم العضو';

  @override
  String get memberUpdated => 'تم تحديث بيانات العضو بنجاح';

  @override
  String get members => 'الأعضاء';

  @override
  String get mentionDurationAndPreviousProgram => 'اذكر المدة والبرنامج السابق';

  @override
  String get mentionInjuryLocationAndDate => 'اذكر موضع الإصابة وتاريخها';

  @override
  String minCharsValidation(String min) {
    return 'يجب ألا يقل عن $min أحرف';
  }

  @override
  String minutes(int count) {
    return '$count دقيقة';
  }

  @override
  String get mobileNumber => 'رقم الجوال';

  @override
  String get morning => 'صباحاً';

  @override
  String get multiSelect => 'اختيار متعدد';

  @override
  String get multipleGoalsAllowed => 'يمكن اختيار أكثر من هدف واحد.';

  @override
  String get muscleMass => 'التكتله العضليه';

  @override
  String get mustContainDigit => 'يجب أن تحتوي على رقم واحد على الأقل';

  @override
  String get mustContainLetter => 'يجب أن تحتوي على حرف كبير أو صغير';

  @override
  String get mySubscriptions => 'اشتراكاتي';

  @override
  String get myWorkouts => 'تماريني';

  @override
  String get name => 'الاسم';

  @override
  String get natureOfWork => 'طبيعة العمل';

  @override
  String get needHelpWithWorkoutsNutritionSubscription =>
      'هل تريد مساعدة في التمارين، التغذية، أو الاشتراك؟';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get newPasswordCreatedSuccess => 'تم إنشاء كلمة مرور جديدة بنجاح!';

  @override
  String get next => 'التالي';

  @override
  String get night => 'ليلاً';

  @override
  String get no => 'لا';

  @override
  String get noAttendance => 'لا توجد سجلات حضور';

  @override
  String get noBookingsCurrently => 'لا توجد حجوزات حالياً';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get noDiseases => 'لا توجد أمراض';

  @override
  String get noFamilyMembers => 'لا يوجد أفراد عائلة';

  @override
  String get noInternet => 'لا يوجد اتصال بالإنترنت';

  @override
  String get noMembers => 'لا يوجد أعضاء';

  @override
  String get noNotifications => 'لا توجد اشعارات';

  @override
  String get noWorkouts => 'لا توجد تمارين';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get notificationsAlt => 'الاشعارات';

  @override
  String get nutrition => 'التغذية';

  @override
  String get nutritionEating => 'أكل';

  @override
  String get nutritionShort => 'تغذ';

  @override
  String get nutritionShortAlt => 'غذ';

  @override
  String get nutritionWaterTip =>
      'اشرب 2–3 لتر ماء يومياً، وقلّل السكريات المكررة. ';

  @override
  String get occupation => 'المهنة';

  @override
  String get ok => 'موافق';

  @override
  String get okAlt => 'حسناً';

  @override
  String get onboardingCoachReviewMessage =>
      'شكراً لك. سيقوم المدرب بمراجعة بياناتك وإعداد خطة التدريب والتغذية المناسبة لك.';

  @override
  String get onboardingTeamReviewMessage =>
      'شكراً لك. سيقوم فريق جلوري جيم بمراجعة بياناتك وإعداد أفضل تجربة لك.';

  @override
  String get otherGoal => 'هدف آخر';

  @override
  String get otpSentToEmail =>
      'تم إرسال رمز مكون من 6 أرقام على بريدك الإلكتروني ';

  @override
  String get ourGoals => 'أهدافنا';

  @override
  String get ourValues => 'قيمنا';

  @override
  String get ourVision => 'رؤيتنا';

  @override
  String get package => 'باق';

  @override
  String get packageName => 'اسم الباقة';

  @override
  String get packageType => 'نوع الباقة';

  @override
  String get parqQuestionnaireIntro =>
      'استبيان الجاهزية البدنية (PAR-Q). يُرجى الإجابة بدقة.';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHasDigit => 'تحتوي على رقم واحد على الأقل';

  @override
  String get passwordHasLetter => 'تحتوي على حرف كبير أو صغير';

  @override
  String get passwordMinEightChars =>
      'كلمة المرور يجب أن تكون 8 أحرف على الأقل';

  @override
  String get passwordMinEightCharsHint => '8 حروف علي الاقل';

  @override
  String get passwordTooShort => 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';

  @override
  String get passwordsMatch => 'كلمتي المرور متطابقتين';

  @override
  String get passwordsNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get performanceProteinTip =>
      'لتحسين أدائك: ركّز على البروtein بعد التمرين، ';

  @override
  String get personalData => 'البيانات الشخصية';

  @override
  String get personalTraining => 'تدريب شخصي';

  @override
  String get phaseFour => 'المرحلة الرابعة';

  @override
  String phaseNumberLabel(String stepNumber) {
    return 'المرحلة $stepNumber';
  }

  @override
  String get phaseOne => 'المرحلة الاولى';

  @override
  String get phaseThree => 'المرحلة الثالثة';

  @override
  String get phaseTwo => 'المرحلة الثانية';

  @override
  String get phone => 'رقم الهاتف';

  @override
  String get phoneRequired => 'رقم الهاتف *';

  @override
  String get physicalEffort => 'مجهود بدني';

  @override
  String get pleaseConfirmPassword => 'يرجى تأكيد كلمة المرور';

  @override
  String get pleaseEnterEmailOrPhone =>
      'يرجى إدخال البريد الإلكتروني أو رقم الهاتف';

  @override
  String get pleaseEnterPassword => 'يرجى إدخال كلمة المرور';

  @override
  String get preferGymOrHomeWorkouts => 'هل تفضل تمارين في الجيم أم في المنزل؟';

  @override
  String get preferredWorkoutTime => 'الوقت المفضل للتمرين';

  @override
  String get previous => 'السابق';

  @override
  String get previousWeight => 'الوزن السابق';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get program => 'برنامج';

  @override
  String get questionnaireSent => 'تم إرسال الاستبيان';

  @override
  String questionnaireStepProgress(String currentStep, String totalSteps) {
    return 'الخطوة $currentStep من $totalSteps';
  }

  @override
  String get quickLoginWith => 'تسجيل الدخول سريع مع';

  @override
  String get recentActivity => 'النشاط الأخير';

  @override
  String get recentBookings => 'اخر الحجوزات';

  @override
  String get recoveryFactorsSubtitle =>
      'العوامل المؤثرة على الاستشفاء والنتائج.';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get relationBrother => 'أخ';

  @override
  String get relationDaughter => 'ابنة';

  @override
  String get relationFather => 'أب';

  @override
  String get relationHusband => 'زوج';

  @override
  String get relationMother => 'أم';

  @override
  String get relationSister => 'أخت';

  @override
  String get relationSon => 'ابن';

  @override
  String get relationWife => 'زوجة';

  @override
  String get relationship => 'العلاقة';

  @override
  String get remainingDaysCount => 'عدد الايام المتبقية';

  @override
  String routeNotFound(String path) {
    return 'المسار غير موجود: $path';
  }

  @override
  String get splashTagline => 'تمرّن  ·  تطوّر  ·  تسيطر';

  @override
  String get renewSubscription => 'تجديد الاشتراك';

  @override
  String get requestOtp => 'طلب OTP';

  @override
  String get resend => 'إعادة إرسال';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get sampleDateJune2026 => '١٠ يونيو ٢٠٢٦';

  @override
  String get sampleDateMay2026 => '١ مايو ٢٠٢٦';

  @override
  String get sandyAi => 'Sandy AI';

  @override
  String get sandyAskMeHint =>
      'اسألني عن التمارين، التغذية، أو أي استفسار يخص اشتراكك.';

  @override
  String get sandyPackagesCompareHint =>
      'إذا احتجت مقارنة بين الباقات أو تجديد الاشتراك، أخبرني.';

  @override
  String get sandyPlanOfferMessage => 'أقدر أجهز لك خطة بسيطة حسب هدفك.';

  @override
  String get sandyThanksForQuestion =>
      'شكراً لسؤالك! سأراجع طلبك وأرد عليك بأفضل توصية مناسبة لك. ';

  @override
  String get sandyThreeDayProgramAdvice =>
      'رائع! أنصحك ببرنامج 3 أيام في الأسبوع: ';

  @override
  String get sandyThreeDaySplitExample =>
      'يوم للصدر والترiceps، يوم للظهر والبiceps، ويوم للأرجل. ';

  @override
  String get sandyWelcomeMessage =>
      'مرحباً! أنا ساندي، مساعدك الذكي في جلوري جيم. ';

  @override
  String get sandyChatHistory => 'سجل المحادثات';

  @override
  String get sandyNewChat => 'محادثة جديدة';

  @override
  String get sandyRenameConversation => 'إعادة تسمية المحادثة';

  @override
  String get sandyDeleteConversation => 'حذف المحادثة';

  @override
  String get sandyDeleteConversationConfirm => 'سيتم حذف هذه المحادثة نهائياً.';

  @override
  String get sandyConversationTitleHint => 'عنوان المحادثة';

  @override
  String get sandyNoConversations => 'لا توجد محادثات بعد';

  @override
  String get sandyNoConversationsDescription =>
      'ابدأ المحادثة مع ساندي وستظهر محادثاتك هنا.';

  @override
  String get save => 'حفظ';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get search => 'بحث';

  @override
  String get seeAll => 'رؤية الكل';

  @override
  String get selectRelationship => 'قم باختيار العلاقة';

  @override
  String get selectType => 'قم باختيار النوع';

  @override
  String get sendCodeToPhone => 'أرسل الرمز إلى رقم هاتفك';

  @override
  String get sent => 'تم الإرسال';

  @override
  String get sessions => 'حصص';

  @override
  String get settings => 'الإعدادات';

  @override
  String get signIn => 'تسجيل دخول';

  @override
  String get sizeMeasurements => 'قياسات الجسم';

  @override
  String get sleepHoursCount => 'عدد ساعات النوم';

  @override
  String get socialMediaPlatforms => 'منصات التواصل';

  @override
  String get startDate => 'تاريخ البداية';

  @override
  String get strength => 'قوة';

  @override
  String get stressLevel => 'مستوى التوتر';

  @override
  String get submit => 'إرسال';

  @override
  String get submitData => 'إرسال البيانات';

  @override
  String get submitQuestionnaire => 'إرسال الاستبيان';

  @override
  String get subscriberBasicInfoSubtitle =>
      'المعلومات الأساسية الخاصة بالمشترك.';

  @override
  String get subscription => 'اشتراك';

  @override
  String get subscriptionAdded => 'تمت إضافة الاشتراك بنجاح';

  @override
  String subscriptionDaysRemainingWelcome(String days) {
    return 'أهلاً بك في عائلة جلوري جيم! و نود ابلاغك بانه متبقي $days يوم من اشتراكك في الجيم';
  }

  @override
  String get subscriptionGoal => 'الهدف من الاشتراك';

  @override
  String get subscriptionInquiry => 'استفسار عن الاشتراك';

  @override
  String get subscriptionPlan => 'خطة الاشتراك';

  @override
  String get subscriptionQuestionnaire => 'استبيان الاشتراك';

  @override
  String get subscriptions => 'الاشتراكات';

  @override
  String get successfully => 'بنجاح';

  @override
  String get suggestWorkoutProgram => 'اقترح لي برنامج تمرين';

  @override
  String get suggestedWeight => 'الوزن المقترح';

  @override
  String get surgeryDetails => 'تفاصيل العملية';

  @override
  String get takeMedicationsQuestion => 'هل تتناول أي أدوية بشكل دائم؟';

  @override
  String get telephone => 'الهاتف';

  @override
  String get tempLoadingAnswer => 'إجابة تحميل مؤقتة';

  @override
  String get tempLoadingQuestion => 'سؤال تحميل مؤقت';

  @override
  String get tenKilosLabel => '10 كيلو';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get thankYou => 'شكراً';

  @override
  String get thanksForContactingUs => 'شكراً لتواصلك معنا';

  @override
  String get thighCircumference => 'محيط الفخذ';

  @override
  String get time => 'الوقت';

  @override
  String get toDetermineTrainingSchedule => 'لتحديد جدول التدريب المناسب لك.';

  @override
  String get today => 'اليوم';

  @override
  String get todayAttendance => 'حضور اليوم';

  @override
  String get totalMembers => 'إجمالي الأعضاء';

  @override
  String get trainedWithPersonalCoachQuestion =>
      'هل سبق أن تدربت مع مدرب شخصي؟';

  @override
  String get trainingCheckIn => 'تسجيل دخول التدريب';

  @override
  String get trainingEvaluation => 'تقييم التدريب';

  @override
  String get trainingInfo => 'معلومات التدريب';

  @override
  String get twitter => 'تويتر';

  @override
  String get type => 'النوع';

  @override
  String get unitCm => 'سم';

  @override
  String get upcomingWorkout => 'تمرين قادم';

  @override
  String get update => 'تحديث';

  @override
  String get useSupplementsQuestion => 'هل تستخدم مكملات غذائية؟';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get verificationCode => 'رمز التحقق';

  @override
  String get verificationCodeResent => 'تم إرسال رمز التحقق مرة أخرى';

  @override
  String version(String version) {
    return 'الإصدار $version';
  }

  @override
  String get viewPackagesInSettingsHint =>
      'يمكنك الاطلاع على باقاتك من قسم \"اشتراكاتي\" في الإعدادات. ';

  @override
  String get visceralFatLevel => 'كستواه الدهون الحشويه';

  @override
  String get waistCircumference => 'محيط الخصر';

  @override
  String get weight => 'الوزن';

  @override
  String weightKilosLabel(String weight) {
    return '$weight كيلو';
  }

  @override
  String get welcomeBack => 'مرحباً بعودتك!';

  @override
  String get welcomeBackAlt => 'اهلا بعودتك';

  @override
  String get welcomeToGloryGym => 'اهلا بك في جلوري جيم';

  @override
  String get whatDoYouWantToAchieve => 'ما الذي تسعى إلى تحقيقه؟';

  @override
  String get whatsapp => 'واتساب';

  @override
  String get workout => 'تمرين';

  @override
  String get workoutDaysPerWeek => 'عدد أيام التمرين في الأسبوع';

  @override
  String get workoutRepetition => 'التكرار';

  @override
  String get workoutSet => 'المجموعة';

  @override
  String get workoutDetails => 'تفاصيل التمرين';

  @override
  String get workoutInProgress => 'تمرين جاري';

  @override
  String get workoutName => 'اسم التمرين';

  @override
  String get workoutType => 'نوع التمرين';

  @override
  String get workoutTypes => 'نوع التمارين';

  @override
  String get workouts => 'التمارين';

  @override
  String get writeAdditionalGoalIfAny => 'اكتب هدفاً إضافياً إن وجد';

  @override
  String get writeComplaintOrSuggestion => 'اكتب شكواك أو اقتراحك هنا...';

  @override
  String get writeMessageToSandy => 'اكتب رسالتك لساندي AI';

  @override
  String get year => 'سنة';

  @override
  String get yes => 'نعم';

  @override
  String get yesterday => 'الامس';

  @override
  String get yourSmartSportsAssistant => 'مساعدك الرياضي الذكي';

  @override
  String get yourWeight => 'وزنك';

  @override
  String get conjunctionAnd => ' و ';

  @override
  String get notificationsEnabled => 'مفعل';

  @override
  String get notificationsDisabled => 'غير مفعل';

  @override
  String get coachChat => 'كابتنك معاك';

  @override
  String get coachChatNotAssignedTitle => 'لم يتم تعيين مدرب بعد';

  @override
  String get coachChatNotAssignedDescription =>
      'سيتم تعيين مدربك من قبل فريق النادي. بعد التعيين، يمكنك التواصل معه من هنا.';

  @override
  String get coachChatWithInstructor => 'مدربك المعيّن';

  @override
  String get coachChatTypeMessage => 'اكتب رسالة...';

  @override
  String get coachChatStartConversation => 'أرسل رسالة لبدء المحادثة';

  @override
  String get contactYourCoach => 'تواصل مع مدربك';

  @override
  String get notAvailable => '—';
}
