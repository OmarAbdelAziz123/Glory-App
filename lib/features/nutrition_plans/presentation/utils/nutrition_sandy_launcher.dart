import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_routes.dart';
import '../../../glory_ai/presentation/cubits/sandy_chat/sandy_chat_cubit.dart';

abstract final class NutritionSandyLauncher {
  static Future<void> openConversation(
    BuildContext context, {
    required String conversationId,
  }) async {
    final chatCubit = sl<SandyChatCubit>();
    if (chatCubit.state.status == SandyChatStatus.initial) {
      await chatCubit.initialize();
    }
    await chatCubit.openConversation(conversationId);
    if (!context.mounted) return;
    if (chatCubit.state.status == SandyChatStatus.failure) {
      final message = chatCubit.state.errorMessage;
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
      return;
    }

    await context.push(AppRoutes.gloryAi);
  }
}

/// Provides the shared [SandyChatCubit] when [GloryAiScreen] is pushed outside tabs.
final class SandyChatRouteScope extends StatelessWidget {
  const SandyChatRouteScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = sl<SandyChatCubit>();
    if (cubit.state.status == SandyChatStatus.initial) {
      cubit.initialize();
    }
    return BlocProvider<SandyChatCubit>.value(value: cubit, child: child);
  }
}
