import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/module/internet/bloc/internet_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SlownetMessage extends StatelessWidget {
  const SlownetMessage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<InternetBloc>().add(MonitorSlowInternetSpeed());
    return Center(
      child: BlocConsumer<InternetBloc, InternetState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.network_wifi_1_bar,
                  color: primaryDark, size: 150),
              const Text(
                "Something went wrong",
                style: TextStyle(
                    color: blackColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                "Possibly network speed is too low.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  color: blackColor.withOpacity(0.7),
                ),
              ),
              // if (kDebugMode) ...[
              Text(
                state.connectionSpeed.toString(),
              ),
              // ]
            ],
          );
        },
      ),
    );
  }
}
