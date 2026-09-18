import 'package:flutter/material.dart';

import 'dynamic_onboarding_screen.dart';
import '../../domain/entities/onboarding_prefill_entity.dart';

final class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, this.prefill});

  final OnboardingPrefillEntity? prefill;

  @override
  Widget build(BuildContext context) {
    return DynamicOnboardingScreen(prefill: prefill);
  }
}
