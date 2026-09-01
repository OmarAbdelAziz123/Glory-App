import 'dart:async';

/// Broadcasts when the access token is refreshed so long-lived connections
/// (e.g. Socket.IO) can reconnect with the new credentials.
abstract final class AuthTokenEvents {
  static final _controller = StreamController<void>.broadcast();

  static Stream<void> get onRefreshed => _controller.stream;

  static void notifyRefreshed() {
    if (!_controller.isClosed) {
      _controller.add(null);
    }
  }
}
