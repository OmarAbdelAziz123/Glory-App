abstract final class Endpoints {
  static const String baseUrl = 'https://api.glorygym.com/v1';

  // ── Auth ──────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // ── Members ──────────────────────────────────────────
  static const String members = '/members';
  static String memberById(String id) => '/members/$id';

  // ── Subscriptions ────────────────────────────────────
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

  // ── Profile ───────────────────────────────────────────
  static const String profile = '/profile';
  static const String updateProfile = '/profile/update';
  static const String changePassword = '/profile/change-password';
}
