import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../features/coach_chat/presentation/cubits/coach_chat_unread/coach_chat_unread_cubit.dart';
import '../l10n/l10n_extension.dart';
import '../theme/app_colors.dart';

/// Animated floating action button that opens coach chat.
final class AppCoachChatFab extends StatefulWidget {
  const AppCoachChatFab({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  State<AppCoachChatFab> createState() => _AppCoachChatFabState();
}

final class _AppCoachChatFabState extends State<AppCoachChatFab>
    with TickerProviderStateMixin {
  static const _size = 56.0;

  late final AnimationController _pulseController;
  late final AnimationController _pressController;
  late final Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 220),
    );
    _pressScale = Tween<double>(begin: 1, end: 0.92).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _pressController.forward();
    await _pressController.reverse();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final label = context.l10n.coachChat;

    return AnimatedSlide(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      offset: Offset.zero,
      child: Semantics(
        button: true,
        label: label,
        child: SizedBox(
              width: _size + 20,
              height: _size + 20,
              child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    ...List.generate(2, (index) {
                      return AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final progress =
                              ((_pulseController.value + (index * 0.5)) % 1);
                          final scale = 1 + (progress * 0.55);
                          final opacity = (1 - progress).clamp(0.0, 1.0) * 0.35;

                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              width: _size,
                              height: _size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary600
                                      .withValues(alpha: opacity),
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    ScaleTransition(
                      scale: _pressScale,
                      child: Material(
                        color: Colors.transparent,
                        elevation: 0,
                        child: InkWell(
                          onTap: _handleTap,
                          customBorder: const CircleBorder(),
                          splashColor: AppColors.white.withValues(alpha: 0.18),
                          highlightColor: AppColors.white.withValues(alpha: 0.08),
                          child: Ink(
                            width: _size,
                            height: _size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primary600,
                                  AppColors.primary800,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary700
                                      .withValues(alpha: 0.45),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                                BoxShadow(
                                  color: AppColors.primary500
                                      .withValues(alpha: 0.25),
                                  blurRadius: 28,
                                  spreadRadius: -4,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Iconsax.messages_2,
                              color: AppColors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      top: 2,
                      end: 2,
                      child: BlocBuilder<CoachChatUnreadCubit, CoachChatUnreadState>(
                        buildWhen: (previous, current) =>
                            previous.count != current.count,
                        builder: (context, state) {
                          if (state.count <= 0) {
                            return const SizedBox.shrink();
                          }

                          final badgeText =
                              state.count > 99 ? '99+' : '${state.count}';

                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.6, end: 1),
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.elasticOut,
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: child,
                              );
                            },
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 20),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.red100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.white,
                                  width: 1.5,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x33000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                badgeText,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
