import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class INetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

final class NetworkInfo implements INetworkInfo {
  const NetworkInfo(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  @override
  Stream<bool> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.map(_hasConnection);

  static bool _hasConnection(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}
