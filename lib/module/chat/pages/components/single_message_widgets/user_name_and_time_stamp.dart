import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/module/chat/bloc/chat/chat_bloc.dart';
import 'package:anytimeworkout/module/chat/model/chat_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;

class UserNameAndTimeStampWidget extends StatelessWidget {
  final MessageRow messageRow;
  const UserNameAndTimeStampWidget({super.key, required this.messageRow});

  @override
  Widget build(BuildContext context) {
    String currentUserId = context.read<ChatBloc>().state.currentUser.userId;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/profile_detail_screen', arguments: [
          int.parse((messageRow.chatUser.userId != "null")
              ? messageRow.chatUser.userId
              : "0"),
          'Details'
        ]);
      },
      child: Directionality(
        textDirection: (context.locale.toString() == "ar_AR")
            ? (messageRow.chatUser.userId.toString() ==
                    currentUserId.toString())
                ? ui.TextDirection.ltr
                : ui.TextDirection.rtl
            : (messageRow.chatUser.userId.toString() ==
                    currentUserId.toString())
                ? ui.TextDirection.rtl
                : ui.TextDirection.ltr,
        child: Row(
          children: [
            Text(
              (messageRow.chatUser.username != "null")
                  ? messageRow.chatUser.username
                  : "chat_section.lbl_inactive_user_name".tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                  height: 2,
                  color: primaryDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
