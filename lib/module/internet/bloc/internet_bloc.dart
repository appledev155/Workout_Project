import 'dart:async';
import 'dart:io';

import 'package:anytimeworkout/isar/app_config/app_config_isar.dart';
import 'package:anytimeworkout/life_cycle_handler.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

import '../config.dart';

part 'internet_state.dart';
part 'internet_event.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  late final Connectivity connectivity;
  late StreamSubscription connectivityStreamSubscription;
  Timer? timer;
  static int _timeout = 1;

  InternetBloc({required Connectivity connectivity})
      : super(const InternetState(
          connectionStatus: ConnectionStatus.loading,
          connectionType: ConnectionType.unknown,
          connectionSpeed: -1.0,
          appFirstBoot: false,
        )) {
    on<BootApplication>(_onBootApplication, transformer: sequential());
    on<InternetConnected>(_onInternetConnected, transformer: sequential());
    on<InternetDisconnected>(_onInternetDisconnected,
        transformer: sequential());
    on<InternetSpeedChanged>(_onInternetSpeedChanged,
        transformer: sequential());
    on<MonitorSlowInternetSpeed>(_onMonitorSlowInternetSpeed,
        transformer: sequential());

    connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.wifi) {
        add(InternetConnected(connectionType: ConnectionType.wifi));
      } else if (connectivityResult == ConnectivityResult.mobile) {
        add(InternetConnected(connectionType: ConnectionType.mobile));
      } else if (connectivityResult == ConnectivityResult.none) {
        add(InternetDisconnected());
      }
    });
  }

  _onBootApplication(BootApplication event, Emitter<InternetState> emit) async {
    WidgetsBinding.instance.addObserver(LifecycleEventHandler());
    emit(state.copyWith(appFirstBoot: false));

    dynamic firstBootFromLocal = await app_instance.appConfigStore
        .fetchConfig(configName: 'appFirstBoot');
    if (state.connectionSpeed > 0.0 &&
        (firstBootFromLocal == false ||
            firstBootFromLocal.runtimeType != bool)) {
      try {
        await app_instance.utility.clearJsonLastSearchForLatestResult();
        await app_instance.utility.checkAppVersion();
        await app_instance.utility.postLimit();
        await app_instance.utility.getAlgolia();
        await app_instance.utility.getAlgoliaKey();
        await app_instance.utility.getPropertyType();
        // save variable to local
        dynamic getAlgoliaFromLocal = await app_instance.appConfigStore
            .fetchConfig(configName: 'get_algolia');
        if (getAlgoliaFromLocal == null || getAlgoliaFromLocal.isEmpty) {
          return emit(state.copyWith(appFirstBoot: false));
        }

        await app_instance.appConfigStore.saveAppConfig(AppConfigIsar()
          ..configName = "appFirstBoot"
          ..configValue = "true");

        return emit(state.copyWith(appFirstBoot: true));
      } catch (e) {
        firstBootFromLocal = false;
      }
    }
    await app_instance.utility.clearJsonLastSearchForLatestResult();
    emit(state.copyWith(appFirstBoot: firstBootFromLocal));
  }

  _onInternetSpeedChanged(
      InternetSpeedChanged event, Emitter<InternetState> emit) async {
    double currentSpeedInMb = await checkInternetSpeed();
    if (kDebugMode) {
      print("Speed changed.....$currentSpeedInMb");
    }
    if (currentSpeedInMb <= 0) {
      monitorInternetConnection();
      emit(state.copyWith(
        connectionStatus: ConnectionStatus.disconnected,
        connectionType: state.connectionType,
        connectionSpeed: 0.0,
      ));
      return;
    } else {
      timer?.cancel();
      emit(state.copyWith(
        connectionStatus: ConnectionStatus.connected,
        connectionType: state.connectionType,
        connectionSpeed: currentSpeedInMb,
      ));
    }
  }

  Future<double> checkInternetSpeed() async {
    try {
      var startTime = DateTime.now();
      final response = await http.get(Uri.parse('https://www.google.com'));
      var endTime = DateTime.now();

      // Calculate the duration (in milliseconds) it took to receive a response
      var duration = endTime.difference(startTime).inMilliseconds;

      // Calculate speed in Mbps
      var speedInMbps =
          (response.bodyBytes.length / 1024 / 1024) / (duration / 1000);

      return speedInMbps;
    } catch (e) {
      print('Error occurred: $e');
    }
    return 0.0;
  }

  void monitorInternetConnection() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (kDebugMode) {
        print("Timer started ---- From Internet Bloc");
      }
      add(InternetSpeedChanged());
    });
  }

  _onMonitorSlowInternetSpeed(
      MonitorSlowInternetSpeed event, Emitter<InternetState> emit) {
    monitorInternetConnection();
    if (state.connectionSpeed <= 0.009) {
      app_instance.appConfig.numberOfRecords =
          app_instance.appConfig.numberOfRecordsOnLowNetwork;
      app_instance.appConfig.algoliaTimeOut =
          app_instance.appConfig.algoliaTimeOutOnLowNetwork;
    }
    if (state.connectionSpeed > 0.009) {
      app_instance.appConfig.numberOfRecords =
          app_instance.appConfig.numberOfRecords;
      app_instance.appConfig.algoliaTimeOut =
          app_instance.appConfig.algoliaTimeOut;
    }
  }

  _onInternetDisconnected(
      InternetDisconnected event, Emitter<InternetState> emit) {
    monitorInternetConnection();

    emit(state.copyWith(
      connectionStatus: ConnectionStatus.disconnected,
      connectionType: ConnectionType.unknown,
      connectionSpeed: -0.0,
    ));
  }

  Future<void> _onInternetConnected(
      InternetConnected event, Emitter<InternetState> emit) async {
    emit(state.copyWith(
      connectionStatus: ConnectionStatus.loading,
      connectionType: event.connectionType,
    ));
    try {
      await InternetAddress.lookup('google.com').onError((error, stackTrace) =>
          throw const SocketException("Connection timed out"));
      timer?.cancel();
      emit(state.copyWith(
        connectionStatus: ConnectionStatus.connected,
        connectionType: event.connectionType,
      ));
      // do not want to wait for another look up
      add(InternetSpeedChanged());
    } catch (e) {
      // Handle other types of exceptions
      if (kDebugMode) {
        print("An error occurred: $e");
      }
      add(InternetDisconnected());
    }
  }

  @override
  Future<void> close() {
    connectivityStreamSubscription.cancel();
    timer?.cancel();
    return super.close();
  }
}
