import 'package:anytimeworkout/main.dart';
import 'package:anytimeworkout/module/internet/internet.dart';
import 'package:anytimeworkout/module/internet/pages/offline_message.dart';
import 'package:anytimeworkout/module/internet/pages/slownet_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class OfflinePage extends StatefulWidget {
  const OfflinePage({super.key});

  @override
  State<OfflinePage> createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  int currentIndex = 0;
  String appTitle = "Latest";
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetState>(
      listener: (context, state) {
        if (state.connectionStatus == ConnectionStatus.connected &&
            state.connectionSpeed > 0.001) {
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
          if (navigatorKey.currentState.runtimeType != Null) {
            navigatorKey.currentState!.pushNamed('/search_result');
          }
        }
      },
      listenWhen: (previous, current) =>
          ((previous.connectionStatus != current.connectionStatus) ||
              (previous.connectionSpeed < current.connectionSpeed)),
      builder: (context, state) {
        if (state.connectionStatus == ConnectionStatus.disconnected) {
          context.read<InternetBloc>().add(InternetDisconnected());
        }

        return Scaffold(
          body: (state.connectionStatus == ConnectionStatus.disconnected)
              ? const OfflineMessage()
              : const SlownetMessage(),
        );
      },
    );
  }
}
