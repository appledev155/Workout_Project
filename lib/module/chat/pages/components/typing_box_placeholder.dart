import 'dart:async';

import 'package:anytimeworkout/module/chat/bloc/chat/chat_bloc.dart';
import 'package:anytimeworkout/config/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TypingBoxPlaceholder extends StatefulWidget {
  TypingBoxPlaceholder({super.key});

  @override
  State<TypingBoxPlaceholder> createState() => _TypingBoxPlaceholderState();
}

class _TypingBoxPlaceholderState extends State<TypingBoxPlaceholder> {
  bool enableResend = false;
  Timer? timer;
  int secondsRemaining = 180;
  bool timerDispose = false;
  @override
  void initState() {
    super.initState();
    timerButton();
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  timerButton() {
    if (context.read<ChatBloc>().state.disableTypingMessage.length < 7) {
      secondsRemaining =
          int.parse(context.read<ChatBloc>().state.disableTypingMessage);
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (secondsRemaining != 0) {
          if (mounted) {
            setState(() {
              secondsRemaining--;
            });
          }
        } else {
          timer!.cancel();
          if (mounted) {
            setState(() {
              enableResend = true;
            });
            context.read<ChatBloc>().add(ResetDisableTypingMessage());
          }
          context.read<ChatBloc>().add(ResetDisableTypingMessage());
        }
      });
      setState(() {
        timerDispose = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (timerDispose == true) {
      timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    String lblNeedToWait = "chat_section.lbl_need_to_wait".tr();
    String lblMinute = "chat_section.lbl_min".tr();
    String lblSeconds = "chat_section.lbl_second".tr();
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {},
      listenWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Container(
          color: lightGreyColor,
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: (state.disableTypingMessage.length < 7)
                ? Text((secondsRemaining < 60)
                    ? "$lblNeedToWait ${_printDuration(Duration(seconds: secondsRemaining))} $lblSeconds"
                    : "$lblNeedToWait ${_printDuration(Duration(seconds: secondsRemaining))} $lblMinute")
                : Text(
                    state.disableTypingMessage,
                    style: TextStyle(fontSize: 15.sp, color: blackColor),
                  ),
          ),
        );
      },
    );
  }
}
