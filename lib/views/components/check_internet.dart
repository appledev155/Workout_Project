import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityStatus { WiFi, Cellular, Offline }

class CheckInternet {
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();
  CheckInternet() {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      try {
        final response = await InternetAddress.lookup('google.com');
        if (response.isNotEmpty && response[0].rawAddress.isNotEmpty) {
          connectionStatusController.add(_getStatusFromResult(result));
        }
      } on SocketException catch (_) {
        ConnectivityResult result = ConnectivityResult.none;
        connectionStatusController.add(_getStatusFromResult(result));
      }
    });
  }
  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }
}
