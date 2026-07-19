// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Glory Gym';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get update => 'Update';

  @override
  String get submit => 'Submit';

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get search => 'Search';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get noData => 'No data available';

  @override
  String get noInternet => 'No internet connection';

  @override
  String get errorGeneral => 'Something went wrong';

  @override
  String get errorServer => 'Server error, please try again';

  @override
  String get errorUnauthorized => 'Session expired, please login again';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get phone => 'Phone Number';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get loginSubtitle => 'Sign in to continue';

  @override
  String get createAccount => 'Create Account';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Register';

  @override
  String get home => 'Home';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get totalMembers => 'Total Members';

  @override
  String get activeSubscriptions => 'Active Subscriptions';

  @override
  String get todayAttendance => 'Today\'s Attendance';

  @override
  String get expiringSubscriptions => 'Expiring Soon';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get members => 'Members';

  @override
  String get addMember => 'Add Member';

  @override
  String get editMember => 'Edit Member';

  @override
  String get deleteMember => 'Delete Member';

  @override
  String get memberName => 'Member Name';

  @override
  String get memberDetails => 'Member Details';

  @override
  String get noMembers => 'No members found';

  @override
  String get memberAdded => 'Member added successfully';

  @override
  String get memberUpdated => 'Member updated successfully';

  @override
  String get memberDeleted => 'Member deleted successfully';

  @override
  String get deleteConfirmMember =>
      'Are you sure you want to delete this member?';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get addSubscription => 'Add Subscription';

  @override
  String get subscriptionPlan => 'Subscription Plan';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get active => 'Active';

  @override
  String get expired => 'Expired';

  @override
  String get expiringSoon => 'Expiring Soon';

  @override
  String daysLeft(int count) {
    return '$count days left';
  }

  @override
  String get subscriptionAdded => 'Subscription added successfully';

  @override
  String get renewSubscription => 'Renew Subscription';

  @override
  String get attendance => 'Attendance';

  @override
  String get checkIn => 'Check In';

  @override
  String get checkOut => 'Check Out';

  @override
  String get checkedIn => 'Checked In';

  @override
  String get checkedOut => 'Checked Out';

  @override
  String get attendanceHistory => 'Attendance History';

  @override
  String get noAttendance => 'No attendance records';

  @override
  String attendanceAt(String time) {
    return 'at $time';
  }

  @override
  String get workouts => 'Workouts';

  @override
  String get addWorkout => 'Add Workout';

  @override
  String get workoutName => 'Workout Name';

  @override
  String get duration => 'Duration';

  @override
  String minutes(int count) {
    return '$count min';
  }

  @override
  String get noWorkouts => 'No workouts found';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get arabic => 'Arabic';

  @override
  String get english => 'English';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get notifications => 'Notifications';

  @override
  String get changePassword => 'Change Password';

  @override
  String get aboutApp => 'About App';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get passwordsNotMatch => 'Passwords do not match';

  @override
  String get invalidPhone => 'Please enter a valid phone number';
}
