import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Signals booking list screens to reload after remote mutations (e.g. rating).
abstract final class BookingsRefreshNotifier {
  BookingsRefreshNotifier._();

  static final signal = ValueNotifier<int>(0);

  static void request() {
    signal.value++;
  }
}

final class BookingsRefreshListener extends StatefulWidget {
  const BookingsRefreshListener({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final VoidCallback onRefresh;
  final Widget child;

  @override
  State<BookingsRefreshListener> createState() => _BookingsRefreshListenerState();
}

final class _BookingsRefreshListenerState extends State<BookingsRefreshListener> {
  @override
  void initState() {
    super.initState();
    BookingsRefreshNotifier.signal.addListener(_handleRefresh);
  }

  @override
  void dispose() {
    BookingsRefreshNotifier.signal.removeListener(_handleRefresh);
    super.dispose();
  }

  void _handleRefresh() {
    if (!mounted) return;
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
