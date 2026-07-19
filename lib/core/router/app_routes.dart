abstract final class AppRoutes {
  // ── Auth ──────────────────────────────────────────────
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String createPassword = '/create-password';
  static const String forgotPassword = '/forgot-password';

  // ── Main (Shell) ──────────────────────────────────────
  static const String home = '/home';
  static const String bookings = '/bookings';
  static const String gloryAi = '/glory-ai';
  static const String workouts = '/workouts';
  static const String settings = '/settings';

  // ── Workouts ─────────────────────────────────────────
  static const String workoutDetail = '/workouts/:id';

  // ── Profile ───────────────────────────────────────────
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String editEmail = '/profile/edit-email';

  // ── Body Composition ──────────────────────────────────
  static const String bodyComposition = '/body-composition';
  static const String sizeMeasurements = '/body-composition/measurements';

  // ── Subscriptions ────────────────────────────────────
  static const String subscriptions = '/subscriptions';

  // ── Family ────────────────────────────────────────────
  static const String family = '/family';
  static const String addFamilyMember = '/family/add';

  // ── Notifications ─────────────────────────────────────
  static const String notifications = '/notifications';

  // ── About ─────────────────────────────────────────────
  static const String about = '/about';
  static const String whoWeAre = '/about/who-we-are';
  static const String simpleContent = '/about/content';
  static const String faq = '/about/faq';
  static const String complaints = '/about/complaints';

  // ── Class Evaluation ──────────────────────────────────
  static const String classEvaluation = '/class-evaluation';

  // ── Add Weight ────────────────────────────────────────
  static const String addWeight = '/add-weight';
}
