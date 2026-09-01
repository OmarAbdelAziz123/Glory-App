import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Plays the short branded splash intro sound.
final class SplashSoundService {
  SplashSoundService() : _player = AudioPlayer();

  static const assetPath = 'sounds/splash_intro.mp3';
  static const duration = Duration(milliseconds: 3000);

  final AudioPlayer _player;
  bool _played = false;

  Future<void> play() async {
    if (_played || kIsWeb) return;
    _played = true;

    try {
      await _player.setReleaseMode(ReleaseMode.stop);
      await _player.setVolume(0.85);
      await _player.play(AssetSource(assetPath));
    } catch (_) {
      // Ignore audio failures — splash should still continue.
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {
      // Ignore.
    }
  }

  Future<void> dispose() async {
    await stop();
    await _player.dispose();
  }
}
