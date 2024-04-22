import 'package:anytimeworkout/config/app_colors.dart';
import 'package:flutter/material.dart';

class OfflineMessage extends StatelessWidget {
  const OfflineMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.wifi_off_outlined, color: primaryDark, size: 150),
        const Text(
          "You're offline",
          style: TextStyle(
              color: blackColor, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          "Please connect to the internet for continue.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 19,
            color: blackColor.withOpacity(0.7),
          ),
        )
      ],
    );
  }
}
