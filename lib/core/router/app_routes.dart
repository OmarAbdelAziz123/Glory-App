abstract final class AppRoutes {
  // ── Auth ──────────────────────────────────────────────
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String createPassword = '/create-password';
  static const String forgotPassword = '/forgot-password';
  static const String subscriptionQuestionnaire = '/subscription-questionnaire';

  // ── Main (Shell) ──────────────────────────────────────
  static const String home = '/home';
  static const String bookings = '/bookings';
  static const String gloryAi = '/glory-ai';
  static const String workouts = '/workouts';
  static const String settings = '/settings';

  // ── Workouts ─────────────────────────────────────────
  static const String workoutDetail = '/workouts/:id';
  static const String addWeight = '/workouts/:id/add-weight';

  // ── Profile ───────────────────────────────────────────
  static const String profile = '/profile';

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
}
