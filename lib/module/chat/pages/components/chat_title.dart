import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/module/chat/bloc/chat/chat_bloc.dart';
import 'package:anytimeworkout/module/chat/pages/components/chat_profile_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatTitle extends StatelessWidget {
  final dynamic toUser;
  final String? channelId;

  const ChatTitle({super.key, this.toUser, this.channelId});

  @override
  Widget build(BuildContext context) {
    return channelId!.isEmpty
        ? const BottomLoader()
        : Row(children: [
            (int.parse(channelId!) <= 2)
                ? (int.parse(channelId!) == 1)
                    ? const Icon(
                        agentGroupIcon,
                        size: 50.0,
                        color: blackColor,
                      )
                    : const Icon(
                        memberGroupIcon,
                        size: 50.0,
                        color: blackColor,
                      )
                : ChatProfileImage(
                    imagePath: toUser.userImage,
                    size: 20.0,
                    userId: toUser.userId,
                  ),
            const SizedBox(
              width: 10,
            ),
            Text(
              (int.parse(channelId!) <= 2)
                  ? (int.parse(channelId!) == 1)
                      ? "chat_section.lbl_agents_group".tr()
                      : "chat_section.lbl_members_group".tr()
                  : toUser.username,
              style: const TextStyle(color: blackColor),
            )
          ]);
  }
}

class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}
