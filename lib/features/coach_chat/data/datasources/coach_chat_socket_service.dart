import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../../core/network/auth_token_events.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/storage/storage_keys.dart';
import '../models/chat_models.dart';

typedef ChatSocketMessageHandler = void Function(ChatMessageModel message);

final class CoachChatSocketService {
  CoachChatSocketService(this._secureStorage);

  final ISecureStorage _secureStorage;

  io.Socket? _socket;
  StreamSubscription<void>? _tokenRefreshSub;
  final _messageController = StreamController<ChatMessageModel>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  Stream<ChatMessageModel> get onMessage => _messageController.stream;

  Stream<bool> get onConnectionChanged => _connectionController.stream;

  bool get isConnected => _socket?.connected ?? false;

  Future<void> connect() async {
    final token = await _secureStorage.read(StorageKeys.accessToken);
    if (token == null || token.isEmpty) return;

    await disconnect();

    _tokenRefreshSub ??= AuthTokenEvents.onRefreshed.listen((_) {
      reconnect();
    });

    _socket = io.io(
      '${Endpoints.baseUrl}/chat',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          .build(),
    );

    _socket!
      ..onConnect((_) => _connectionController.add(true))
      ..onDisconnect((_) => _connectionController.add(false))
      ..on('connected', (_) => _connectionController.add(true))
      ..on('message:new', _handleIncomingMessage)
      ..on('error', _handleSocketError);

    _socket!.connect();
  }

  Future<void> reconnect() async {
    await connect();
  }

  Future<void> disconnect() async {
    final socket = _socket;
    _socket = null;
    if (socket == null) return;

    try {
      final options = socket.io.options;
      if (options != null) {
        options['reconnection'] = false;
      }
      socket
        ..off('connect')
        ..off('disconnect')
        ..off('connected')
        ..off('message:new')
        ..off('error');
      if (socket.connected) {
        socket.disconnect();
      }
      socket.close();
    } catch (_) {
      // WebSocket may already be closed during hot restart / logout.
    }

    if (!_connectionController.isClosed) {
      _connectionController.add(false);
    }
  }

  void sendMessage({
    required String conversationId,
    required String body,
  }) {
    final trimmed = body.trim();
    if (trimmed.isEmpty || _socket == null) return;

    _socket!.emit('message:send', {
      'conversationId': conversationId,
      'body': trimmed,
    });
  }

  void _handleIncomingMessage(dynamic payload) {
    if (payload is! Map) return;

    try {
      final message = ChatMessageModel.fromJson(
        Map<String, dynamic>.from(payload),
      );
      if (!_messageController.isClosed) {
        _messageController.add(message);
      }
    } catch (_) {
      // Ignore malformed payloads.
    }
  }

  Future<void> _handleSocketError(dynamic payload) async {
    final message = payload is Map ? payload['message']?.toString() : null;
    if (message != null && message.isNotEmpty) {
      // Token invalid/expired — reconnect with a fresh token if available.
      await reconnect();
    }
  }

  void dispose() {
    _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;
    unawaited(disconnect());
    _messageController.close();
    _connectionController.close();
  }
}
