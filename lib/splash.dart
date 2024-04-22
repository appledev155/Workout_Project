import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/module/internet/internet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_indicators/progress_indicators.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class Splash extends StatelessWidget {
  const Splash({super.key});

  void navigationPage(context) {
    Navigator.pushReplacementNamed(context, '/search_result');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetState>(
      listener: (context, state) {
        if (state.appFirstBoot == true) {
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
          navigationPage(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: primaryColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/icon/icon.png", height: 120, width: 120),
                (state.connectionSpeed != -1.0 &&
                        (state.connectionSpeed < 0.0 ||
                            state.connectionStatus ==
                                ConnectionStatus.disconnected))
                    ? Text(
                        "connection.checkConnection".tr(),
                        style: const TextStyle(color: Colors.white),
                      )
                    : const SizedBox.shrink(),
                (state.connectionSpeed != -1.0 &&
                        (state.connectionSpeed < 0.01 &&
                            state.connectionStatus ==
                                ConnectionStatus.connected))
                    ? Text(
                        "Slow Network".tr(),
                        style: const TextStyle(color: Colors.white),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          bottomNavigationBar: JumpingDotsProgressIndicator(
            fontSize: 60.0,
            color: lightColor,
          ),
        );
      },
    );
  }
}
