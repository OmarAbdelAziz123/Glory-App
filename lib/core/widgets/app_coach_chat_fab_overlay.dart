import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../router/app_routes.dart';
import '../theme/app_colors.dart';
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
    if (path == AppRoutes.subscriptionQuestionnaire) return false;
    if (path == AppRoutes.onboarding) return false;
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
        final startAligned = CoachChatFabVisibility.useStartAlignment(path);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            child,
            Positioned.fill(
              child: _DraggableCoachChatFabLayer(
                bottomOffset: bottomOffset,
                startAligned: startAligned,
                onPressed: () => context.push(AppRoutes.coachChat),
              ),
            ),
          ],
        );
      },
    );
  }
}

final class _DraggableCoachChatFabLayer extends StatefulWidget {
  const _DraggableCoachChatFabLayer({
    required this.bottomOffset,
    required this.startAligned,
    required this.onPressed,
  });

  final double bottomOffset;
  final bool startAligned;
  final VoidCallback onPressed;

  @override
  State<_DraggableCoachChatFabLayer> createState() =>
      _DraggableCoachChatFabLayerState();
}

final class _DraggableCoachChatFabLayerState
    extends State<_DraggableCoachChatFabLayer> {
  static const _fabSize = 76.0;
  static const _peekWidth = 22.0;
  static const _horizontalInset = 20.0;
  static const _dragThreshold = 8.0;
  static const _edgeTuckThreshold = 18.0;
  static const _prefsDxKey = 'coach_chat_fab_dx';
  static const _prefsDyKey = 'coach_chat_fab_dy';

  Offset? _position;
  bool _isDragging = false;
  bool _didDrag = false;
  bool _suppressTap = false;
  double _dragDistance = 0;

  @override
  void initState() {
    super.initState();
    _loadSavedPosition();
  }

  Future<void> _loadSavedPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final dx = prefs.getDouble(_prefsDxKey);
    final dy = prefs.getDouble(_prefsDyKey);
    if (!mounted || dx == null || dy == null) return;

    setState(() => _position = Offset(dx, dy));
  }

  void _persistPosition(Offset position) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setDouble(_prefsDxKey, position.dx);
      prefs.setDouble(_prefsDyKey, position.dy);
    });
  }

  Offset _defaultPosition(Size screen, double topPadding) {
    final y = screen.height - widget.bottomOffset - _fabSize;
    final x = widget.startAligned
        ? _horizontalInset
        : screen.width - _horizontalInset - _fabSize;
    return Offset(x, y);
  }

  double _minX(Size screen) => -(_fabSize - _peekWidth);

  double _maxX(Size screen) => screen.width - _peekWidth;

  double _visibleMinX() => _horizontalInset;

  double _visibleMaxX(Size screen) =>
      screen.width - _horizontalInset - _fabSize;

  Offset _clampPosition(Offset position, Size screen, double topPadding) {
    final minY = topPadding + 8;
    final maxY = screen.height - widget.bottomOffset - _fabSize;

    return Offset(
      position.dx.clamp(_minX(screen), _maxX(screen)),
      position.dy.clamp(minY, maxY),
    );
  }

  Offset _resolveReleasePosition(
    Offset position,
    Size screen,
    double topPadding,
  ) {
    final minY = topPadding + 8;
    final maxY = screen.height - widget.bottomOffset - _fabSize;
    final y = position.dy.clamp(minY, maxY);

    if (position.dx <= _edgeTuckThreshold) {
      return Offset(_minX(screen), y);
    }

    if (position.dx + _fabSize >= screen.width - _edgeTuckThreshold) {
      return Offset(_maxX(screen), y);
    }

    return Offset(
      position.dx.clamp(_visibleMinX(), _visibleMaxX(screen)),
      y,
    );
  }

  bool _isTucked(Offset position, Size screen) {
    return position.dx <= _minX(screen) + 1 ||
        position.dx >= _maxX(screen) - 1;
  }

  void _handlePanStart(DragStartDetails details) {
    _isDragging = true;
    _didDrag = false;
    _dragDistance = 0;
  }

  void _handlePanUpdate(
    DragUpdateDetails details,
    Size screen,
    double topPadding,
  ) {
    _dragDistance += details.delta.distance;
    if (_dragDistance >= _dragThreshold) {
      _didDrag = true;
    }

    final current = _position ?? _defaultPosition(screen, topPadding);
    setState(() {
      _position = _clampPosition(current + details.delta, screen, topPadding);
    });
  }

  void _handlePanEnd(DragEndDetails details, Size screen, double topPadding) {
    if (_didDrag) {
      _suppressTap = true;
    }
    _isDragging = false;

    if (!_didDrag) return;

    final current = _position ?? _defaultPosition(screen, topPadding);
    final finalPosition = _resolveReleasePosition(current, screen, topPadding);

    setState(() => _position = finalPosition);
    _persistPosition(finalPosition);
  }

  void _handleTap(Size screen, double topPadding) {
    if (_suppressTap) {
      _suppressTap = false;
      return;
    }
    if (_didDrag) {
      _didDrag = false;
      return;
    }

    final current = _clampPosition(
      _position ?? _defaultPosition(screen, topPadding),
      screen,
      topPadding,
    );

    if (_isTucked(current, screen)) {
      final expanded = Offset(
        current.dx <= _minX(screen) + 1
            ? _horizontalInset
            : screen.width - _horizontalInset - _fabSize,
        current.dy,
      );
      setState(() => _position = expanded);
      _persistPosition(expanded);
      return;
    }

    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screen = Size(constraints.maxWidth, constraints.maxHeight);
        final resolved = _clampPosition(
          _position ?? _defaultPosition(screen, topPadding),
          screen,
          topPadding,
        );

        return Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedPositioned(
              duration: _isDragging
                  ? Duration.zero
                  : const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              left: resolved.dx,
              top: resolved.dy,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: _handlePanStart,
                onPanUpdate: (details) =>
                    _handlePanUpdate(details, screen, topPadding),
                onPanEnd: (details) =>
                    _handlePanEnd(details, screen, topPadding),
                onTap: () => _handleTap(screen, topPadding),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    if (_isDragging) ...[
                      PositionedDirectional(
                        start: -10,
                        child: Icon(
                          Icons.chevron_left_rounded,
                          color: AppColors.primary600.withValues(alpha: 0.75),
                          size: 22,
                        ),
                      ),
                      PositionedDirectional(
                        end: -10,
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.primary600.withValues(alpha: 0.75),
                          size: 22,
                        ),
                      ),
                    ],
                    AppCoachChatFab(
                      onPressed: widget.onPressed,
                      handleTapInternally: false,
                      isDragging: _isDragging,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
