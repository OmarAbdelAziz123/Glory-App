import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Platform-adaptive pull-to-refresh wrapper.
/// Android: [RefreshIndicator], iOS: [CupertinoSliverRefreshControl].
final class AppPlatformRefreshScroll extends StatelessWidget {
  const AppPlatformRefreshScroll({
    super.key,
    required this.onRefresh,
    required this.child,
    this.controller,
  });

  final Future<void> Function() onRefresh;
  final Widget child;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CustomScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: onRefresh),
          SliverToBoxAdapter(child: child),
        ],
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: controller,
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

/// Platform-adaptive pull-to-refresh for list content with optional separators.
final class AppPlatformRefreshListView extends StatelessWidget {
  const AppPlatformRefreshListView({
    super.key,
    required this.onRefresh,
    required this.itemCount,
    required this.itemBuilder,
    this.separatorBuilder,
    this.controller,
    this.padding,
  });

  final Future<void> Function() onRefresh;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;

  static const _physics = AlwaysScrollableScrollPhysics();

  int get _childCount {
    if (itemCount == 0 || separatorBuilder == null) return itemCount;
    return itemCount * 2 - 1;
  }

  Widget _buildSeparatedChild(BuildContext context, int index) {
    if (index.isEven) {
      return itemBuilder(context, index ~/ 2);
    }
    return separatorBuilder!(context, index ~/ 2);
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CustomScrollView(
        controller: controller,
        physics: _physics,
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: onRefresh),
          SliverPadding(
            padding: padding ?? EdgeInsets.zero,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                separatorBuilder == null
                    ? itemBuilder
                    : (context, index) => _buildSeparatedChild(context, index),
                childCount: _childCount,
              ),
            ),
          ),
        ],
      );
    }

    if (separatorBuilder != null) {
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: onRefresh,
        child: ListView.separated(
          controller: controller,
          physics: _physics,
          padding: padding,
          itemCount: itemCount,
          separatorBuilder: separatorBuilder!,
          itemBuilder: itemBuilder,
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: controller,
        physics: _physics,
        padding: padding,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
