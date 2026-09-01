import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @aboutGloryGymInfo.
  ///
  /// In en, this message translates to:
  /// **'Who We Are'**
  String get aboutGloryGymInfo;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get aboutUs;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @activeSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Active Subscriptions'**
  String get activeSubscriptions;

  /// No description provided for @activityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate activity'**
  String get activityModerate;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addFamilyMember.
  ///
  /// In en, this message translates to:
  /// **'Add family member'**
  String get addFamilyMember;

  /// No description provided for @addMember.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get addMember;

  /// No description provided for @addNewMember.
  ///
  /// In en, this message translates to:
  /// **'Add new member'**
  String get addNewMember;

  /// No description provided for @addNewMemberAlt.
  ///
  /// In en, this message translates to:
  /// **'Add new member'**
  String get addNewMemberAlt;

  /// No description provided for @addStrongPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Please add a strong password to protect your data'**
  String get addStrongPasswordHint;

  /// No description provided for @addSubscription.
  ///
  /// In en, this message translates to:
  /// **'Add Subscription'**
  String get addSubscription;

  /// No description provided for @addWeight.
  ///
  /// In en, this message translates to:
  /// **'Add weight'**
  String get addWeight;

  /// No description provided for @addWorkout.
  ///
  /// In en, this message translates to:
  /// **'Add Workout'**
  String get addWorkout;

  /// No description provided for @addWorkoutWeight.
  ///
  /// In en, this message translates to:
  /// **'Add weight (for workout)'**
  String get addWorkoutWeight;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @agreeToPrefix.
  ///
  /// In en, this message translates to:
  /// **'I agree to '**
  String get agreeToPrefix;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccount;

  /// No description provided for @alreadyHaveAccountPrefix.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccountPrefix;

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'Glory Gym'**
  String get appName;

  /// No description provided for @appReviews.
  ///
  /// In en, this message translates to:
  /// **'App reviews'**
  String get appReviews;

  /// No description provided for @appointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get appointment;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @armCircumference.
  ///
  /// In en, this message translates to:
  /// **'Arm circumference'**
  String get armCircumference;

  /// No description provided for @askSandyHint.
  ///
  /// In en, this message translates to:
  /// **'Ask Sandy about workouts, nutrition, or your subscription'**
  String get askSandyHint;

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @attendanceAt.
  ///
  /// In en, this message translates to:
  /// **'at {time}'**
  String attendanceAt(String time);

  /// No description provided for @attendanceHistory.
  ///
  /// In en, this message translates to:
  /// **'Attendance History'**
  String get attendanceHistory;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @basalMetabolicRate.
  ///
  /// In en, this message translates to:
  /// **'Basal metabolic rate'**
  String get basalMetabolicRate;

  /// No description provided for @biologicalAge.
  ///
  /// In en, this message translates to:
  /// **'Biological age'**
  String get biologicalAge;

  /// No description provided for @bmi.
  ///
  /// In en, this message translates to:
  /// **'Body mass index'**
  String get bmi;

  /// No description provided for @bodyCompositionScan.
  ///
  /// In en, this message translates to:
  /// **'Body composition scan'**
  String get bodyCompositionScan;

  /// No description provided for @bodyFatPercentage.
  ///
  /// In en, this message translates to:
  /// **'Body fat percentage'**
  String get bodyFatPercentage;

  /// No description provided for @bodyFatPercentageIfAny.
  ///
  /// In en, this message translates to:
  /// **'Body fat percentage (if available)'**
  String get bodyFatPercentageIfAny;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera access is required to scan QR codes'**
  String get cameraPermissionRequired;

  /// No description provided for @cameraPermissionRationale.
  ///
  /// In en, this message translates to:
  /// **'We need camera access to scan QR codes and check in to your individual session.'**
  String get cameraPermissionRationale;

  /// No description provided for @cameraPermissionDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Camera access was not granted. You can try again or enable it from settings.'**
  String get cameraPermissionDeniedMessage;

  /// No description provided for @cameraPermissionSettingsMessage.
  ///
  /// In en, this message translates to:
  /// **'Open settings and enable camera access to continue.'**
  String get cameraPermissionSettingsMessage;

  /// No description provided for @allowCameraAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow camera access'**
  String get allowCameraAccess;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get scanQrCode;

  /// No description provided for @pointCameraAtQr.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the QR code'**
  String get pointCameraAtQr;

  /// No description provided for @qrScanSuccess.
  ///
  /// In en, this message translates to:
  /// **'QR code scanned successfully'**
  String get qrScanSuccess;

  /// No description provided for @invalidQrCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR code'**
  String get invalidQrCode;

  /// No description provided for @cancelClass.
  ///
  /// In en, this message translates to:
  /// **'Cancel class'**
  String get cancelClass;

  /// No description provided for @cannotAccessEmailNow.
  ///
  /// In en, this message translates to:
  /// **'Can\'t access your email right now?'**
  String get cannotAccessEmailNow;

  /// No description provided for @cardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get cardio;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get changeEmail;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get checkOut;

  /// No description provided for @checkedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked In'**
  String get checkedIn;

  /// No description provided for @checkedOut.
  ///
  /// In en, this message translates to:
  /// **'Checked Out'**
  String get checkedOut;

  /// No description provided for @checkinClassWelcomePrefix.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Glory Gym family! You have checked in for a ({packageName}) class '**
  String checkinClassWelcomePrefix(String packageName);

  /// No description provided for @checkinClassWelcomeSuffix.
  ///
  /// In en, this message translates to:
  /// **'With Coach {instructorName}, you have {remainingSessions} sessions remaining'**
  String checkinClassWelcomeSuffix(
    String instructorName,
    String remainingSessions,
  );

  /// No description provided for @chestCircumference.
  ///
  /// In en, this message translates to:
  /// **'Chest circumference'**
  String get chestCircumference;

  /// No description provided for @chooseAction.
  ///
  /// In en, this message translates to:
  /// **'Choose an action'**
  String get chooseAction;

  /// No description provided for @chooseCountry.
  ///
  /// In en, this message translates to:
  /// **'Choose country'**
  String get chooseCountry;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguage;

  /// No description provided for @classCancelledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Class cancelled successfully'**
  String get classCancelledSuccess;

  /// No description provided for @classCheckInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Class check-in successful!'**
  String get classCheckInSuccess;

  /// No description provided for @classEvaluatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Class evaluated successfully!'**
  String get classEvaluatedSuccess;

  /// No description provided for @classEvaluation.
  ///
  /// In en, this message translates to:
  /// **'Class evaluation'**
  String get classEvaluation;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @codeExpiresInSeconds.
  ///
  /// In en, this message translates to:
  /// **'The code will expire in ({secondsLabel} seconds)'**
  String codeExpiresInSeconds(String secondsLabel);

  /// No description provided for @codeExpiresInTimer.
  ///
  /// In en, this message translates to:
  /// **'The code will expire in ({timerText} seconds) '**
  String codeExpiresInTimer(String timerText);

  /// No description provided for @complaintOrSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Complaint or suggestion'**
  String get complaintOrSuggestion;

  /// No description provided for @complaintReviewMessage.
  ///
  /// In en, this message translates to:
  /// **'We will review your complaint or suggestion and respond as soon as possible.'**
  String get complaintReviewMessage;

  /// No description provided for @complaintsAndSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Complaints and suggestions'**
  String get complaintsAndSuggestions;

  /// No description provided for @completedWorkout.
  ///
  /// In en, this message translates to:
  /// **'Completed workout'**
  String get completedWorkout;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmCancelClass.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this class?'**
  String get confirmCancelClass;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get confirmLogout;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordAlt.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordAlt;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @contentUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Content currently unavailable'**
  String get contentUnavailable;

  /// No description provided for @couldNotOpenEvaluationLink.
  ///
  /// In en, this message translates to:
  /// **'Could not open evaluation link'**
  String get couldNotOpenEvaluationLink;

  /// No description provided for @couldNotOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Could not open link'**
  String get couldNotOpenLink;

  /// No description provided for @countryAlgeria.
  ///
  /// In en, this message translates to:
  /// **'Algeria'**
  String get countryAlgeria;

  /// No description provided for @countryBahrain.
  ///
  /// In en, this message translates to:
  /// **'Bahrain'**
  String get countryBahrain;

  /// No description provided for @countryComoros.
  ///
  /// In en, this message translates to:
  /// **'Comoros'**
  String get countryComoros;

  /// No description provided for @countryDjibouti.
  ///
  /// In en, this message translates to:
  /// **'Djibouti'**
  String get countryDjibouti;

  /// No description provided for @countryEgypt.
  ///
  /// In en, this message translates to:
  /// **'Egypt'**
  String get countryEgypt;

  /// No description provided for @countryIraq.
  ///
  /// In en, this message translates to:
  /// **'Iraq'**
  String get countryIraq;

  /// No description provided for @countryJordan.
  ///
  /// In en, this message translates to:
  /// **'Jordan'**
  String get countryJordan;

  /// No description provided for @countryKuwait.
  ///
  /// In en, this message translates to:
  /// **'Kuwait'**
  String get countryKuwait;

  /// No description provided for @countryLebanon.
  ///
  /// In en, this message translates to:
  /// **'Lebanon'**
  String get countryLebanon;

  /// No description provided for @countryLibya.
  ///
  /// In en, this message translates to:
  /// **'Libya'**
  String get countryLibya;

  /// No description provided for @countryMauritania.
  ///
  /// In en, this message translates to:
  /// **'Mauritania'**
  String get countryMauritania;

  /// No description provided for @countryMorocco.
  ///
  /// In en, this message translates to:
  /// **'Morocco'**
  String get countryMorocco;

  /// No description provided for @countryOman.
  ///
  /// In en, this message translates to:
  /// **'Oman'**
  String get countryOman;

  /// No description provided for @countryPalestine.
  ///
  /// In en, this message translates to:
  /// **'Palestine'**
  String get countryPalestine;

  /// No description provided for @countryQatar.
  ///
  /// In en, this message translates to:
  /// **'Qatar'**
  String get countryQatar;

  /// No description provided for @countrySaudiArabia.
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabia'**
  String get countrySaudiArabia;

  /// No description provided for @countrySomalia.
  ///
  /// In en, this message translates to:
  /// **'Somalia'**
  String get countrySomalia;

  /// No description provided for @countrySudan.
  ///
  /// In en, this message translates to:
  /// **'Sudan'**
  String get countrySudan;

  /// No description provided for @countrySyria.
  ///
  /// In en, this message translates to:
  /// **'Syria'**
  String get countrySyria;

  /// No description provided for @countryTunisia.
  ///
  /// In en, this message translates to:
  /// **'Tunisia'**
  String get countryTunisia;

  /// No description provided for @countryUAE.
  ///
  /// In en, this message translates to:
  /// **'United Arab Emirates'**
  String get countryUAE;

  /// No description provided for @countryYemen.
  ///
  /// In en, this message translates to:
  /// **'Yemen'**
  String get countryYemen;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create new password'**
  String get createNewPassword;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create password'**
  String get createPassword;

  /// No description provided for @currentActivityLevelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your current activity level.'**
  String get currentActivityLevelSubtitle;

  /// No description provided for @currentPhysicalActivity.
  ///
  /// In en, this message translates to:
  /// **'Current physical activity'**
  String get currentPhysicalActivity;

  /// No description provided for @currentlyExercisingQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you currently exercising?'**
  String get currentlyExercisingQuestion;

  /// No description provided for @dailyMealsCount.
  ///
  /// In en, this message translates to:
  /// **'Number of daily meals'**
  String get dailyMealsCount;

  /// No description provided for @dailyNutritionHabitsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your daily nutrition habits.'**
  String get dailyNutritionHabitsSubtitle;

  /// No description provided for @dailyWaterIntake.
  ///
  /// In en, this message translates to:
  /// **'Daily water intake'**
  String get dailyWaterIntake;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @dataSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your data has been saved successfully'**
  String get dataSavedSuccess;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @dateAdded.
  ///
  /// In en, this message translates to:
  /// **'Date added'**
  String get dateAdded;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @daysCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String daysCountLabel(String days);

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} days left'**
  String daysLeft(int count);

  /// No description provided for @daysYouCanCommitWeekly.
  ///
  /// In en, this message translates to:
  /// **'Number of days you can commit to weekly'**
  String get daysYouCanCommitWeekly;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteConfirmMember.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this member?'**
  String get deleteConfirmMember;

  /// No description provided for @deleteMember.
  ///
  /// In en, this message translates to:
  /// **'Delete Member'**
  String get deleteMember;

  /// No description provided for @deleteMemberAlt.
  ///
  /// In en, this message translates to:
  /// **'Delete member'**
  String get deleteMemberAlt;

  /// No description provided for @deleteMemberConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{fullName}\"?'**
  String deleteMemberConfirm(String fullName);

  /// No description provided for @deskJob.
  ///
  /// In en, this message translates to:
  /// **'Desk job'**
  String get deskJob;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get dontHaveAccount;

  /// No description provided for @dontHaveAccountPrefix.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccountPrefix;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editFamilyMember.
  ///
  /// In en, this message translates to:
  /// **'Edit family member'**
  String get editFamilyMember;

  /// No description provided for @editMember.
  ///
  /// In en, this message translates to:
  /// **'Edit Member'**
  String get editMember;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Email or phone number'**
  String get emailOrPhone;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @enterArmCircumference.
  ///
  /// In en, this message translates to:
  /// **'Enter arm circumference'**
  String get enterArmCircumference;

  /// No description provided for @enterBodyFatPercentage.
  ///
  /// In en, this message translates to:
  /// **'Enter body fat percentage'**
  String get enterBodyFatPercentage;

  /// No description provided for @enterChestCircumference.
  ///
  /// In en, this message translates to:
  /// **'Enter chest circumference'**
  String get enterChestCircumference;

  /// No description provided for @enterConfirmPasswordHere.
  ///
  /// In en, this message translates to:
  /// **'Enter your password confirmation here'**
  String get enterConfirmPasswordHere;

  /// No description provided for @enterDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Enter date of birth'**
  String get enterDateOfBirth;

  /// No description provided for @enterEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or phone number'**
  String get enterEmailOrPhone;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get enterFullName;

  /// No description provided for @enterNewPasswordHere.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password here'**
  String get enterNewPasswordHere;

  /// No description provided for @enterNumberOfDays.
  ///
  /// In en, this message translates to:
  /// **'Enter number of days'**
  String get enterNumberOfDays;

  /// No description provided for @enterNumberOfHours.
  ///
  /// In en, this message translates to:
  /// **'Enter number of hours'**
  String get enterNumberOfHours;

  /// No description provided for @enterNumberOfMeals.
  ///
  /// In en, this message translates to:
  /// **'Enter number of meals'**
  String get enterNumberOfMeals;

  /// No description provided for @enterOccupation.
  ///
  /// In en, this message translates to:
  /// **'Enter occupation'**
  String get enterOccupation;

  /// No description provided for @enterPasswordHere.
  ///
  /// In en, this message translates to:
  /// **'Enter your password here'**
  String get enterPasswordHere;

  /// No description provided for @enterSuggestedWeightForWorkout.
  ///
  /// In en, this message translates to:
  /// **'Enter your suggested weight for this workout'**
  String get enterSuggestedWeightForWorkout;

  /// No description provided for @enterThighCircumference.
  ///
  /// In en, this message translates to:
  /// **'Enter thigh circumference'**
  String get enterThighCircumference;

  /// No description provided for @enterWaistCircumference.
  ///
  /// In en, this message translates to:
  /// **'Enter waist circumference'**
  String get enterWaistCircumference;

  /// No description provided for @enterWaterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter water amount'**
  String get enterWaterAmount;

  /// No description provided for @enterYourAge.
  ///
  /// In en, this message translates to:
  /// **'Enter your age'**
  String get enterYourAge;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @enterYourEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or phone number'**
  String get enterYourEmailOrPhone;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @enterYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterYourPhone;

  /// No description provided for @enterYourUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get enterYourUsername;

  /// No description provided for @equipmentMachines.
  ///
  /// In en, this message translates to:
  /// **'Machines'**
  String get equipmentMachines;

  /// No description provided for @errorGeneral.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneral;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Server error, please try again'**
  String get errorServer;

  /// No description provided for @errorTryAgain.
  ///
  /// In en, this message translates to:
  /// **'An error occurred, please try again'**
  String get errorTryAgain;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Session expired, please login again'**
  String get errorUnauthorized;

  /// No description provided for @evaluateClass.
  ///
  /// In en, this message translates to:
  /// **'Evaluate class'**
  String get evaluateClass;

  /// No description provided for @classSatisfactionQuestion.
  ///
  /// In en, this message translates to:
  /// **'How satisfied are you with the class?'**
  String get classSatisfactionQuestion;

  /// No description provided for @evaluationLinkUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Evaluation link is currently unavailable'**
  String get evaluationLinkUnavailable;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @exampleOneYearThreeMonths.
  ///
  /// In en, this message translates to:
  /// **'Example: one year and three months'**
  String get exampleOneYearThreeMonths;

  /// No description provided for @exampleWeightsCardioSwimming.
  ///
  /// In en, this message translates to:
  /// **'Example: weights, cardio, swimming'**
  String get exampleWeightsCardioSwimming;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @expiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon'**
  String get expiringSoon;

  /// No description provided for @expiringSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon'**
  String get expiringSubscriptions;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @familyAddMembersHint.
  ///
  /// In en, this message translates to:
  /// **'Start by adding your family members to follow them from the app'**
  String get familyAddMembersHint;

  /// No description provided for @familyMembers.
  ///
  /// In en, this message translates to:
  /// **'Family members'**
  String get familyMembers;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get faq;

  /// No description provided for @favoriteWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Favorite workouts'**
  String get favoriteWorkouts;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @flexibility.
  ///
  /// In en, this message translates to:
  /// **'Flexibility'**
  String get flexibility;

  /// No description provided for @followDietQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you follow a diet?'**
  String get followDietQuestion;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email and we will send a verification code to your email'**
  String get forgotPasswordEmailHint;

  /// No description provided for @forgotPasswordEmailOrPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email or phone number to send the verification code'**
  String get forgotPasswordEmailOrPhoneHint;

  /// No description provided for @freeWeights.
  ///
  /// In en, this message translates to:
  /// **'Free weights'**
  String get freeWeights;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @genderBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get genderBoth;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @generalWorkoutInstructions.
  ///
  /// In en, this message translates to:
  /// **'General workout instructions'**
  String get generalWorkoutInstructions;

  /// No description provided for @generateNewQrCode.
  ///
  /// In en, this message translates to:
  /// **'Generate new QR code'**
  String get generateNewQrCode;

  /// No description provided for @getToKnowGloryGym.
  ///
  /// In en, this message translates to:
  /// **'Get to know Glory Gym'**
  String get getToKnowGloryGym;

  /// No description provided for @goalBodyToning.
  ///
  /// In en, this message translates to:
  /// **'Body toning'**
  String get goalBodyToning;

  /// No description provided for @goalFatLoss.
  ///
  /// In en, this message translates to:
  /// **'Fat loss'**
  String get goalFatLoss;

  /// No description provided for @goalImproveFitness.
  ///
  /// In en, this message translates to:
  /// **'Improve fitness'**
  String get goalImproveFitness;

  /// No description provided for @goalIncreaseStrength.
  ///
  /// In en, this message translates to:
  /// **'Increase strength'**
  String get goalIncreaseStrength;

  /// No description provided for @goalInjuryRehab.
  ///
  /// In en, this message translates to:
  /// **'Rehabilitation after injury'**
  String get goalInjuryRehab;

  /// No description provided for @goalMuscleGain.
  ///
  /// In en, this message translates to:
  /// **'Muscle gain'**
  String get goalMuscleGain;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @groupClass.
  ///
  /// In en, this message translates to:
  /// **'Group class'**
  String get groupClass;

  /// No description provided for @groupClasses.
  ///
  /// In en, this message translates to:
  /// **'Group classes'**
  String get groupClasses;

  /// No description provided for @individualSessions.
  ///
  /// In en, this message translates to:
  /// **'Individual sessions'**
  String get individualSessions;

  /// No description provided for @gym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get gym;

  /// No description provided for @gymCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Gym check-in'**
  String get gymCheckIn;

  /// No description provided for @gymCheckInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Gym check-in successful!'**
  String get gymCheckInSuccess;

  /// No description provided for @hadSurgeryQuestion.
  ///
  /// In en, this message translates to:
  /// **'Have you had any surgery?'**
  String get hadSurgeryQuestion;

  /// No description provided for @haveChronicDiseaseQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you have any chronic illness? (diabetes, blood pressure, heart…)'**
  String get haveChronicDiseaseQuestion;

  /// No description provided for @haveInjuriesQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you have any current or past injuries?'**
  String get haveInjuriesQuestion;

  /// No description provided for @healthHistory.
  ///
  /// In en, this message translates to:
  /// **'Health history'**
  String get healthHistory;

  /// No description provided for @healthStatus.
  ///
  /// In en, this message translates to:
  /// **'Health status'**
  String get healthStatus;

  /// No description provided for @healthyNutritionTips.
  ///
  /// In en, this message translates to:
  /// **'Healthy nutrition tips'**
  String get healthyNutritionTips;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get hour;

  /// No description provided for @howLongHaveYouBeenTraining.
  ///
  /// In en, this message translates to:
  /// **'How long have you been training?'**
  String get howLongHaveYouBeenTraining;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @instagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @instructorName.
  ///
  /// In en, this message translates to:
  /// **'Instructor name'**
  String get instructorName;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get invalidPhone;

  /// No description provided for @invalidVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code, please try again'**
  String get invalidVerificationCode;

  /// No description provided for @issuedBy.
  ///
  /// In en, this message translates to:
  /// **'Issued by'**
  String get issuedBy;

  /// No description provided for @issuedByAhmedHossam.
  ///
  /// In en, this message translates to:
  /// **'Issued by: Ahmed Hossam'**
  String get issuedByAhmedHossam;

  /// No description provided for @keepPasswordSafeHint.
  ///
  /// In en, this message translates to:
  /// **'Try to keep your password private to avoid account and data theft'**
  String get keepPasswordSafeHint;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @lifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get lifestyle;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @liter.
  ///
  /// In en, this message translates to:
  /// **'Liter'**
  String get liter;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginEmailOrPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email or phone number along with your password to access your account.'**
  String get loginEmailOrPhoneHint;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get loginSubtitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @maritalDivorced.
  ///
  /// In en, this message translates to:
  /// **'Divorced'**
  String get maritalDivorced;

  /// No description provided for @maritalMarried.
  ///
  /// In en, this message translates to:
  /// **'Married'**
  String get maritalMarried;

  /// No description provided for @maritalSingle.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get maritalSingle;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital status'**
  String get maritalStatus;

  /// No description provided for @maritalWidowed.
  ///
  /// In en, this message translates to:
  /// **'Widowed'**
  String get maritalWidowed;

  /// No description provided for @maxCharsValidation.
  ///
  /// In en, this message translates to:
  /// **'Must not exceed {max} characters'**
  String maxCharsValidation(String max);

  /// No description provided for @meal.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get meal;

  /// No description provided for @measurements.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get measurements;

  /// No description provided for @measurementsCmOptionalPhotos.
  ///
  /// In en, this message translates to:
  /// **'Current measurements are in centimeters. Photos are optional.'**
  String get measurementsCmOptionalPhotos;

  /// No description provided for @memberAdded.
  ///
  /// In en, this message translates to:
  /// **'Member added successfully'**
  String get memberAdded;

  /// No description provided for @memberDeleted.
  ///
  /// In en, this message translates to:
  /// **'Member deleted successfully'**
  String get memberDeleted;

  /// No description provided for @memberDetails.
  ///
  /// In en, this message translates to:
  /// **'Member Details'**
  String get memberDetails;

  /// No description provided for @memberName.
  ///
  /// In en, this message translates to:
  /// **'Member Name'**
  String get memberName;

  /// No description provided for @memberUpdated.
  ///
  /// In en, this message translates to:
  /// **'Member updated successfully'**
  String get memberUpdated;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @mentionDurationAndPreviousProgram.
  ///
  /// In en, this message translates to:
  /// **'Mention the duration and previous program'**
  String get mentionDurationAndPreviousProgram;

  /// No description provided for @mentionInjuryLocationAndDate.
  ///
  /// In en, this message translates to:
  /// **'Mention the injury location and date'**
  String get mentionInjuryLocationAndDate;

  /// No description provided for @minCharsValidation.
  ///
  /// In en, this message translates to:
  /// **'Must be at least {min} characters'**
  String minCharsValidation(String min);

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutes(int count);

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumber;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @multiSelect.
  ///
  /// In en, this message translates to:
  /// **'Multiple selection'**
  String get multiSelect;

  /// No description provided for @multipleGoalsAllowed.
  ///
  /// In en, this message translates to:
  /// **'You can select more than one goal.'**
  String get multipleGoalsAllowed;

  /// No description provided for @muscleMass.
  ///
  /// In en, this message translates to:
  /// **'Muscle mass'**
  String get muscleMass;

  /// No description provided for @mustContainDigit.
  ///
  /// In en, this message translates to:
  /// **'Must contain at least one number'**
  String get mustContainDigit;

  /// No description provided for @mustContainLetter.
  ///
  /// In en, this message translates to:
  /// **'Must contain an uppercase or lowercase letter'**
  String get mustContainLetter;

  /// No description provided for @mySubscriptions.
  ///
  /// In en, this message translates to:
  /// **'My subscriptions'**
  String get mySubscriptions;

  /// No description provided for @myWorkouts.
  ///
  /// In en, this message translates to:
  /// **'My workouts'**
  String get myWorkouts;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @natureOfWork.
  ///
  /// In en, this message translates to:
  /// **'Nature of work'**
  String get natureOfWork;

  /// No description provided for @needHelpWithWorkoutsNutritionSubscription.
  ///
  /// In en, this message translates to:
  /// **'Do you need help with workouts, nutrition, or your subscription?'**
  String get needHelpWithWorkoutsNutritionSubscription;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @newPasswordCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'New password created successfully!'**
  String get newPasswordCreatedSuccess;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @noAttendance.
  ///
  /// In en, this message translates to:
  /// **'No attendance records'**
  String get noAttendance;

  /// No description provided for @noBookingsCurrently.
  ///
  /// In en, this message translates to:
  /// **'No bookings currently'**
  String get noBookingsCurrently;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @noDiseases.
  ///
  /// In en, this message translates to:
  /// **'No diseases'**
  String get noDiseases;

  /// No description provided for @noFamilyMembers.
  ///
  /// In en, this message translates to:
  /// **'No family members'**
  String get noFamilyMembers;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternet;

  /// No description provided for @noMembers.
  ///
  /// In en, this message translates to:
  /// **'No members found'**
  String get noMembers;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @noWorkouts.
  ///
  /// In en, this message translates to:
  /// **'No workouts found'**
  String get noWorkouts;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsAlt.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsAlt;

  /// No description provided for @nutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutrition;

  /// No description provided for @nutritionEating.
  ///
  /// In en, this message translates to:
  /// **'Eating'**
  String get nutritionEating;

  /// No description provided for @nutritionShort.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutritionShort;

  /// No description provided for @nutritionShortAlt.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutritionShortAlt;

  /// No description provided for @nutritionWaterTip.
  ///
  /// In en, this message translates to:
  /// **'Drink 2–3 liters of water daily and reduce refined sugars.'**
  String get nutritionWaterTip;

  /// No description provided for @occupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get occupation;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @okAlt.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okAlt;

  /// No description provided for @onboardingCoachReviewMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you. The coach will review your data and prepare a suitable training and nutrition plan for you.'**
  String get onboardingCoachReviewMessage;

  /// No description provided for @onboardingTeamReviewMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you. The Glory Gym team will review your data and prepare the best experience for you.'**
  String get onboardingTeamReviewMessage;

  /// No description provided for @otherGoal.
  ///
  /// In en, this message translates to:
  /// **'Other goal'**
  String get otherGoal;

  /// No description provided for @otpSentToEmail.
  ///
  /// In en, this message translates to:
  /// **'A 6-digit code has been sent to your email '**
  String get otpSentToEmail;

  /// No description provided for @ourGoals.
  ///
  /// In en, this message translates to:
  /// **'Our goals'**
  String get ourGoals;

  /// No description provided for @ourValues.
  ///
  /// In en, this message translates to:
  /// **'Our values'**
  String get ourValues;

  /// No description provided for @ourVision.
  ///
  /// In en, this message translates to:
  /// **'Our vision'**
  String get ourVision;

  /// No description provided for @package.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get package;

  /// No description provided for @packageName.
  ///
  /// In en, this message translates to:
  /// **'Package name'**
  String get packageName;

  /// No description provided for @packageType.
  ///
  /// In en, this message translates to:
  /// **'Package type'**
  String get packageType;

  /// No description provided for @parqQuestionnaireIntro.
  ///
  /// In en, this message translates to:
  /// **'Physical Activity Readiness Questionnaire (PAR-Q). Please answer accurately.'**
  String get parqQuestionnaireIntro;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHasDigit.
  ///
  /// In en, this message translates to:
  /// **'Contains at least one number'**
  String get passwordHasDigit;

  /// No description provided for @passwordHasLetter.
  ///
  /// In en, this message translates to:
  /// **'Contains an uppercase or lowercase letter'**
  String get passwordHasLetter;

  /// No description provided for @passwordMinEightChars.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinEightChars;

  /// No description provided for @passwordMinEightCharsHint.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordMinEightCharsHint;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords match'**
  String get passwordsMatch;

  /// No description provided for @passwordsNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsNotMatch;

  /// No description provided for @performanceProteinTip.
  ///
  /// In en, this message translates to:
  /// **'To improve your performance: focus on protein after your workout, '**
  String get performanceProteinTip;

  /// No description provided for @personalData.
  ///
  /// In en, this message translates to:
  /// **'Personal data'**
  String get personalData;

  /// No description provided for @personalTraining.
  ///
  /// In en, this message translates to:
  /// **'Personal training'**
  String get personalTraining;

  /// No description provided for @phaseFour.
  ///
  /// In en, this message translates to:
  /// **'Phase four'**
  String get phaseFour;

  /// No description provided for @phaseNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phase {stepNumber}'**
  String phaseNumberLabel(String stepNumber);

  /// No description provided for @phaseOne.
  ///
  /// In en, this message translates to:
  /// **'Phase one'**
  String get phaseOne;

  /// No description provided for @phaseThree.
  ///
  /// In en, this message translates to:
  /// **'Phase three'**
  String get phaseThree;

  /// No description provided for @phaseTwo.
  ///
  /// In en, this message translates to:
  /// **'Phase two'**
  String get phaseTwo;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number *'**
  String get phoneRequired;

  /// No description provided for @physicalEffort.
  ///
  /// In en, this message translates to:
  /// **'Physical effort'**
  String get physicalEffort;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @pleaseEnterEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email or phone number'**
  String get pleaseEnterEmailOrPhone;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @preferGymOrHomeWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Do you prefer gym or home workouts?'**
  String get preferGymOrHomeWorkouts;

  /// No description provided for @preferredWorkoutTime.
  ///
  /// In en, this message translates to:
  /// **'Preferred workout time'**
  String get preferredWorkoutTime;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @previousWeight.
  ///
  /// In en, this message translates to:
  /// **'Previous weight'**
  String get previousWeight;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @program.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get program;

  /// No description provided for @questionnaireSent.
  ///
  /// In en, this message translates to:
  /// **'Questionnaire submitted'**
  String get questionnaireSent;

  /// No description provided for @questionnaireStepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {currentStep} of {totalSteps}'**
  String questionnaireStepProgress(String currentStep, String totalSteps);

  /// No description provided for @quickLoginWith.
  ///
  /// In en, this message translates to:
  /// **'Quick login with'**
  String get quickLoginWith;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @recentBookings.
  ///
  /// In en, this message translates to:
  /// **'Recent bookings'**
  String get recentBookings;

  /// No description provided for @recoveryFactorsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Factors affecting recovery and results.'**
  String get recoveryFactorsSubtitle;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @relationBrother.
  ///
  /// In en, this message translates to:
  /// **'Brother'**
  String get relationBrother;

  /// No description provided for @relationDaughter.
  ///
  /// In en, this message translates to:
  /// **'Daughter'**
  String get relationDaughter;

  /// No description provided for @relationFather.
  ///
  /// In en, this message translates to:
  /// **'Father'**
  String get relationFather;

  /// No description provided for @relationHusband.
  ///
  /// In en, this message translates to:
  /// **'Husband'**
  String get relationHusband;

  /// No description provided for @relationMother.
  ///
  /// In en, this message translates to:
  /// **'Mother'**
  String get relationMother;

  /// No description provided for @relationSister.
  ///
  /// In en, this message translates to:
  /// **'Sister'**
  String get relationSister;

  /// No description provided for @relationSon.
  ///
  /// In en, this message translates to:
  /// **'Son'**
  String get relationSon;

  /// No description provided for @relationWife.
  ///
  /// In en, this message translates to:
  /// **'Wife'**
  String get relationWife;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// No description provided for @remainingDaysCount.
  ///
  /// In en, this message translates to:
  /// **'Remaining days'**
  String get remainingDaysCount;

  /// No description provided for @routeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Route not found: {path}'**
  String routeNotFound(String path);

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'TRAIN  ·  GROW  ·  DOMINATE'**
  String get splashTagline;

  /// No description provided for @renewSubscription.
  ///
  /// In en, this message translates to:
  /// **'Renew Subscription'**
  String get renewSubscription;

  /// No description provided for @requestOtp.
  ///
  /// In en, this message translates to:
  /// **'Request OTP'**
  String get requestOtp;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @sampleDateJune2026.
  ///
  /// In en, this message translates to:
  /// **'10 June 2026'**
  String get sampleDateJune2026;

  /// No description provided for @sampleDateMay2026.
  ///
  /// In en, this message translates to:
  /// **'1 May 2026'**
  String get sampleDateMay2026;

  /// No description provided for @sandyAi.
  ///
  /// In en, this message translates to:
  /// **'Sandy AI'**
  String get sandyAi;

  /// No description provided for @sandyAskMeHint.
  ///
  /// In en, this message translates to:
  /// **'Ask me about workouts, nutrition, or any question about your subscription.'**
  String get sandyAskMeHint;

  /// No description provided for @sandyPackagesCompareHint.
  ///
  /// In en, this message translates to:
  /// **'If you need to compare packages or renew your subscription, let me know.'**
  String get sandyPackagesCompareHint;

  /// No description provided for @sandyPlanOfferMessage.
  ///
  /// In en, this message translates to:
  /// **'I can prepare a simple plan based on your goal.'**
  String get sandyPlanOfferMessage;

  /// No description provided for @sandyThanksForQuestion.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your question! I will review your request and reply with the best recommendation for you.'**
  String get sandyThanksForQuestion;

  /// No description provided for @sandyThreeDayProgramAdvice.
  ///
  /// In en, this message translates to:
  /// **'Great! I recommend a 3-day per week program: '**
  String get sandyThreeDayProgramAdvice;

  /// No description provided for @sandyThreeDaySplitExample.
  ///
  /// In en, this message translates to:
  /// **'One day for chest and triceps, one for back and biceps, and one for legs. '**
  String get sandyThreeDaySplitExample;

  /// No description provided for @sandyWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m Sandy, your smart assistant at Glory Gym. '**
  String get sandyWelcomeMessage;

  /// No description provided for @sandyChatHistory.
  ///
  /// In en, this message translates to:
  /// **'Chat history'**
  String get sandyChatHistory;

  /// No description provided for @sandyNewChat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get sandyNewChat;

  /// No description provided for @sandyRenameConversation.
  ///
  /// In en, this message translates to:
  /// **'Rename conversation'**
  String get sandyRenameConversation;

  /// No description provided for @sandyDeleteConversation.
  ///
  /// In en, this message translates to:
  /// **'Delete conversation'**
  String get sandyDeleteConversation;

  /// No description provided for @sandyDeleteConversationConfirm.
  ///
  /// In en, this message translates to:
  /// **'This conversation will be permanently deleted.'**
  String get sandyDeleteConversationConfirm;

  /// No description provided for @sandyConversationTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Conversation title'**
  String get sandyConversationTitleHint;

  /// No description provided for @sandyNoConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get sandyNoConversations;

  /// No description provided for @sandyNoConversationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Start chatting with Sandy and your conversations will appear here.'**
  String get sandyNoConversationsDescription;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @selectRelationship.
  ///
  /// In en, this message translates to:
  /// **'Select relationship'**
  String get selectRelationship;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get selectType;

  /// No description provided for @sendCodeToPhone.
  ///
  /// In en, this message translates to:
  /// **'Send the code to your phone number'**
  String get sendCodeToPhone;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @sizeMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Size measurements'**
  String get sizeMeasurements;

  /// No description provided for @sleepHoursCount.
  ///
  /// In en, this message translates to:
  /// **'Hours of sleep'**
  String get sleepHoursCount;

  /// No description provided for @socialMediaPlatforms.
  ///
  /// In en, this message translates to:
  /// **'Social media platforms'**
  String get socialMediaPlatforms;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @strength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get strength;

  /// No description provided for @stressLevel.
  ///
  /// In en, this message translates to:
  /// **'Stress level'**
  String get stressLevel;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @submitData.
  ///
  /// In en, this message translates to:
  /// **'Submit data'**
  String get submitData;

  /// No description provided for @submitQuestionnaire.
  ///
  /// In en, this message translates to:
  /// **'Submit questionnaire'**
  String get submitQuestionnaire;

  /// No description provided for @subscriberBasicInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Basic information about the subscriber.'**
  String get subscriberBasicInfoSubtitle;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @subscriptionAdded.
  ///
  /// In en, this message translates to:
  /// **'Subscription added successfully'**
  String get subscriptionAdded;

  /// No description provided for @subscriptionDaysRemainingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Glory Gym family! We would like to let you know that you have {days} days remaining on your gym subscription'**
  String subscriptionDaysRemainingWelcome(String days);

  /// No description provided for @subscriptionGoal.
  ///
  /// In en, this message translates to:
  /// **'Subscription goal'**
  String get subscriptionGoal;

  /// No description provided for @subscriptionInquiry.
  ///
  /// In en, this message translates to:
  /// **'Subscription inquiry'**
  String get subscriptionInquiry;

  /// No description provided for @subscriptionPlan.
  ///
  /// In en, this message translates to:
  /// **'Subscription Plan'**
  String get subscriptionPlan;

  /// No description provided for @subscriptionQuestionnaire.
  ///
  /// In en, this message translates to:
  /// **'Subscription questionnaire'**
  String get subscriptionQuestionnaire;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @successfully.
  ///
  /// In en, this message translates to:
  /// **'Successfully'**
  String get successfully;

  /// No description provided for @suggestWorkoutProgram.
  ///
  /// In en, this message translates to:
  /// **'Suggest a workout program for me'**
  String get suggestWorkoutProgram;

  /// No description provided for @suggestedWeight.
  ///
  /// In en, this message translates to:
  /// **'Suggested weight'**
  String get suggestedWeight;

  /// No description provided for @surgeryDetails.
  ///
  /// In en, this message translates to:
  /// **'Surgery details'**
  String get surgeryDetails;

  /// No description provided for @takeMedicationsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you take any medications regularly?'**
  String get takeMedicationsQuestion;

  /// No description provided for @telephone.
  ///
  /// In en, this message translates to:
  /// **'Telephone'**
  String get telephone;

  /// No description provided for @tempLoadingAnswer.
  ///
  /// In en, this message translates to:
  /// **'Temporary loading answer'**
  String get tempLoadingAnswer;

  /// No description provided for @tempLoadingQuestion.
  ///
  /// In en, this message translates to:
  /// **'Temporary loading question'**
  String get tempLoadingQuestion;

  /// No description provided for @tenKilosLabel.
  ///
  /// In en, this message translates to:
  /// **'10 kg'**
  String get tenKilosLabel;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get termsAndConditions;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get termsOfService;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you'**
  String get thankYou;

  /// No description provided for @thanksForContactingUs.
  ///
  /// In en, this message translates to:
  /// **'Thank you for contacting us'**
  String get thanksForContactingUs;

  /// No description provided for @thighCircumference.
  ///
  /// In en, this message translates to:
  /// **'Thigh circumference'**
  String get thighCircumference;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @toDetermineTrainingSchedule.
  ///
  /// In en, this message translates to:
  /// **'To determine the appropriate training schedule for you.'**
  String get toDetermineTrainingSchedule;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @todayAttendance.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Attendance'**
  String get todayAttendance;

  /// No description provided for @totalMembers.
  ///
  /// In en, this message translates to:
  /// **'Total Members'**
  String get totalMembers;

  /// No description provided for @trainedWithPersonalCoachQuestion.
  ///
  /// In en, this message translates to:
  /// **'Have you ever trained with a personal coach?'**
  String get trainedWithPersonalCoachQuestion;

  /// No description provided for @trainingCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Training check-in'**
  String get trainingCheckIn;

  /// No description provided for @trainingEvaluation.
  ///
  /// In en, this message translates to:
  /// **'Training evaluation'**
  String get trainingEvaluation;

  /// No description provided for @trainingInfo.
  ///
  /// In en, this message translates to:
  /// **'Training information'**
  String get trainingInfo;

  /// No description provided for @twitter.
  ///
  /// In en, this message translates to:
  /// **'Twitter'**
  String get twitter;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @unitCm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get unitCm;

  /// No description provided for @upcomingWorkout.
  ///
  /// In en, this message translates to:
  /// **'Upcoming workout'**
  String get upcomingWorkout;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @useSupplementsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you use dietary supplements?'**
  String get useSupplementsQuestion;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get verificationCode;

  /// No description provided for @verificationCodeResent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent again'**
  String get verificationCodeResent;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @viewPackagesInSettingsHint.
  ///
  /// In en, this message translates to:
  /// **'You can view your packages in the \"My subscriptions\" section in Settings. '**
  String get viewPackagesInSettingsHint;

  /// No description provided for @visceralFatLevel.
  ///
  /// In en, this message translates to:
  /// **'Visceral fat level'**
  String get visceralFatLevel;

  /// No description provided for @waistCircumference.
  ///
  /// In en, this message translates to:
  /// **'Waist circumference'**
  String get waistCircumference;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @weightKilosLabel.
  ///
  /// In en, this message translates to:
  /// **'{weight} kg'**
  String weightKilosLabel(String weight);

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @welcomeBackAlt.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBackAlt;

  /// No description provided for @welcomeToGloryGym.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Glory Gym'**
  String get welcomeToGloryGym;

  /// No description provided for @whatDoYouWantToAchieve.
  ///
  /// In en, this message translates to:
  /// **'What are you looking to achieve?'**
  String get whatDoYouWantToAchieve;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @workout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workout;

  /// No description provided for @workoutDaysPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Number of workout days per week'**
  String get workoutDaysPerWeek;

  /// No description provided for @workoutRepetition.
  ///
  /// In en, this message translates to:
  /// **'Repetition'**
  String get workoutRepetition;

  /// No description provided for @workoutSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get workoutSet;

  /// No description provided for @workoutDetails.
  ///
  /// In en, this message translates to:
  /// **'Workout details'**
  String get workoutDetails;

  /// No description provided for @workoutInProgress.
  ///
  /// In en, this message translates to:
  /// **'Workout in progress'**
  String get workoutInProgress;

  /// No description provided for @workoutName.
  ///
  /// In en, this message translates to:
  /// **'Workout Name'**
  String get workoutName;

  /// No description provided for @workoutType.
  ///
  /// In en, this message translates to:
  /// **'Workout type'**
  String get workoutType;

  /// No description provided for @workoutTypes.
  ///
  /// In en, this message translates to:
  /// **'Workout types'**
  String get workoutTypes;

  /// No description provided for @workouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get workouts;

  /// No description provided for @writeAdditionalGoalIfAny.
  ///
  /// In en, this message translates to:
  /// **'Write an additional goal if any'**
  String get writeAdditionalGoalIfAny;

  /// No description provided for @writeComplaintOrSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Write your complaint or suggestion here...'**
  String get writeComplaintOrSuggestion;

  /// No description provided for @writeMessageToSandy.
  ///
  /// In en, this message translates to:
  /// **'Write your message to Sandy AI'**
  String get writeMessageToSandy;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @yourSmartSportsAssistant.
  ///
  /// In en, this message translates to:
  /// **'Your smart sports assistant'**
  String get yourSmartSportsAssistant;

  /// No description provided for @yourWeight.
  ///
  /// In en, this message translates to:
  /// **'Your weight'**
  String get yourWeight;

  /// No description provided for @conjunctionAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get conjunctionAnd;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get notificationsEnabled;

  /// No description provided for @notificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get notificationsDisabled;

  /// No description provided for @coachChat.
  ///
  /// In en, this message translates to:
  /// **'Your Captain With You'**
  String get coachChat;

  /// No description provided for @coachChatNotAssignedTitle.
  ///
  /// In en, this message translates to:
  /// **'No coach assigned yet'**
  String get coachChatNotAssignedTitle;

  /// No description provided for @coachChatNotAssignedDescription.
  ///
  /// In en, this message translates to:
  /// **'Your coach will be assigned by the gym team. Once assigned, you can chat with them here.'**
  String get coachChatNotAssignedDescription;

  /// No description provided for @coachChatWithInstructor.
  ///
  /// In en, this message translates to:
  /// **'Your assigned coach'**
  String get coachChatWithInstructor;

  /// No description provided for @coachChatTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get coachChatTypeMessage;

  /// No description provided for @coachChatStartConversation.
  ///
  /// In en, this message translates to:
  /// **'Send a message to start the conversation'**
  String get coachChatStartConversation;

  /// No description provided for @contactYourCoach.
  ///
  /// In en, this message translates to:
  /// **'Contact your coach'**
  String get contactYourCoach;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get notAvailable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
