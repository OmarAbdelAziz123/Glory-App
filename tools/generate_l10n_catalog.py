#!/usr/bin/env python3
"""Scan lib/ for Arabic string literals and update ARB localization catalogs."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parent.parent
LIB_DIR = ROOT / "lib"
L10N_DIR = LIB_DIR / "l10n"
EN_ARB = L10N_DIR / "app_en.arb"
AR_ARB = L10N_DIR / "app_ar.arb"
STRING_MAP = ROOT / "tools" / "l10n_string_map.json"

ARABIC_RE = re.compile(
    r"[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]"
)
DART_INTERP_RE = re.compile(r"\$\{([^}]+)\}|\$(\w+)")

EXPR_TO_PLACEHOLDER = {
    "currentStep + 1": "currentStep",
    "result.packageNameAr": "packageName",
    "result.instructorName": "instructorName",
    "result.remainingSessions": "remainingSessions",
    "member.fullName": "fullName",
}

SKIP_PATH_PARTS = ("/l10n/", "app_localizations")
SKIP_SUFFIXES = (".g.dart", ".freezed.dart")

CATALOG: dict[str, dict] = {
  "$days يوم": {
    "key": "daysCountLabel",
    "en": "{days} days",
    "placeholders": {
      "days": "String"
    }
  },
  "$weight كيلو": {
    "key": "weightKilosLabel",
    "en": "{weight} kg",
    "placeholders": {
      "weight": "String"
    }
  },
  "10 كيلو": {
    "key": "tenKilosLabel",
    "en": "10 kg"
  },
  "8 حروف علي الاقل": {
    "key": "passwordMinEightCharsHint",
    "en": "At least 8 characters"
  },
  "أب": {
    "key": "relationFather",
    "en": "Father"
  },
  "أجهزة": {
    "key": "equipmentMachines",
    "en": "Machines"
  },
  "أخ": {
    "key": "relationBrother",
    "en": "Brother"
  },
  "أخت": {
    "key": "relationSister",
    "en": "Sister"
  },
  "أرسل الرمز إلى رقم هاتفك": {
    "key": "sendCodeToPhone",
    "en": "Send the code to your phone number"
  },
  "أرمل": {
    "key": "maritalWidowed",
    "en": "Widowed"
  },
  "أضافة عضو جديد": {
    "key": "addNewMemberAlt",
    "en": "Add new member"
  },
  "أعزب": {
    "key": "maritalSingle",
    "en": "Single"
  },
  "أفراد العائلة": {
    "key": "familyMembers",
    "en": "Family members"
  },
  "أقدر أجهز لك خطة بسيطة حسب هدفك.": {
    "key": "sandyPlanOfferMessage",
    "en": "I can prepare a simple plan based on your goal."
  },
  "أكل": {
    "key": "nutritionEating",
    "en": "Eating"
  },
  "أم": {
    "key": "relationMother",
    "en": "Mother"
  },
  "أنثى": {
    "key": "genderFemale",
    "en": "Female"
  },
  "أهدافنا": {
    "key": "ourGoals",
    "en": "Our goals"
  },
  "أهلاً بك في عائلة جلوري جيم! لقد تم تسجيل دخول لحصة (${result.packageNameAr}) ": {
    "key": "checkinClassWelcomePrefix",
    "en": "Welcome to the Glory Gym family! You have checked in for a ({packageName}) class ",
    "placeholders": {
      "packageName": "String"
    }
  },
  "أهلاً بك في عائلة جلوري جيم! و نود ابلاغك بانه متبقي $days يوم من اشتراكك في الجيم": {
    "key": "subscriptionDaysRemainingWelcome",
    "en": "Welcome to the Glory Gym family! We would like to let you know that you have {days} days remaining on your gym subscription",
    "placeholders": {
      "days": "String"
    }
  },
  "أوافق على ": {
    "key": "agreeToPrefix",
    "en": "I agree to "
  },
  "أوزان حرة": {
    "key": "freeWeights",
    "en": "Free weights"
  },
  "إجابة تحميل مؤقتة": {
    "key": "tempLoadingAnswer",
    "en": "Temporary loading answer"
  },
  "إذا احتجت مقارنة بين الباقات أو تجديد الاشتراك، أخبرني.": {
    "key": "sandyPackagesCompareHint",
    "en": "If you need to compare packages or renew your subscription, let me know."
  },
  "إرسال": {
    "key": "submit",
    "en": "Submit"
  },
  "إرسال الاستبيان": {
    "key": "submitQuestionnaire",
    "en": "Submit questionnaire"
  },
  "إرسال البيانات": {
    "key": "submitData",
    "en": "Submit data"
  },
  "إضافة عضو جديد": {
    "key": "addNewMember",
    "en": "Add new member"
  },
  "إعادة إرسال": {
    "key": "resend",
    "en": "Resend"
  },
  "إعادة المحاولة": {
    "key": "retry",
    "en": "Retry"
  },
  "إعادة تأهيل بعد إصابة": {
    "key": "goalInjuryRehab",
    "en": "Rehabilitation after injury"
  },
  "إلغاء": {
    "key": "cancel",
    "en": "Cancel"
  },
  "إنشاء حساب": {
    "key": "createAccount",
    "en": "Create account"
  },
  "ابدأ بإضافة أفراد عائلتك للمتابعة من التطبيق": {
    "key": "familyAddMembersHint",
    "en": "Start by adding your family members to follow them from the app"
  },
  "ابن": {
    "key": "relationSon",
    "en": "Son"
  },
  "ابنة": {
    "key": "relationDaughter",
    "en": "Daughter"
  },
  "اختر إجراء": {
    "key": "chooseAction",
    "en": "Choose an action"
  },
  "اختر الدولة": {
    "key": "chooseCountry",
    "en": "Choose country"
  },
  "اختر اللغة": {
    "key": "chooseLanguage",
    "en": "Choose language"
  },
  "اختيار متعدد": {
    "key": "multiSelect",
    "en": "Multiple selection"
  },
  "اخر الحجوزات": {
    "key": "recentBookings",
    "en": "Recent bookings"
  },
  "اذكر المدة والبرنامج السابق": {
    "key": "mentionDurationAndPreviousProgram",
    "en": "Mention the duration and previous program"
  },
  "اذكر موضع الإصابة وتاريخها": {
    "key": "mentionInjuryLocationAndDate",
    "en": "Mention the injury location and date"
  },
  "اسأل ساندي عن التمارين، التغذية، أو اشتراكك": {
    "key": "askSandyHint",
    "en": "Ask Sandy about workouts, nutrition, or your subscription"
  },
  "اسألني عن التمارين، التغذية، أو أي استفسار يخص اشتراكك.": {
    "key": "sandyAskMeHint",
    "en": "Ask me about workouts, nutrition, or any question about your subscription."
  },
  "استبيان الاشتراك": {
    "key": "subscriptionQuestionnaire",
    "en": "Subscription questionnaire"
  },
  "استبيان الجاهزية البدنية (PAR-Q). يُرجى الإجابة بدقة.": {
    "key": "parqQuestionnaireIntro",
    "en": "Physical Activity Readiness Questionnaire (PAR-Q). Please answer accurately."
  },
  "استفسار عن الاشتراك": {
    "key": "subscriptionInquiry",
    "en": "Subscription inquiry"
  },
  "اسم الباقة": {
    "key": "packageName",
    "en": "Package name"
  },
  "اسم المدرب": {
    "key": "instructorName",
    "en": "Instructor name"
  },
  "اسم المستخدم": {
    "key": "username",
    "en": "Username"
  },
  "اشتراك": {
    "key": "subscription",
    "en": "Subscription"
  },
  "اشتراكاتي": {
    "key": "mySubscriptions",
    "en": "My subscriptions"
  },
  "اشرب 2–3 لتر ماء يومياً، وقلّل السكريات المكررة. ": {
    "key": "nutritionWaterTip",
    "en": "Drink 2–3 liters of water daily and reduce refined sugars."
  },
  "اصدار بواسطة: احمد حسام": {
    "key": "issuedByAhmedHossam",
    "en": "Issued by: Ahmed Hossam"
  },
  "اصدرت بواسطة": {
    "key": "issuedBy",
    "en": "Issued by"
  },
  "اضافة فرد للعائلة": {
    "key": "addFamilyMember",
    "en": "Add family member"
  },
  "اضافة وزن": {
    "key": "addWeight",
    "en": "Add weight"
  },
  "اضافة وزن ( للتمرين )": {
    "key": "addWorkoutWeight",
    "en": "Add weight (for workout)"
  },
  "اقترح لي برنامج تمرين": {
    "key": "suggestWorkoutProgram",
    "en": "Suggest a workout program for me"
  },
  "اكتب رسالتك لساندي AI": {
    "key": "writeMessageToSandy",
    "en": "Write your message to Sandy AI"
  },
  "اكتب شكواك أو اقتراحك هنا...": {
    "key": "writeComplaintOrSuggestion",
    "en": "Write your complaint or suggestion here..."
  },
  "اكتب هدفاً إضافياً إن وجد": {
    "key": "writeAdditionalGoalIfAny",
    "en": "Write an additional goal if any"
  },
  "الأردن": {
    "key": "countryJordan",
    "en": "Jordan"
  },
  "الأسئلة الشائعة": {
    "key": "faq",
    "en": "Frequently asked questions"
  },
  "الإعدادات": {
    "key": "settings",
    "en": "Settings"
  },
  "الإمارات العربية المتحدة": {
    "key": "countryUAE",
    "en": "United Arab Emirates"
  },
  "الاثنان": {
    "key": "genderBoth",
    "en": "Both"
  },
  "الاسم": {
    "key": "name",
    "en": "Name"
  },
  "الاسم الكامل": {
    "key": "fullName",
    "en": "Full name"
  },
  "الاشعارات": {
    "key": "notificationsAlt",
    "en": "Notifications"
  },
  "الامس": {
    "key": "yesterday",
    "en": "Yesterday"
  },
  "البحرين": {
    "key": "countryBahrain",
    "en": "Bahrain"
  },
  "البريد الإلكتروني": {
    "key": "email",
    "en": "Email"
  },
  "البريد الإلكتروني او رقم الهاتف": {
    "key": "emailOrPhone",
    "en": "Email or phone number"
  },
  "البيانات الشخصية": {
    "key": "personalData",
    "en": "Personal data"
  },
  "التاريخ": {
    "key": "date",
    "en": "Date"
  },
  "التاريخ الصحي": {
    "key": "healthHistory",
    "en": "Health history"
  },
  "التالي": {
    "key": "next",
    "en": "Next"
  },
  "التغذية": {
    "key": "nutrition",
    "en": "Nutrition"
  },
  "التفاصيل": {
    "key": "details",
    "en": "Details"
  },
  "التكتله العضليه": {
    "key": "muscleMass",
    "en": "Muscle mass"
  },
  "التمارين المفضلة": {
    "key": "favoriteWorkouts",
    "en": "Favorite workouts"
  },
  "الجزائر": {
    "key": "countryAlgeria",
    "en": "Algeria"
  },
  "الجنس": {
    "key": "gender",
    "en": "Gender"
  },
  "الحالة الاجتماعية": {
    "key": "maritalStatus",
    "en": "Marital status"
  },
  "الحالة الصحية": {
    "key": "healthStatus",
    "en": "Health status"
  },
  "الحجوزات": {
    "key": "bookings",
    "en": "Bookings"
  },
  "الحصص الجماعية": {
    "key": "groupClasses",
    "en": "Group classes"
  },
  "الخطوة ${currentStep + 1} من $totalSteps": {
    "key": "questionnaireStepProgress",
    "en": "Step {currentStep} of {totalSteps}",
    "placeholders": {
      "currentStep": "String",
      "totalSteps": "String"
    }
  },
  "الرئيسية": {
    "key": "home",
    "en": "Home"
  },
  "الرجاء إدخال بريدك الإلكتروني او رقم هاتفك لإرسال رمز التأكيد إليه": {
    "key": "forgotPasswordEmailOrPhoneHint",
    "en": "Please enter your email or phone number to send the verification code"
  },
  "الرجاء إدخال بريدك الإلكتروني او رقم هاتفك ومع كلمة المرور للوصول إلى حسابك.": {
    "key": "loginEmailOrPhoneHint",
    "en": "Please enter your email or phone number along with your password to access your account."
  },
  "الرجاء إدخال بريدك الإلكتروني وسنرسل رمز التأكيد إلى بريدك الإلكتروني": {
    "key": "forgotPasswordEmailHint",
    "en": "Please enter your email and we will send a verification code to your email"
  },
  "السابق": {
    "key": "previous",
    "en": "Previous"
  },
  "السودان": {
    "key": "countrySudan",
    "en": "Sudan"
  },
  "الشروط والأحكام": {
    "key": "termsAndConditions",
    "en": "Terms and conditions"
  },
  "الشكوى أو الاقتراح": {
    "key": "complaintOrSuggestion",
    "en": "Complaint or suggestion"
  },
  "الصومال": {
    "key": "countrySomalia",
    "en": "Somalia"
  },
  "العراق": {
    "key": "countryIraq",
    "en": "Iraq"
  },
  "العلاقة": {
    "key": "relationship",
    "en": "Relationship"
  },
  "العمر": {
    "key": "age",
    "en": "Age"
  },
  "العمر البيضي": {
    "key": "biologicalAge",
    "en": "Biological age"
  },
  "العوامل المؤثرة على الاستشفاء والنتائج.": {
    "key": "recoveryFactorsSubtitle",
    "en": "Factors affecting recovery and results."
  },
  "الغاء الحصة": {
    "key": "cancelClass",
    "en": "Cancel class"
  },
  "القياسات": {
    "key": "measurements",
    "en": "Measurements"
  },
  "القياسات الحالية بوحدة السنتيمتر. الصور اختيارية.": {
    "key": "measurementsCmOptionalPhotos",
    "en": "Current measurements are in centimeters. Photos are optional."
  },
  "الكويت": {
    "key": "countryKuwait",
    "en": "Kuwait"
  },
  "المرحلة $stepNumber": {
    "key": "phaseNumberLabel",
    "en": "Phase {stepNumber}",
    "placeholders": {
      "stepNumber": "String"
    }
  },
  "المرحلة الاولى": {
    "key": "phaseOne",
    "en": "Phase one"
  },
  "المرحلة الثالثة": {
    "key": "phaseThree",
    "en": "Phase three"
  },
  "المرحلة الثانية": {
    "key": "phaseTwo",
    "en": "Phase two"
  },
  "المرحلة الرابعة": {
    "key": "phaseFour",
    "en": "Phase four"
  },
  "المعلومات الأساسية الخاصة بالمشترك.": {
    "key": "subscriberBasicInfoSubtitle",
    "en": "Basic information about the subscriber."
  },
  "المغرب": {
    "key": "countryMorocco",
    "en": "Morocco"
  },
  "الملف الشخصي": {
    "key": "profile",
    "en": "Profile"
  },
  "المملكة العربية السعودية": {
    "key": "countrySaudiArabia",
    "en": "Saudi Arabia"
  },
  "المهنة": {
    "key": "occupation",
    "en": "Occupation"
  },
  "المواعيد": {
    "key": "appointments",
    "en": "Appointments"
  },
  "النشاط البدني الحالي": {
    "key": "currentPhysicalActivity",
    "en": "Current physical activity"
  },
  "النوع": {
    "key": "type",
    "en": "Type"
  },
  "الهاتف": {
    "key": "telephone",
    "en": "Telephone"
  },
  "الهدف من الاشتراك": {
    "key": "subscriptionGoal",
    "en": "Subscription goal"
  },
  "الوزن": {
    "key": "weight",
    "en": "Weight"
  },
  "الوزن السابق": {
    "key": "previousWeight",
    "en": "Previous weight"
  },
  "الوزن المقترح": {
    "key": "suggestedWeight",
    "en": "Suggested weight"
  },
  "الوقت": {
    "key": "time",
    "en": "Time"
  },
  "الوقت المفضل للتمرين": {
    "key": "preferredWorkoutTime",
    "en": "Preferred workout time"
  },
  "اليمن": {
    "key": "countryYemen",
    "en": "Yemen"
  },
  "اليوم": {
    "key": "today",
    "en": "Today"
  },
  "انستجرام": {
    "key": "instagram",
    "en": "Instagram"
  },
  "انشاء كلمة مرور": {
    "key": "createPassword",
    "en": "Create password"
  },
  "انشاء كلمة مرور جديدة": {
    "key": "createNewPassword",
    "en": "Create new password"
  },
  "اهلا بعودتك": {
    "key": "welcomeBackAlt",
    "en": "Welcome back"
  },
  "اهلا بك في جلوري جيم": {
    "key": "welcomeToGloryGym",
    "en": "Welcome to Glory Gym"
  },
  "باق": {
    "key": "package",
    "en": "Package"
  },
  "برنامج": {
    "key": "program",
    "en": "Program"
  },
  "بنجاح": {
    "key": "successfully",
    "en": "Successfully"
  },
  "تأكيد": {
    "key": "confirm",
    "en": "Confirm"
  },
  "تاريخ الاضافة": {
    "key": "dateAdded",
    "en": "Date added"
  },
  "تاريخ الانتهاء": {
    "key": "endDate",
    "en": "End date"
  },
  "تاريخ البداية": {
    "key": "startDate",
    "en": "Start date"
  },
  "تاريخ الميلاد": {
    "key": "dateOfBirth",
    "en": "Date of birth"
  },
  "تاكيد كلمة المرور": {
    "key": "confirmPasswordAlt",
    "en": "Confirm password"
  },
  "تحتوي على حرف كبير أو صغير": {
    "key": "passwordHasLetter",
    "en": "Contains an uppercase or lowercase letter"
  },
  "تحتوي على رقم واحد على الأقل": {
    "key": "passwordHasDigit",
    "en": "Contains at least one number"
  },
  "تحسين اللياقة": {
    "key": "goalImproveFitness",
    "en": "Improve fitness"
  },
  "تدريب شخصي": {
    "key": "personalTraining",
    "en": "Personal training"
  },
  "تسجيل الدخول": {
    "key": "login",
    "en": "Login"
  },
  "تسجيل الدخول سريع مع": {
    "key": "quickLoginWith",
    "en": "Quick login with"
  },
  "تسجيل دخول": {
    "key": "signIn",
    "en": "Sign in"
  },
  "تسجيل دخول التدريب": {
    "key": "trainingCheckIn",
    "en": "Training check-in"
  },
  "تسجيل للجيم": {
    "key": "gymCheckIn",
    "en": "Gym check-in"
  },
  "تعديل": {
    "key": "edit",
    "en": "Edit"
  },
  "تعديل فرد العائلة": {
    "key": "editFamilyMember",
    "en": "Edit family member"
  },
  "تعذر فتح الرابط": {
    "key": "couldNotOpenLink",
    "en": "Could not open link"
  },
  "تعذر فتح رابط التقييم": {
    "key": "couldNotOpenEvaluationLink",
    "en": "Could not open evaluation link"
  },
  "تعرف علي جلوري جيم": {
    "key": "getToKnowGloryGym",
    "en": "Get to know Glory Gym"
  },
  "تعليمات التمرين العامة": {
    "key": "generalWorkoutInstructions",
    "en": "General workout instructions"
  },
  "تغذ": {
    "key": "nutritionShort",
    "en": "Nutrition"
  },
  "تغير البريد الالكتروني": {
    "key": "changeEmail",
    "en": "Change email"
  },
  "تفاصيل التمرين": {
    "key": "workoutDetails",
    "en": "Workout details"
  },
  "تفاصيل العملية": {
    "key": "surgeryDetails",
    "en": "Surgery details"
  },
  "تقييم التدريب": {
    "key": "trainingEvaluation",
    "en": "Training evaluation"
  },
  "تقييم الحصة": {
    "key": "classEvaluation",
    "en": "Class evaluation"
  },
  "تقييم للحصة": {
    "key": "evaluateClass",
    "en": "Evaluate class"
  },
  "تقييمات التطبيق": {
    "key": "appReviews",
    "en": "App reviews"
  },
  "تم إرسال الاستبيان": {
    "key": "questionnaireSent",
    "en": "Questionnaire submitted"
  },
  "تم إرسال رمز التحقق مرة أخرى": {
    "key": "verificationCodeResent",
    "en": "Verification code sent again"
  },
  "تم إرسال رمز مكون من 6 أرقام على بريدك الإلكتروني ": {
    "key": "otpSentToEmail",
    "en": "A 6-digit code has been sent to your email "
  },
  "تم إنشاء كلمة مرور جديدة بنجاح!": {
    "key": "newPasswordCreatedSuccess",
    "en": "New password created successfully!"
  },
  "تم الإرسال": {
    "key": "sent",
    "en": "Sent"
  },
  "تم الغاء الحصة بنجاح": {
    "key": "classCancelledSuccess",
    "en": "Class cancelled successfully"
  },
  "تم حذف العضو بنجاح": {
    "key": "memberDeletedSuccess",
    "en": "Member deleted successfully"
  },
  "تم حفظ بياناتك بنجاح": {
    "key": "dataSavedSuccess",
    "en": "Your data has been saved successfully"
  },
  "تماريني": {
    "key": "myWorkouts",
    "en": "My workouts"
  },
  "تمرين": {
    "key": "workout",
    "en": "Workout"
  },
  "تمرين جاري": {
    "key": "workoutInProgress",
    "en": "Workout in progress"
  },
  "تمرين قادم": {
    "key": "upcomingWorkout",
    "en": "Upcoming workout"
  },
  "تمرين مكتمل": {
    "key": "completedWorkout",
    "en": "Completed workout"
  },
  "تواصل معنا": {
    "key": "contactUs",
    "en": "Contact us"
  },
  "توليد QR كود اخر": {
    "key": "generateNewQrCode",
    "en": "Generate new QR code"
  },
  "تونس": {
    "key": "countryTunisia",
    "en": "Tunisia"
  },
  "تويتر": {
    "key": "twitter",
    "en": "Twitter"
  },
  "جزر القمر": {
    "key": "countryComoros",
    "en": "Comoros"
  },
  "جيبوتي": {
    "key": "countryDjibouti",
    "en": "Djibouti"
  },
  "جيم": {
    "key": "gym",
    "en": "Gym"
  },
  "حاول الاحتفاظ بكلمة المرور بعيدا لتفادي سرقة حسابك و بياناتك": {
    "key": "keepPasswordSafeHint",
    "en": "Try to keep your password private to avoid account and data theft"
  },
  "حدث خطأ، حاول مرة أخرى": {
    "key": "errorTryAgain",
    "en": "An error occurred, please try again"
  },
  "حذف": {
    "key": "delete",
    "en": "Delete"
  },
  "حذف الحساب": {
    "key": "deleteAccount",
    "en": "Delete account"
  },
  "حذف عضو": {
    "key": "deleteMemberAlt",
    "en": "Delete member"
  },
  "حركة متوسطة": {
    "key": "activityModerate",
    "en": "Moderate activity"
  },
  "حسناً": {
    "key": "okAlt",
    "en": "OK"
  },
  "حصة جماعية": {
    "key": "groupClass",
    "en": "Group class"
  },
  "حصص": {
    "key": "sessions",
    "en": "Sessions"
  },
  "حفظ التعديلات": {
    "key": "saveChanges",
    "en": "Save changes"
  },
  "خسارة دهون": {
    "key": "goalFatLoss",
    "en": "Fat loss"
  },
  "ذكر": {
    "key": "genderMale",
    "en": "Male"
  },
  "رؤية الكل": {
    "key": "seeAll",
    "en": "See all"
  },
  "رؤيتنا": {
    "key": "ourVision",
    "en": "Our vision"
  },
  "رائع! أنصحك ببرنامج 3 أيام في الأسبوع: ": {
    "key": "sandyThreeDayProgramAdvice",
    "en": "Great! I recommend a 3-day per week program: "
  },
  "رابط التقييم غير متاح حالياً": {
    "key": "evaluationLinkUnavailable",
    "en": "Evaluation link is currently unavailable"
  },
  "رقم الجوال": {
    "key": "mobileNumber",
    "en": "Mobile number"
  },
  "رقم الهاتف": {
    "key": "phone",
    "en": "Phone number"
  },
  "رقم الهاتف *": {
    "key": "phoneRequired",
    "en": "Phone number *"
  },
  "رمز التحقق": {
    "key": "verificationCode",
    "en": "Verification code"
  },
  "رمز التحقق غير صالح، حاول مرة أخرى": {
    "key": "invalidVerificationCode",
    "en": "Invalid verification code, please try again"
  },
  "زوج": {
    "key": "relationHusband",
    "en": "Husband"
  },
  "زوجة": {
    "key": "relationWife",
    "en": "Wife"
  },
  "زيادة القوة": {
    "key": "goalIncreaseStrength",
    "en": "Increase strength"
  },
  "زيادة كتلة عضلية": {
    "key": "goalMuscleGain",
    "en": "Muscle gain"
  },
  "سؤال تحميل مؤقت": {
    "key": "tempLoadingQuestion",
    "en": "Temporary loading question"
  },
  "ساعة": {
    "key": "hour",
    "en": "Hour"
  },
  "ساندي AI": {
    "key": "sandyAi",
    "en": "Sandy AI"
  },
  "ستنتهي صلاحية الكود خلال ( $secondsLabel ثانية )": {
    "key": "codeExpiresInSeconds",
    "en": "The code will expire in ({secondsLabel} seconds)",
    "placeholders": {
      "secondsLabel": "String"
    }
  },
  "ستنتهي صلاحية الكود خلال ( $timerText ثانية ) ": {
    "key": "codeExpiresInTimer",
    "en": "The code will expire in ({timerText} seconds) ",
    "placeholders": {
      "timerText": "String"
    }
  },
  "سم": {
    "key": "unitCm",
    "en": "cm"
  },
  "سنة": {
    "key": "year",
    "en": "Year"
  },
  "سنقوم بمراجعة شكواك أو اقتراحك والرد عليك في أقرب وقت.": {
    "key": "complaintReviewMessage",
    "en": "We will review your complaint or suggestion and respond as soon as possible."
  },
  "سوريا": {
    "key": "countrySyria",
    "en": "Syria"
  },
  "سياسة الخصوصية": {
    "key": "privacyPolicy",
    "en": "Privacy policy"
  },
  "شد الجسم": {
    "key": "goalBodyToning",
    "en": "Body toning"
  },
  "شروط الخدمة": {
    "key": "termsOfService",
    "en": "Terms of service"
  },
  "شكاوي و اقتراحات": {
    "key": "complaintsAndSuggestions",
    "en": "Complaints and suggestions"
  },
  "شكراً": {
    "key": "thankYou",
    "en": "Thank you"
  },
  "شكراً لتواصلك معنا": {
    "key": "thanksForContactingUs",
    "en": "Thank you for contacting us"
  },
  "شكراً لسؤالك! سأراجع طلبك وأرد عليك بأفضل توصية مناسبة لك. ": {
    "key": "sandyThanksForQuestion",
    "en": "Thank you for your question! I will review your request and reply with the best recommendation for you."
  },
  "شكراً لك. سيقوم المدرب بمراجعة بياناتك وإعداد خطة التدريب والتغذية المناسبة لك.": {
    "key": "onboardingCoachReviewMessage",
    "en": "Thank you. The coach will review your data and prepare a suitable training and nutrition plan for you."
  },
  "شكراً لك. سيقوم فريق جلوري جيم بمراجعة بياناتك وإعداد أفضل تجربة لك.": {
    "key": "onboardingTeamReviewMessage",
    "en": "Thank you. The Glory Gym team will review your data and prepare the best experience for you."
  },
  "صباح الخير": {
    "key": "goodMorning",
    "en": "Good morning"
  },
  "صباحاً": {
    "key": "morning",
    "en": "Morning"
  },
  "طبيعة العمل": {
    "key": "natureOfWork",
    "en": "Nature of work"
  },
  "طلب OTP": {
    "key": "requestOtp",
    "en": "Request OTP"
  },
  "ظهراً": {
    "key": "afternoon",
    "en": "Afternoon"
  },
  "عاداتك الغذائية اليومية.": {
    "key": "dailyNutritionHabitsSubtitle",
    "en": "Your daily nutrition habits."
  },
  "عدد أيام التمرين في الأسبوع": {
    "key": "workoutDaysPerWeek",
    "en": "Number of workout days per week"
  },
  "عدد الأيام التي تستطيع الالتزام بها أسبوعياً": {
    "key": "daysYouCanCommitWeekly",
    "en": "Number of days you can commit to weekly"
  },
  "عدد الايام المتبقية": {
    "key": "remainingDaysCount",
    "en": "Remaining days"
  },
  "عدد الوجبات اليومية": {
    "key": "dailyMealsCount",
    "en": "Number of daily meals"
  },
  "عدد ساعات النوم": {
    "key": "sleepHoursCount",
    "en": "Hours of sleep"
  },
  "عُمان": {
    "key": "countryOman",
    "en": "Oman"
  },
  "غذ": {
    "key": "nutritionShortAlt",
    "en": "Nutrition"
  },
  "غير مفعل": {
    "key": "inactive",
    "en": "Inactive"
  },
  "فحص تكوين الجسم": {
    "key": "bodyCompositionScan",
    "en": "Body composition scan"
  },
  "فلسطين": {
    "key": "countryPalestine",
    "en": "Palestine"
  },
  "فيسبوك": {
    "key": "facebook",
    "en": "Facebook"
  },
  "قطر": {
    "key": "countryQatar",
    "en": "Qatar"
  },
  "قم بإدخال اسم المستخدم الخاصة بك": {
    "key": "enterYourUsername",
    "en": "Enter your username"
  },
  "قم بإدخال الاسم الكامل": {
    "key": "enterFullName",
    "en": "Enter full name"
  },
  "قم بإدخال العمر الخاص بك": {
    "key": "enterYourAge",
    "en": "Enter your age"
  },
  "قم بإدخال المهنة": {
    "key": "enterOccupation",
    "en": "Enter occupation"
  },
  "قم بإدخال الوزن المقترح الخاص بك لهذه التمرين": {
    "key": "enterSuggestedWeightForWorkout",
    "en": "Enter your suggested weight for this workout"
  },
  "قم بإدخال او رقم الهاتف الخاصة بك": {
    "key": "enterEmailOrPhone",
    "en": "Enter your email or phone number"
  },
  "قم بإدخال بريدك الإلكتروني الخاصة بك": {
    "key": "enterYourEmail",
    "en": "Enter your email"
  },
  "قم بإدخال بريدك الإلكتروني او رقم الهاتف الخاصة بك": {
    "key": "enterYourEmailOrPhone",
    "en": "Enter your email or phone number"
  },
  "قم بإدخال تاريخ الميلاد": {
    "key": "enterDateOfBirth",
    "en": "Enter date of birth"
  },
  "قم بإدخال تاكيد كلمة المرور الخاصة بك هنا": {
    "key": "enterConfirmPasswordHere",
    "en": "Enter your password confirmation here"
  },
  "قم بإدخال رقم الهاتف الخاصة بك": {
    "key": "enterYourPhone",
    "en": "Enter your phone number"
  },
  "قم بإدخال عدد الأيام": {
    "key": "enterNumberOfDays",
    "en": "Enter number of days"
  },
  "قم بإدخال عدد الساعات": {
    "key": "enterNumberOfHours",
    "en": "Enter number of hours"
  },
  "قم بإدخال عدد الوجبات": {
    "key": "enterNumberOfMeals",
    "en": "Enter number of meals"
  },
  "قم بإدخال كلمة المرور الجديدة الخاصة بك هنا": {
    "key": "enterNewPasswordHere",
    "en": "Enter your new password here"
  },
  "قم بإدخال كلمة المرور الخاصة بك": {
    "key": "enterYourPassword",
    "en": "Enter your password"
  },
  "قم بإدخال كلمة المرور الخاصة بك هنا": {
    "key": "enterPasswordHere",
    "en": "Enter your password here"
  },
  "قم بإدخال كمية الماء": {
    "key": "enterWaterAmount",
    "en": "Enter water amount"
  },
  "قم بإدخال محيط الخصر": {
    "key": "enterWaistCircumference",
    "en": "Enter waist circumference"
  },
  "قم بإدخال محيط الذراع": {
    "key": "enterArmCircumference",
    "en": "Enter arm circumference"
  },
  "قم بإدخال محيط الصدر": {
    "key": "enterChestCircumference",
    "en": "Enter chest circumference"
  },
  "قم بإدخال محيط الفخذ": {
    "key": "enterThighCircumference",
    "en": "Enter thigh circumference"
  },
  "قم بإدخال نسبة الدهون": {
    "key": "enterBodyFatPercentage",
    "en": "Enter body fat percentage"
  },
  "قم باختيار العلاقة": {
    "key": "selectRelationship",
    "en": "Select relationship"
  },
  "قم باختيار النوع": {
    "key": "selectType",
    "en": "Select type"
  },
  "قوة": {
    "key": "strength",
    "en": "Strength"
  },
  "قياسات الحجم": {
    "key": "sizeMeasurements",
    "en": "Size measurements"
  },
  "قيمنا": {
    "key": "ourValues",
    "en": "Our values"
  },
  "كارديو": {
    "key": "cardio",
    "en": "Cardio"
  },
  "كستواه الدهون الحشويه": {
    "key": "visceralFatLevel",
    "en": "Visceral fat level"
  },
  "كلمة المرور": {
    "key": "password",
    "en": "Password"
  },
  "كلمة المرور الجديدة": {
    "key": "newPassword",
    "en": "New password"
  },
  "كلمة المرور يجب أن تكون 8 أحرف على الأقل": {
    "key": "passwordMinEightChars",
    "en": "Password must be at least 8 characters"
  },
  "كلمتا المرور غير متطابقتين": {
    "key": "passwordsDoNotMatch",
    "en": "Passwords do not match"
  },
  "كلمتي المرور متطابقتين": {
    "key": "passwordsMatch",
    "en": "Passwords match"
  },
  "كمية الماء اليومية": {
    "key": "dailyWaterIntake",
    "en": "Daily water intake"
  },
  "لا": {
    "key": "no",
    "en": "No"
  },
  "لا تستطيع الوصول إلى بريدك الإلكتروني الآن؟": {
    "key": "cannotAccessEmailNow",
    "en": "Can't access your email right now?"
  },
  "لا توجد أمراض": {
    "key": "noDiseases",
    "en": "No diseases"
  },
  "لا توجد اشعارات": {
    "key": "noNotifications",
    "en": "No notifications"
  },
  "لا توجد تمارين": {
    "key": "noWorkouts",
    "en": "No workouts"
  },
  "لا توجد حجوزات حالياً": {
    "key": "noBookingsCurrently",
    "en": "No bookings currently"
  },
  "لا يوجد أفراد عائلة": {
    "key": "noFamilyMembers",
    "en": "No family members"
  },
  "لبنان": {
    "key": "countryLebanon",
    "en": "Lebanon"
  },
  "لتحديد جدول التدريب المناسب لك.": {
    "key": "toDetermineTrainingSchedule",
    "en": "To determine the appropriate training schedule for you."
  },
  "لتحسين أدائك: ركّز على البروtein بعد التمرين، ": {
    "key": "performanceProteinTip",
    "en": "To improve your performance: focus on protein after your workout, "
  },
  "لتر": {
    "key": "liter",
    "en": "Liter"
  },
  "لدي حساب بالفعل ؟ ": {
    "key": "alreadyHaveAccountPrefix",
    "en": "Already have an account? "
  },
  "لقد تم تقييم الحصة بنجاح!": {
    "key": "classEvaluatedSuccess",
    "en": "Class evaluated successfully!"
  },
  "لقد تم دخول الجيم بنجاح!": {
    "key": "gymCheckInSuccess",
    "en": "Gym check-in successful!"
  },
  "لقد تم دخولك للحصة بنجاح!": {
    "key": "classCheckInSuccess",
    "en": "Class check-in successful!"
  },
  "ليبيا": {
    "key": "countryLibya",
    "en": "Libya"
  },
  "ليس لديك حساب ؟": {
    "key": "dontHaveAccountPrefix",
    "en": "Don't have an account?"
  },
  "ليلاً": {
    "key": "night",
    "en": "Night"
  },
  "مؤشر كتلة الجسم": {
    "key": "bmi",
    "en": "Body mass index"
  },
  "ما الذي تسعى إلى تحقيقه؟": {
    "key": "whatDoYouWantToAchieve",
    "en": "What are you looking to achieve?"
  },
  "متزوج": {
    "key": "maritalMarried",
    "en": "Married"
  },
  "متوسط": {
    "key": "average",
    "en": "Average"
  },
  "مثال: أوزان، كارديو، سباحة": {
    "key": "exampleWeightsCardioSwimming",
    "en": "Example: weights, cardio, swimming"
  },
  "مثال: سنة وثلاثة أشهر": {
    "key": "exampleOneYearThreeMonths",
    "en": "Example: one year and three months"
  },
  "مجهود بدني": {
    "key": "physicalEffort",
    "en": "Physical effort"
  },
  "محتوى غير متاح حالياً": {
    "key": "contentUnavailable",
    "en": "Content currently unavailable"
  },
  "محيط الخصر": {
    "key": "waistCircumference",
    "en": "Waist circumference"
  },
  "محيط الذراع": {
    "key": "armCircumference",
    "en": "Arm circumference"
  },
  "محيط الصدر": {
    "key": "chestCircumference",
    "en": "Chest circumference"
  },
  "محيط الفخذ": {
    "key": "thighCircumference",
    "en": "Thigh circumference"
  },
  "مرتفع": {
    "key": "high",
    "en": "High"
  },
  "مرحباً! أنا ساندي، مساعدك الذكي في جلوري جيم. ": {
    "key": "sandyWelcomeMessage",
    "en": "Hello! I'm Sandy, your smart assistant at Glory Gym. "
  },
  "مرونة": {
    "key": "flexibility",
    "en": "Flexibility"
  },
  "مساء الخير": {
    "key": "goodEvening",
    "en": "Good evening"
  },
  "مساءً": {
    "key": "evening",
    "en": "Evening"
  },
  "مساعدك الرياضي الذكي": {
    "key": "yourSmartSportsAssistant",
    "en": "Your smart sports assistant"
  },
  "مستوى التوتر": {
    "key": "stressLevel",
    "en": "Stress level"
  },
  "مستوى نشاطك في الوقت الراهن.": {
    "key": "currentActivityLevelSubtitle",
    "en": "Your current activity level."
  },
  "مصر": {
    "key": "countryEgypt",
    "en": "Egypt"
  },
  "مطلق": {
    "key": "maritalDivorced",
    "en": "Divorced"
  },
  "مع الكوتش (${result.instructorName}) متبقي معك ${result.remainingSessions} حصص": {
    "key": "checkinClassWelcomeSuffix",
    "en": "With Coach {instructorName}, you have {remainingSessions} sessions remaining",
    "placeholders": {
      "instructorName": "String",
      "remainingSessions": "String"
    }
  },
  "معدل الايض الاساسي": {
    "key": "basalMetabolicRate",
    "en": "Basal metabolic rate"
  },
  "معلومات التدريب": {
    "key": "trainingInfo",
    "en": "Training information"
  },
  "معلومات عن جلوري جيم": {
    "key": "aboutGloryGymInfo",
    "en": "About Glory Gym"
  },
  "مفعل": {
    "key": "active",
    "en": "Active"
  },
  "مكتبي": {
    "key": "deskJob",
    "en": "Desk job"
  },
  "من نحن": {
    "key": "aboutUs",
    "en": "About us"
  },
  "منخفض": {
    "key": "low",
    "en": "Low"
  },
  "منذ متى تتمرن؟": {
    "key": "howLongHaveYouBeenTraining",
    "en": "How long have you been training?"
  },
  "منصات التواصل": {
    "key": "socialMediaPlatforms",
    "en": "Social media platforms"
  },
  "موريتانيا": {
    "key": "countryMauritania",
    "en": "Mauritania"
  },
  "موعد": {
    "key": "appointment",
    "en": "Appointment"
  },
  "نسبة الدهون (إن وجدت)": {
    "key": "bodyFatPercentageIfAny",
    "en": "Body fat percentage (if available)"
  },
  "نسبة الدهون في الجسم": {
    "key": "bodyFatPercentage",
    "en": "Body fat percentage"
  },
  "نسيت كلمة المرور": {
    "key": "forgotPassword",
    "en": "Forgot password"
  },
  "نصائح للتغذية الصحية": {
    "key": "healthyNutritionTips",
    "en": "Healthy nutrition tips"
  },
  "نعم": {
    "key": "yes",
    "en": "Yes"
  },
  "نمط الحياة": {
    "key": "lifestyle",
    "en": "Lifestyle"
  },
  "نوع الباقة": {
    "key": "packageType",
    "en": "Package type"
  },
  "نوع التمارين": {
    "key": "workoutTypes",
    "en": "Workout types"
  },
  "نوع التمرين": {
    "key": "workoutType",
    "en": "Workout type"
  },
  "هدف آخر": {
    "key": "otherGoal",
    "en": "Other goal"
  },
  "هذا الحقل مطلوب": {
    "key": "fieldRequired",
    "en": "This field is required"
  },
  "هل أجريت أي عملية جراحية؟": {
    "key": "hadSurgeryQuestion",
    "en": "Have you had any surgery?"
  },
  "هل أنت متأكد أنك تريد الغاء هذه الحصة؟": {
    "key": "confirmCancelClass",
    "en": "Are you sure you want to cancel this class?"
  },
  "هل أنت متأكد أنك تريد تسجيل الخروج؟": {
    "key": "confirmLogout",
    "en": "Are you sure you want to log out?"
  },
  "هل أنت متأكد أنك تريد حذف \"${member.fullName}\"؟": {
    "key": "deleteMemberConfirm",
    "en": "Are you sure you want to delete \"{fullName}\"?",
    "placeholders": {
      "fullName": "String"
    }
  },
  "هل تتبع نظاماً غذائياً؟": {
    "key": "followDietQuestion",
    "en": "Do you follow a diet?"
  },
  "هل تتناول أي أدوية بشكل دائم؟": {
    "key": "takeMedicationsQuestion",
    "en": "Do you take any medications regularly?"
  },
  "هل تريد مساعدة في التمارين، التغذية، أو الاشتراك؟": {
    "key": "needHelpWithWorkoutsNutritionSubscription",
    "en": "Do you need help with workouts, nutrition, or your subscription?"
  },
  "هل تستخدم مكملات غذائية؟": {
    "key": "useSupplementsQuestion",
    "en": "Do you use dietary supplements?"
  },
  "هل تفضل تمارين في الجيم أم في المنزل؟": {
    "key": "preferGymOrHomeWorkouts",
    "en": "Do you prefer gym or home workouts?"
  },
  "هل تمارس الرياضة حالياً؟": {
    "key": "currentlyExercisingQuestion",
    "en": "Are you currently exercising?"
  },
  "هل سبق أن تدربت مع مدرب شخصي؟": {
    "key": "trainedWithPersonalCoachQuestion",
    "en": "Have you ever trained with a personal coach?"
  },
  "هل لديك أي إصابات حالية أو سابقة؟": {
    "key": "haveInjuriesQuestion",
    "en": "Do you have any current or past injuries?"
  },
  "هل لديك أي مرض مزمن؟ (سكري، ضغط، قلب…)": {
    "key": "haveChronicDiseaseQuestion",
    "en": "Do you have any chronic illness? (diabetes, blood pressure, heart…)"
  },
  "واتساب": {
    "key": "whatsapp",
    "en": "WhatsApp"
  },
  "وجبة": {
    "key": "meal",
    "en": "Meal"
  },
  "وزنك": {
    "key": "yourWeight",
    "en": "Your weight"
  },
  "يجب ألا يزيد عن $max حرفاً": {
    "key": "maxCharsValidation",
    "en": "Must not exceed {max} characters",
    "placeholders": {
      "max": "String"
    }
  },
  "يجب ألا يقل عن $min أحرف": {
    "key": "minCharsValidation",
    "en": "Must be at least {min} characters",
    "placeholders": {
      "min": "String"
    }
  },
  "يجب أن تحتوي على حرف كبير أو صغير": {
    "key": "mustContainLetter",
    "en": "Must contain an uppercase or lowercase letter"
  },
  "يجب أن تحتوي على رقم واحد على الأقل": {
    "key": "mustContainDigit",
    "en": "Must contain at least one number"
  },
  "يرجى إدخال البريد الإلكتروني أو رقم الهاتف": {
    "key": "pleaseEnterEmailOrPhone",
    "en": "Please enter your email or phone number"
  },
  "يرجى إدخال بريد إلكتروني صحيح": {
    "key": "pleaseEnterValidEmail",
    "en": "Please enter a valid email address"
  },
  "يرجى إدخال رقم هاتف صحيح": {
    "key": "pleaseEnterValidPhone",
    "en": "Please enter a valid phone number"
  },
  "يرجى إدخال كلمة المرور": {
    "key": "pleaseEnterPassword",
    "en": "Please enter your password"
  },
  "يرجى تأكيد كلمة المرور": {
    "key": "pleaseConfirmPassword",
    "en": "Please confirm your password"
  },
  "يرجي إضافة كلمة مرور قوية للحفاظ علي بياناتك": {
    "key": "addStrongPasswordHint",
    "en": "Please add a strong password to protect your data"
  },
  "يمكن اختيار أكثر من هدف واحد.": {
    "key": "multipleGoalsAllowed",
    "en": "You can select more than one goal."
  },
  "يمكنك الاطلاع على باقاتك من قسم \"اشتراكاتي\" في الإعدادات. ": {
    "key": "viewPackagesInSettingsHint",
    "en": "You can view your packages in the \"My subscriptions\" section in Settings. "
  },
  "يوم": {
    "key": "day",
    "en": "Day"
  },
  "يوم للصدر والترiceps، يوم للظهر والبiceps، ويوم للأرجل. ": {
    "key": "sandyThreeDaySplitExample",
    "en": "One day for chest and triceps, one for back and biceps, and one for legs. "
  },
  "١ مايو ٢٠٢٦": {
    "key": "sampleDateMay2026",
    "en": "1 May 2026"
  },
  "١٠ يونيو ٢٠٢٦": {
    "key": "sampleDateJune2026",
    "en": "10 June 2026"
  }
}

def should_skip_file(path: Path) -> bool:
    text = str(path).replace("\\", "/")
    if any(part in text for part in SKIP_PATH_PARTS):
        return True
    return text.endswith(SKIP_SUFFIXES)


def unescape_dart_string(value: str) -> str:
    return (
        value.replace(r"\n", "\n")
        .replace(r"\'", "'")
        .replace(r"\"", '"')
        .replace(r"\\", "\\")
    )


def should_skip_string(value: str) -> bool:
    if len(value) < 2:
        return True
    lowered = value.lower()
    if "assets/" in value or "http" in lowered:
        return True
    if any(ext in lowered for ext in (".svg", ".png", ".jpg", ".jpeg", ".webp")):
        return True
    if len(ARABIC_RE.findall(value)) == 0:
        return True
    if len(ARABIC_RE.findall(value)) == 1 and len(value) <= 3:
        return True
    if re.fullmatch(r"[\s${}();=<>\[\]\+\-\*/\d\.]+", value):
        return True
    return False


def extract_strings(content: str) -> list[str]:
    found: list[str] = []
    patterns = (
        r"'((?:[^'\\]|\\.)*)'",
        r'"((?:[^"\\]|\\.)*)"',
        r"'''((?:[^']|'(?!''))*)'''",
        r'"""((?:[^"]|"(?!""))*)"""',
    )
    for pattern in patterns:
        for match in re.finditer(pattern, content, re.DOTALL):
            found.append(unescape_dart_string(match.group(1)))
    return found


def scan_arabic_strings() -> set[str]:
    results: set[str] = set()
    for dart_file in LIB_DIR.rglob("*.dart"):
        if should_skip_file(dart_file):
            continue
        try:
            content = dart_file.read_text(encoding="utf-8")
        except OSError as exc:
            print(f"Warning: could not read {dart_file}: {exc}", file=sys.stderr)
            continue
        for value in extract_strings(content):
            if ARABIC_RE.search(value) and not should_skip_string(value):
                results.add(value)
    return results


def placeholder_name(expr: str) -> str:
    expr = expr.strip()
    if expr in EXPR_TO_PLACEHOLDER:
        return EXPR_TO_PLACEHOLDER[expr]
    if "." in expr:
        return expr.split(".")[-1]
    cleaned = re.sub(r"[^a-zA-Z0-9_]", "", expr.replace(" + 1", ""))
    return cleaned or "value"


def dart_to_arb(
    value: str, catalog_placeholders: dict[str, str] | None
) -> tuple[str, dict[str, str]]:
    placeholders: dict[str, str] = dict(catalog_placeholders or {})

    def repl(match: re.Match[str]) -> str:
        expr = (match.group(1) or match.group(2) or "").strip()
        name = placeholder_name(expr)
        placeholders.setdefault(name, "String")
        return "{" + name + "}"

    return DART_INTERP_RE.sub(repl, value), placeholders


def load_arb(path: Path) -> dict[str, Any]:
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def is_message_key(key: str) -> bool:
    return not key.startswith("@") and key != "@@locale"


def existing_value_to_key(arb: dict[str, Any]) -> dict[str, str]:
    mapping: dict[str, str] = {}
    for key, value in arb.items():
        if is_message_key(key) and isinstance(value, str):
            mapping[value] = key
    return mapping


def write_arb(
    path: Path,
    locale: str,
    messages: dict[str, str],
    metadata: dict[str, dict[str, Any]],
) -> None:
    ordered: dict[str, Any] = {"@@locale": locale}
    for key in sorted(messages):
        if key.startswith("@"):
            continue
        ordered[key] = messages[key]
        meta_key = f"@{key}"
        if meta_key in metadata:
            ordered[meta_key] = metadata[meta_key]
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as handle:
        json.dump(ordered, handle, ensure_ascii=False, indent=2)
        handle.write("\n")


def main() -> int:
    scanned = scan_arabic_strings()
    en_arb = load_arb(EN_ARB)
    ar_arb = load_arb(AR_ARB)

    en_messages = {k: v for k, v in en_arb.items() if is_message_key(k)}
    ar_messages = {k: v for k, v in ar_arb.items() if is_message_key(k)}
    metadata: dict[str, dict[str, Any]] = {
        k: v for k, v in en_arb.items() if k.startswith("@") and k != "@@locale"
    }

    value_to_key = existing_value_to_key(ar_arb)
    string_map: dict[str, str] = {}
    new_keys = 0
    missing_catalog: list[str] = []

    for arabic in sorted(scanned):
        if arabic in value_to_key:
            string_map[arabic] = value_to_key[arabic]
            continue

        entry = CATALOG.get(arabic)
        if entry is None:
            missing_catalog.append(arabic)
            continue

        key = entry["key"]
        en_text = entry["en"]
        placeholders = entry.get("placeholders")

        ar_text, resolved_placeholders = dart_to_arb(arabic, placeholders)
        en_text, _ = dart_to_arb(en_text, placeholders)

        if key in en_messages and en_messages[key] != en_text:
            print(
                f"Warning: key '{key}' already exists with different English text; "
                "keeping existing",
                file=sys.stderr,
            )
            string_map[arabic] = key
            continue

        if key not in en_messages:
            en_messages[key] = en_text
            ar_messages[key] = ar_text
            new_keys += 1
            if resolved_placeholders:
                metadata[f"@{key}"] = {
                    "placeholders": {
                        name: {"type": ptype}
                        for name, ptype in sorted(resolved_placeholders.items())
                    }
                }

        string_map[arabic] = key

    for arabic, key in existing_value_to_key(ar_arb).items():
        string_map.setdefault(arabic, key)

    write_arb(EN_ARB, "en", en_messages, metadata)
    write_arb(AR_ARB, "ar", {k: ar_messages[k] for k in en_messages}, metadata)
    STRING_MAP.parent.mkdir(parents=True, exist_ok=True)
    with STRING_MAP.open("w", encoding="utf-8") as handle:
        json.dump(string_map, handle, ensure_ascii=False, indent=2, sort_keys=True)
        handle.write("\n")

    total_keys = len(en_messages)
    print(f"Scanned Arabic strings: {len(scanned)}")
    print(f"Total keys in catalog: {total_keys}")
    print(f"New keys added: {new_keys}")
    print(f"String map written to: {STRING_MAP}")
    if missing_catalog:
        print(f"Missing catalog entries: {len(missing_catalog)}", file=sys.stderr)
        for item in missing_catalog[:20]:
            print(f"  - {item!r}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
