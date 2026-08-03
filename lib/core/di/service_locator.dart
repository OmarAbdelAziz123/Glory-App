import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../../features/auth/data/datasources/auth_api.dart';
import '../../features/auth/data/datasources/auth_remote_api_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubits/user_profile/user_profile_cubit.dart';
import '../../features/auth/presentation/cubits/forgot_password/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubits/logout/logout_cubit.dart';
import '../../features/splash/presentation/cubits/splash_cubit.dart';
import '../../features/auth/presentation/cubits/create_password/create_password_cubit.dart';
import '../../features/auth/presentation/cubits/login/login_cubit.dart';
import '../../features/auth/presentation/cubits/otp/otp_cubit.dart';
import '../../features/auth/presentation/cubits/register/register_cubit.dart';
import '../../features/family/data/datasources/family_api.dart';
import '../../features/family/data/datasources/family_remote_api_service.dart';
import '../../features/family/data/repositories/family_repository_impl.dart';
import '../../features/family/domain/repositories/family_repository.dart';
import '../../features/family/presentation/cubits/family_form/family_form_cubit.dart';
import '../../features/family/presentation/cubits/family_list/family_list_cubit.dart';
import '../../features/about/data/datasources/content_api.dart';
import '../../features/about/data/datasources/content_remote_api_service.dart';
import '../../features/about/data/repositories/content_repository_impl.dart';
import '../../features/about/domain/repositories/content_repository.dart';
import '../../features/about/presentation/cubits/contact/contact_cubit.dart';
import '../../features/about/presentation/cubits/faqs/faqs_cubit.dart';
import '../../features/about/presentation/cubits/feedback/feedback_cubit.dart';
import '../../features/about/presentation/cubits/info_page/info_page_cubit.dart';
import '../../features/bookings/data/datasources/bookings_api.dart';
import '../../features/bookings/data/datasources/bookings_remote_api_service.dart';
import '../../features/bookings/data/repositories/bookings_repository_impl.dart';
import '../../features/bookings/domain/repositories/bookings_repository.dart';
import '../../features/bookings/presentation/cubits/bookings_list/bookings_list_cubit.dart';
import '../../features/bookings/presentation/cubits/class_evaluation/class_evaluation_cubit.dart';
import '../../features/checkin/data/datasources/checkin_api.dart';
import '../../features/checkin/data/datasources/checkin_remote_api_service.dart';
import '../../features/checkin/data/repositories/checkin_repository_impl.dart';
import '../../features/checkin/domain/repositories/checkin_repository.dart';
import '../../features/checkin/presentation/cubits/gym_qr/gym_qr_cubit.dart';
import '../../features/notifications/data/datasources/notifications_api.dart';
import '../../features/notifications/data/datasources/notifications_remote_api_service.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/presentation/cubits/notifications_list/notifications_list_cubit.dart';
import '../../features/notifications/presentation/cubits/notifications_unread/notifications_unread_cubit.dart';
import '../../features/workouts/data/datasources/workouts_api.dart';
import '../../features/workouts/data/datasources/workouts_remote_api_service.dart';
import '../../features/workouts/data/repositories/workouts_repository_impl.dart';
import '../../features/workouts/domain/repositories/workouts_repository.dart';
import '../../features/workouts/presentation/cubits/workout_detail/workout_detail_cubit.dart';
import '../../features/workouts/presentation/cubits/workouts_list/workouts_list_cubit.dart';
import '../network/api_client.dart';
import '../network/endpoints.dart';
import '../network/network_info.dart';
import '../notifications/notification_service.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  await _registerCore();
  _registerAuth();
  _registerFamily();
  _registerContent();
  _registerCheckin();
  _registerBookings();
  _registerNotifications();
  _registerWorkouts();
}

Future<void> _registerCore() async {
  tz.initializeTimeZones();

  // ── External ──────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => FlutterLocalNotificationsPlugin(),
  );

  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // ── Storage ───────────────────────────────────────────
  sl.registerLazySingleton<ILocalStorage>(() => LocalStorage(sl()));
  sl.registerLazySingleton<ISecureStorage>(() => SecureStorage(sl()));

  // ── Network ───────────────────────────────────────────
  sl.registerLazySingleton<Dio>(
    () => ApiClient.create(secureStorage: sl(), localStorage: sl()),
  );
  sl.registerLazySingleton<INetworkInfo>(() => NetworkInfo(sl()));

  // ── Notifications ─────────────────────────────────────
  sl.registerLazySingleton<INotificationService>(
    () => NotificationService(sl()),
  );
  await sl<INotificationService>().initialize();
}

