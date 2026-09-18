import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n_extension.dart';
import '../../core/models/content_args.dart';
import '../../core/models/delete_account_otp_args.dart';
import '../../core/models/otp_args.dart';
import '../../core/router/app_routes.dart';
import '../../features/coach_chat/domain/entities/chat_entities.dart';
import '../../features/coach_chat/presentation/screens/coach_chat_list_screen.dart';
import '../../features/coach_chat/presentation/screens/coach_chat_thread_screen.dart';
import '../../features/about/presentation/screens/about_screen.dart';
import '../../features/about/presentation/screens/complaints_screen.dart';
import '../../features/about/presentation/screens/faq_screen.dart';
import '../../features/about/presentation/screens/simple_content_screen.dart';
import '../../features/about/presentation/screens/who_we_are_screen.dart';
import '../../features/home/presentation/screens/class_evaluation_screen.dart';
import '../../features/workouts/presentation/screens/add_weight_screen.dart';
import '../../features/auth/presentation/screens/create_password_screen.dart';
import '../../features/auth/presentation/screens/delete_account_otp_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/onboarding/domain/entities/onboarding_prefill_entity.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/subscription_questionnaire/presentation/screens/questionnaire_screen.dart';
import '../../../../core/models/questionnaire_args.dart';
import '../../features/body_composition/presentation/screens/body_composition_screen.dart';
import '../../features/body_composition/presentation/screens/size_measurements_screen.dart';
import '../../features/inbody/presentation/screens/inbody_detail_screen.dart';
import '../../features/bookings/presentation/screens/bookings_screen.dart';
import '../../features/family/domain/entities/family_member_entity.dart';
import '../../features/family/presentation/screens/add_family_member_screen.dart';
import '../../features/family/presentation/screens/family_screen.dart';
import '../../features/glory_ai/presentation/screens/glory_ai_screen.dart';
import '../../features/glory_ai/presentation/screens/sandy_conversations_list_screen.dart';
import '../../features/glory_ai/presentation/screens/sandy_health_files_screen.dart';
import '../../features/home/presentation/screens/main_layout.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/subscriptions/presentation/screens/subscriptions_screen.dart';
import '../../features/workouts/presentation/screens/workout_detail_screen.dart';
import '../../features/workouts/presentation/screens/workouts_screen.dart';
import '../../core/widgets/app_coach_chat_fab_overlay.dart';

/// Application route configuration.

final class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    // initialLocation: AppRoutes.subscriptionQuestionnaire,
    debugLogDiagnostics: false,
    routes: _routes,
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(context.l10n.routeNotFound(state.uri.toString())),
      ),
    ),
  );

  static final List<RouteBase> _routes = [
    // ── Splash ───────────────────────────────────────────
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (_, _) => const SplashScreenProvider(),
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
        args: state.extra as CreatePasswordArgs?,
      ),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      builder: (_, _) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.subscriptionQuestionnaire,
      name: 'subscriptionQuestionnaire',
      builder: (_, state) => QuestionnaireScreen(
        args: state.extra as QuestionnaireScreenArgs?,
      ),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (_, state) => OnboardingScreen(
        prefill: state.extra as OnboardingPrefillEntity?,
      ),
    ),

    ShellRoute(
      builder: (context, state, child) => AppCoachChatFabOverlay(
        state: state,
        child: child,
      ),
      routes: _appShellRoutes,
    ),
  ];

  static final List<RouteBase> _appShellRoutes = [
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
    GoRoute(
      path: AppRoutes.addWeight,
      name: 'addWeight',
      builder: (_, state) => AddWeightScreen(
        assignmentId: state.pathParameters['id']!,
      ),
    ),

    // ── Profile ───────────────────────────────────────────
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (_, _) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.deleteAccountOtp,
      name: 'deleteAccountOtp',
      builder: (_, state) => DeleteAccountOtpScreen(
        args: state.extra as DeleteAccountOtpArgs?,
      ),
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
    GoRoute(
      path: AppRoutes.inbodyDetail,
      name: 'inbodyDetail',
      builder: (_, state) => InbodyDetailScreen(
        testId: state.pathParameters['id'] ?? '',
      ),
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
      builder: (_, state) => AddFamilyMemberScreen(
        member: state.extra as FamilyMemberEntity?,
      ),
    ),

    // ── Sandy AI ────────────────────────────────────────
    GoRoute(
      path: AppRoutes.sandyConversations,
      name: 'sandyConversations',
      builder: (_, _) => const SandyConversationsListScreen(),
    ),
    GoRoute(
      path: AppRoutes.sandyHealthFiles,
      name: 'sandyHealthFiles',
      builder: (_, _) => const SandyHealthFilesScreen(),
    ),

    // ── Coach Chat ────────────────────────────────────────
    GoRoute(
      path: AppRoutes.coachChat,
      name: 'coachChat',
      builder: (_, _) => const CoachChatListScreen(),
      routes: [
        GoRoute(
          path: ':id',
          name: 'coachChatThread',
          builder: (_, state) => CoachChatThreadScreen(
            conversationId: state.pathParameters['id']!,
            conversation: state.extra as ChatConversationEntity?,
          ),
        ),
      ],
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
      builder: (_, state) => WhoWeAreScreen(
        args: state.extra as WhoWeAreArgs?,
      ),
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
      builder: (_, state) => ClassEvaluationScreen(
        bookingId: state.extra as String? ?? '',
      ),
    ),
  ];
}
