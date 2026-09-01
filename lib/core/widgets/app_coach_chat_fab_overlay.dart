import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_routes.dart';
import 'app_bottom_nav_bar.dart';
import 'app_coach_chat_fab.dart';

/// Tracks the active tab inside [MainLayout] for shell-level UI such as the FAB.
abstract final class MainShellTabNotifier {
  static final ValueNotifier<AppNavTab?> current = ValueNotifier(null);
}

/// Routes where the global coach chat FAB must stay hidden.
abstract final class CoachChatFabVisibility {
  CoachChatFabVisibility._();

  static bool shouldShow(String path, {AppNavTab? mainTab}) {
    if (path.startsWith(AppRoutes.coachChat)) return false;
    if (path == AppRoutes.gloryAi) return false;
    if (path == AppRoutes.sandyConversations) return false;
    if (mainTab == AppNavTab.gloryAi) return false;
    return true;
  }

  static bool hasBottomNav(String path) => path == AppRoutes.home;

  /// Family screen already has its own FAB — place coach chat on the opposite side.
  static bool useStartAlignment(String path) => path == AppRoutes.family;
}

/// Shell overlay that keeps the coach chat FAB above in-app screens.
final class AppCoachChatFabOverlay extends StatelessWidget {
  const AppCoachChatFabOverlay({
    super.key,
    required this.state,
    required this.child,
  });

  final GoRouterState state;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppNavTab?>(
      valueListenable: MainShellTabNotifier.current,
      builder: (context, mainTab, _) {
        final path = state.uri.path;
        if (!CoachChatFabVisibility.shouldShow(path, mainTab: mainTab)) {
          return child;
        }

        final bottomInset = MediaQuery.paddingOf(context).bottom;
        final bottomOffset = CoachChatFabVisibility.hasBottomNav(path)
            ? bottomInset + 76
            : bottomInset + 20;
        const horizontalInset = 20.0;
        final alignment = CoachChatFabVisibility.useStartAlignment(path)
            ? AlignmentDirectional.bottomStart
            : AlignmentDirectional.bottomEnd;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            child,
            Align(
              alignment: alignment,
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: horizontalInset,
                  end: horizontalInset,
                  bottom: bottomOffset,
                ),
                child: AppCoachChatFab(
                  onPressed: () => context.push(AppRoutes.coachChat),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
