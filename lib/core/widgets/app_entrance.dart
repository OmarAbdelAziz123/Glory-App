import 'package:flutter/material.dart';

/// Fade + slight upward slide entrance for home / list widgets.
final class AppEntrance extends StatefulWidget {
  const AppEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 420),
    this.offset = const Offset(0, 0.08),
    this.curve = Curves.easeOutCubic,
    this.animate = true,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;
  final Curve curve;
  final bool animate;

  @override
  State<AppEntrance> createState() => _AppEntranceState();
}

final class _AppEntranceState extends State<AppEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _controller, curve: widget.curve);
    _slide = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    if (!widget.animate) {
      _controller.value = 1;
      return;
    }

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future<void>.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) return widget.child;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}

/// Staggered entrance for a vertical list of widgets.
final class AppStaggeredColumn extends StatelessWidget {
  const AppStaggeredColumn({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisSize = MainAxisSize.max,
    this.initialDelay = const Duration(milliseconds: 40),
    this.stepDelay = const Duration(milliseconds: 70),
    this.duration = const Duration(milliseconds: 420),
    this.offset = const Offset(0, 0.06),
    this.animate = true,
  });

  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final Duration initialDelay;
  final Duration stepDelay;
  final Duration duration;
  final Offset offset;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        for (var i = 0; i < children.length; i++)
          AppEntrance(
            delay: initialDelay + (stepDelay * i),
            duration: duration,
            offset: offset,
            animate: animate,
            child: children[i],
          ),
      ],
    );
  }
}
