import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

final class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.drawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool extendBodyBehindAppBar;
  final bool extendBody;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.neutral100,
      appBar: appBar,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
    );
  }
}