void _registerAuth() {
  sl.registerLazySingleton<AuthApi>(
    () => AuthApi(sl(), baseUrl: Endpoints.baseUrl),
  );
  sl.registerLazySingleton<AuthRemoteApiService>(
    () => AuthRemoteApiService(sl(), sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<UserProfileCubit>(() => UserProfileCubit(sl()));

  sl.registerFactory<RegisterCubit>(() => RegisterCubit(sl()));
  sl.registerFactory<ForgotPasswordCubit>(() => ForgotPasswordCubit(sl()));
  sl.registerFactory<OtpCubit>(() => OtpCubit(sl()));
  sl.registerFactory<CreatePasswordCubit>(() => CreatePasswordCubit(sl()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
  sl.registerFactory<SplashCubit>(() => SplashCubit(sl()));
  sl.registerFactory<LogoutCubit>(() => LogoutCubit(sl()));
}

void _registerFamily() {
  sl.registerLazySingleton<FamilyApi>(
    () => FamilyApi(sl(), baseUrl: Endpoints.baseUrl),
  );
  sl.registerLazySingleton<FamilyRemoteApiService>(
    () => FamilyRemoteApiService(sl(), sl()),
  );
  sl.registerLazySingleton<FamilyRepository>(
    () => FamilyRepositoryImpl(sl()),
  );

  sl.registerFactory<FamilyListCubit>(() => FamilyListCubit(sl()));
  sl.registerFactory<FamilyFormCubit>(() => FamilyFormCubit(sl()));
}

void _registerContent() {
  sl.registerLazySingleton<ContentApi>(
    () => ContentApi(sl(), baseUrl: Endpoints.baseUrl),
  );
  sl.registerLazySingleton<ContentRemoteApiService>(
    () => ContentRemoteApiService(sl(), sl()),
  );
  sl.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(sl()),
  );

  sl.registerFactory<InfoPageCubit>(() => InfoPageCubit(sl()));
  sl.registerFactory<FaqsCubit>(() => FaqsCubit(sl()));
  sl.registerFactory<ContactCubit>(() => ContactCubit(sl()));
  sl.registerFactory<FeedbackCubit>(() => FeedbackCubit(sl()));
}

void _registerCheckin() {
  sl.registerLazySingleton<CheckinApi>(
    () => CheckinApi(sl(), baseUrl: Endpoints.baseUrl),
  );
  sl.registerLazySingleton<CheckinRemoteApiService>(
    () => CheckinRemoteApiService(sl(), sl()),
  );
  sl.registerLazySingleton<CheckinRepository>(
    () => CheckinRepositoryImpl(sl()),
  );

  sl.registerFactory<GymQrCubit>(() => GymQrCubit(sl()));
}

void _registerBookings() {
  sl.registerLazySingleton<BookingsApi>(
    () => BookingsApi(sl(), baseUrl: Endpoints.baseUrl),
  );
  sl.registerLazySingleton<BookingsRemoteApiService>(
    () => BookingsRemoteApiService(sl(), sl()),
  );
  sl.registerLazySingleton<BookingsRepository>(
    () => BookingsRepositoryImpl(sl()),
  );

  sl.registerFactory<BookingsListCubit>(() => BookingsListCubit(sl()));
  sl.registerFactoryParam<ClassEvaluationCubit, String, void>(
    (bookingId, _) => ClassEvaluationCubit(sl(), bookingId: bookingId),
  );
}

void _registerNotifications() {
  sl.registerLazySingleton<NotificationsApi>(
    () => NotificationsApi(sl(), baseUrl: Endpoints.baseUrl),
  );
  sl.registerLazySingleton<NotificationsRemoteApiService>(
    () => NotificationsRemoteApiService(sl(), sl()),
  );
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<NotificationsUnreadCubit>(
    () => NotificationsUnreadCubit(sl()),
  );
  sl.registerFactory<NotificationsListCubit>(
    () => NotificationsListCubit(sl()),
  );
}

void _registerWorkouts() {
  sl.registerLazySingleton<WorkoutsApi>(
    () => WorkoutsApi(sl(), baseUrl: Endpoints.baseUrl),
  );
  sl.registerLazySingleton<WorkoutsRemoteApiService>(
    () => WorkoutsRemoteApiService(sl(), sl()),
  );
  sl.registerLazySingleton<WorkoutsRepository>(
    () => WorkoutsRepositoryImpl(sl()),
  );

  sl.registerFactory<WorkoutsListCubit>(() => WorkoutsListCubit(sl()));
  sl.registerFactoryParam<WorkoutDetailCubit, String, void>(
    (assignmentId, _) => WorkoutDetailCubit(sl(), assignmentId: assignmentId),
  );
}
