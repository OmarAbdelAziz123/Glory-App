import 'package:flutter/material.dart';

/// Keeps all children alive like [IndexedStack], with a soft fade/slide
/// when the active index changes (ideal for bottom navigation).
final class AppAnimatedIndexedStack extends StatelessWidget {
  const AppAnimatedIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 280),
    this.curve = Curves.easeOutCubic,
  });

  final int index;
  final List<Widget> children;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    // Paint the active pane last so it stays on top during the crossfade.
    final order = <int>[
      for (var i = 0; i < children.length; i++)
        if (i != index) i,
      index,
    ];

    return Stack(
      fit: StackFit.expand,
      children: [
        for (final i in order)
          _AnimatedTabPane(
            key: ValueKey('nav-pane-$i'),
            active: i == index,
            duration: duration,
            curve: curve,
            child: children[i],
          ),
      ],
    );
  }
}

final class _AnimatedTabPane extends StatelessWidget {
  const _AnimatedTabPane({
    super.key,
    required this.active,
    required this.duration,
    required this.curve,
    required this.child,
  });

  final bool active;
  final Duration duration;
  final Curve curve;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !active,
      child: AnimatedOpacity(
        opacity: active ? 1 : 0,
        duration: duration,
        curve: curve,
        // Keep animation tickers alive so fade-out can finish.
        // Only pause the tab content itself when inactive.
        child: AnimatedSlide(
          offset: active ? Offset.zero : const Offset(0, 0.018),
          duration: duration,
          curve: curve,
          child: AnimatedScale(
            scale: active ? 1 : 0.988,
            duration: duration,
            curve: curve,
            child: TickerMode(
              enabled: active,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
