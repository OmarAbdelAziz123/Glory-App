import 'package:flutter/material.dart';

import '../security/secure_screen_service.dart';

/// Wraps the app to block screenshots and screen recording on iOS.
final class SecureScreenScope extends StatefulWidget {
  const SecureScreenScope({super.key, required this.child});

  final Widget child;

  @override
  State<SecureScreenScope> createState() => _SecureScreenScopeState();
}

final class _SecureScreenScopeState extends State<SecureScreenScope> {
  @override
  void initState() {
    super.initState();
    // Wait for the first frame so iOS layout is stable before enabling protection.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) SecureScreenService.enable();
    });
  }

  @override
  void dispose() {
    SecureScreenService.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
