import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/otp_args.dart';
import '../../core/router/app_routes.dart';
import '../../features/about/presentation/screens/about_screen.dart';
import '../../features/about/presentation/screens/complaints_screen.dart';
import '../../features/about/presentation/screens/faq_screen.dart';
import '../../features/about/presentation/screens/simple_content_screen.dart';
import '../../features/about/presentation/screens/who_we_are_screen.dart';
import '../../features/home/presentation/screens/class_evaluation_screen.dart';
import '../../features/workouts/presentation/screens/add_weight_screen.dart';
import '../../features/auth/presentation/screens/create_password_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/body_composition/presentation/screens/body_composition_screen.dart';
import '../../features/body_composition/presentation/screens/size_measurements_screen.dart';
import '../../features/bookings/presentation/screens/bookings_screen.dart';
import '../../features/family/presentation/screens/add_family_member_screen.dart';
import '../../features/family/presentation/screens/family_screen.dart';
import '../../features/glory_ai/presentation/screens/glory_ai_screen.dart';
import '../../features/home/presentation/screens/main_layout.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/edit_email_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/subscriptions/presentation/screens/subscriptions_screen.dart';
import '../../features/workouts/presentation/screens/workout_detail_screen.dart';
import '../../features/workouts/presentation/screens/workouts_screen.dart';

final class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: _routes,
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri}')),
    ),
  );

  static final List<RouteBase> _routes = [
    // ── Splash ───────────────────────────────────────────
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (_, _) => const SplashScreen(),
    ),

    // ── Auth ─────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (_, _) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (_, _) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.otp,
      name: 'otp',
      builder: (_, state) => OtpScreen(args: state.extra as OtpArgs?),
    ),
    GoRoute(
      path: AppRoutes.createPassword,
      name: 'createPassword',
      builder: (_, state) => CreatePasswordScreen(
        mode: state.extra as CreatePasswordMode? ??
            CreatePasswordMode.forgotPassword,
      ),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      builder: (_, _) => const ForgotPasswordScreen(),
    ),

    // ── Main tabs ────────────────────────────────────────
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (_, _) => const MainLayout(),
    ),
    GoRoute(
      path: AppRoutes.bookings,
      name: 'bookings',
      builder: (_, _) => const BookingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.gloryAi,
      name: 'gloryAi',
      builder: (_, _) => const GloryAiScreen(),
    ),
    GoRoute(
      path: AppRoutes.workouts,
      name: 'workouts',
      builder: (_, _) => const WorkoutsScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      builder: (_, _) => const SettingsScreen(),
    ),

    // ── Workouts detail ───────────────────────────────────
    GoRoute(
      path: AppRoutes.workoutDetail,
      name: 'workoutDetail',
      builder: (_, state) => WorkoutDetailScreen(
        id: state.pathParameters['id']!,
      ),
    ),

    // ── Profile ───────────────────────────────────────────
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (_, _) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      name: 'editProfile',
      builder: (_, _) => const EditProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.editEmail,
      name: 'editEmail',
      builder: (_, _) => const EditEmailScreen(),
    ),

    // ── Body Composition ──────────────────────────────────
    GoRoute(
      path: AppRoutes.bodyComposition,
      name: 'bodyComposition',
      builder: (_, _) => const BodyCompositionScreen(),
    ),
    GoRoute(
      path: AppRoutes.sizeMeasurements,
      name: 'sizeMeasurements',
      builder: (_, _) => const SizeMeasurementsScreen(),
    ),

    // ── Subscriptions ────────────────────────────────────
    GoRoute(
      path: AppRoutes.subscriptions,
      name: 'subscriptions',
      builder: (_, _) => const SubscriptionsScreen(),
    ),

    // ── Family ────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.family,
      name: 'family',
      builder: (_, _) => const FamilyScreen(),
    ),
    GoRoute(
      path: AppRoutes.addFamilyMember,
      name: 'addFamilyMember',
      builder: (_, _) => const AddFamilyMemberScreen(),
    ),

    // ── Notifications ─────────────────────────────────────
    GoRoute(
      path: AppRoutes.notifications,
      name: 'notifications',
      builder: (_, _) => const NotificationsScreen(),
    ),

    // ── About ─────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.about,
      name: 'about',
      builder: (_, _) => const AboutScreen(),
    ),
    GoRoute(
      path: AppRoutes.whoWeAre,
      name: 'whoWeAre',
      builder: (_, _) => const WhoWeAreScreen(),
    ),
    GoRoute(
      path: AppRoutes.simpleContent,
      name: 'simpleContent',
      builder: (_, state) => SimpleContentScreen(
        args: state.extra as SimpleContentArgs,
      ),
    ),
    GoRoute(
      path: AppRoutes.faq,
      name: 'faq',
      builder: (_, _) => const FaqScreen(),
    ),
    GoRoute(
      path: AppRoutes.complaints,
      name: 'complaints',
      builder: (_, _) => const ComplaintsScreen(),
    ),

    // ── Class Evaluation ──────────────────────────────────
    GoRoute(
      path: AppRoutes.classEvaluation,
      name: 'classEvaluation',
      builder: (_, _) => const ClassEvaluationScreen(),
    ),

    // ── Add Weight ────────────────────────────────────────
    GoRoute(
      path: AppRoutes.addWeight,
      name: 'addWeight',
      builder: (_, _) => const AddWeightScreen(),
    ),
  ];
}
