abstract final class Endpoints {
  static const String baseUrl = 'https://api.gloryfitclub.com';

  // ── Mobile Auth ───────────────────────────────────────
  static const String register = '/mobile/auth/register';
  static const String verifyOtp = '/mobile/auth/verify-otp';
  static const String resendOtp = '/mobile/auth/resend-otp';
  static const String completeRegistration = '/mobile/auth/complete-registration';
  static const String forgotPassword = '/mobile/auth/forgot-password';
  static const String resetPassword = '/mobile/auth/reset-password';
  static const String login = '/mobile/auth/login';
  static const String mobileProfile = '/mobile/profile';
  static const String mobileProfileNotifications =
      '/mobile/profile/notifications';
  static const String mobileProfileChangePassword =
      '/mobile/profile/change-password';
  static const String mobileProfileDeleteAccountRequest =
      '/mobile/profile/delete-account/request';
  static const String mobileProfileDeleteAccountConfirm =
      '/mobile/profile/delete-account/confirm';
  static const String logout = '/mobile/auth/logout';
  static const String refreshToken = '/mobile/auth/refresh';

  // ── Mobile Onboarding ─────────────────────────────────
  static const String onboardingStatus = '/mobile/onboarding/status';
  static const String onboarding = '/mobile/onboarding';
  static const String onboardingQuestions = '/mobile/onboarding/questions';
  static const String mobileUploads = '/mobile/uploads';

  // ── Mobile Family ─────────────────────────────────────
  static const String mobileFamily = '/mobile/family';
  static const String mobileFamilyMember = '/mobile/family/{id}';

  // ── Mobile Content ────────────────────────────────────
  static const String contentPages = '/mobile/content/pages';
  static const String contentPageByKey = '/mobile/content/pages/{key}';
  static const String contentFaqs = '/mobile/content/faqs';
  static const String contentContact = '/mobile/content/contact';
  static const String feedback = '/mobile/feedback';

  // ── Mobile Check-in ───────────────────────────────────
  static const String mobileCheckinQr = '/mobile/checkin/qr';
  static const String mobileCheckinQrStatus = '/mobile/checkin/qr/{id}';
  static const String mobileCheckinQrScan = '/mobile/checkin/qr/scan';

  // ── Mobile Bookings ───────────────────────────────────
  static const String mobileBookings = '/mobile/bookings';
  static const String mobileBookingById = '/mobile/bookings/{id}';
  static const String mobileBookingCancel = '/mobile/bookings/{id}/cancel';
  static const String mobileBookingCheckIn = '/mobile/bookings/{id}/check-in';
  static const String mobileBookingRate = '/mobile/bookings/{id}/rate';
  static const String mobileBookingRating = '/mobile/bookings/{id}/rating';

  // ── Mobile Assessment ─────────────────────────────────
  static const String mobileAssessmentQuestions =
      '/mobile/assessment/questions';

  // ── Mobile Notifications ──────────────────────────────
  static const String mobileNotifications = '/mobile/notifications';
  static const String mobileNotificationsUnreadCount =
      '/mobile/notifications/unread-count';
  static const String mobileNotificationById = '/mobile/notifications/{id}';
  static const String mobileNotificationsReadAll =
      '/mobile/notifications/read-all';

  // ── Mobile Coach Chat ─────────────────────────────────
  static const String mobileChatConversations = '/mobile/chat/conversations';
  static const String mobileChatConversationMessages =
      '/mobile/chat/conversations/{id}/messages';
  static const String mobileChatConversationRead =
      '/mobile/chat/conversations/{id}/read';
  static const String mobileChatUnreadCount = '/mobile/chat/unread-count';

  // ── Mobile Body Records ───────────────────────────────
  static const String mobileBodyRecords = '/mobile/body-records';
  static const String mobileInbody = '/mobile/inbody';
  static const String mobileInbodySummary = '/mobile/inbody/summary';
  static const String mobileInbodyTrends = '/mobile/inbody/trends';
  static const String mobileInbodyById = '/mobile/inbody/{id}';

  // ── Mobile Workouts ───────────────────────────────────
  static const String mobileWorkouts = '/mobile/workouts';
  static const String mobileWorkoutById = '/mobile/workouts/{id}';
  static const String mobileWorkoutVideos = '/mobile/workouts/{id}/videos';
  static const String mobileWorkoutWeight = '/mobile/workouts/{id}/weight';

  // ── Mobile Sandy AI ───────────────────────────────────
  static const String mobileSandyChat = '/mobile/sandy/chat';
  static const String mobileSandyChatStream = '/mobile/sandy/chat/stream';
  static const String mobileSandySuggestions = '/mobile/sandy/suggestions';
  static const String mobileSandyConversations = '/mobile/sandy/conversations';
  static const String mobileSandyConversationMessages =
      '/mobile/sandy/conversations/{id}/messages';
  static const String mobileSandyConversationById =
      '/mobile/sandy/conversations/{id}';
  static const String mobileSandyDocuments = '/mobile/sandy/documents';
  static const String mobileSandyDocumentById = '/mobile/sandy/documents/{id}';

  // ── Members ──────────────────────────────────────────
  static const String members = '/members';
  static String memberById(String id) => '/members/$id';

  // ── Subscriptions ────────────────────────────────────
  static const String mobileSubscriptions = '/mobile/subscriptions';
  static const String mobileSubscriptionsCurrent = '/mobile/subscriptions/current';
  static const String subscriptions = '/subscriptions';
  static String subscriptionById(String id) => '/subscriptions/$id';
  static String memberSubscriptions(String memberId) =>
      '/members/$memberId/subscriptions';

  // ── Workouts ─────────────────────────────────────────
  static const String workouts = '/workouts';
  static String workoutById(String id) => '/workouts/$id';

  // ── Attendance ───────────────────────────────────────
  static const String attendance = '/attendance';
  static String memberAttendance(String memberId) =>
      '/members/$memberId/attendance';

  // ── Profile (legacy) ─────────────────────────────────
  static const String profile = '/profile';
}
