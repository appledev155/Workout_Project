import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anytimeworkout/module/chat/bloc/chat/chat_bloc.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> {
  Timer indicatorTimer = Timer(const Duration(seconds: 0), () {});
  final GlobalKey<ScaffoldState> widgetKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listenWhen: (previous, current) =>
          previous.typingIndicatorText != current.typingIndicatorText,
      listener: (context, state) {},
      builder: (context, state) {
        if (state.typingIndicatorText != "") {
          Timer.periodic(const Duration(seconds: 10), (timer) {
            if (!context.mounted) return;
            context
                .read<ChatBloc>()
                .add(CheckTypingIndicatorValidate(timer: timer));
            indicatorTimer = timer;
            timer.cancel();
          });
        }
        return Container(
          key: widgetKey,
          margin: const EdgeInsets.only(top: 10.0),
          child: Text(
            state.typingIndicatorText.isEmpty
                ? ''
                : '${state.typingIndicatorText} ${"chat_section.lbl_is_typing".tr()}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
            ),
          ),
        );
      },
    );
  }

  @override
  dispose() {
    super.dispose();
    indicatorTimer.cancel();
  }
}
