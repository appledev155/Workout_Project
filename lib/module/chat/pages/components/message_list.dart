import 'dart:developer';

import 'package:anytimeworkout/main.dart';
import 'package:anytimeworkout/module/chat/model/chat_model.dart';
import 'package:anytimeworkout/module/internet/internet.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../bloc/chat/chat_bloc.dart';
import '../components/single_message.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bottom_loader.dart';

class MessageList extends StatefulWidget {
  final ScrollController? scrollController;
  final ChatChannel currentChannel;
  const MessageList(
      {super.key, required this.currentChannel, this.scrollController});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: (() {
          FocusScope.of(context).unfocus();
        }),
        child: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state.status == ChatStatus.started) {
              widget.scrollController!.animateTo(
                widget.scrollController!.offset - 0.9,
                duration: const Duration(milliseconds: 10),
                curve: Curves.ease,
              );
            }
            if (state.status == ChatStatus.typingOn ||
                state.status == ChatStatus.typingOff ||
                state.status == ChatStatus.sent ||
                state.status == ChatStatus.threadUpdated) {
              widget.scrollController!.animateTo(
                0.0,
                duration: const Duration(milliseconds: 10),
                curve: Curves.ease,
              );
            }
          },
          buildWhen: (previous, current) =>
              (previous.currentChannelThread.length !=
                      current.currentChannelThread.length ||
                  previous.status != current.status),
          builder: (context, state) {
            return SingleChildScrollView(
              controller: widget.scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (environment == "local") ...[
                    Center(child: Text(state.status.toString())),
                    Center(child: Text(state.currentChannel.channelName)),
                  ],
                  if (state.currentChannelThread.isEmpty &&
                      (state.status == ChatStatus.started)) ...[
                    if (context.read<InternetBloc>().state
                        is InternetConnected) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                            "chat_section.lbl_be_the_first_to_send_message"
                                .tr()),
                      )
                    ]
                  ],
                  Column(children: [
                    for (int i = 0;
                        i < state.currentChannelThread.length;
                        i++) ...[
                      if (i - 1 >= -1) ...[
                        SingleMessage(
                          previousMessageRow: ((i - 1) != -1)
                              ? state.currentChannelThread[i - 1]
                              : MessageRow.empty,
                          messageRow: state.currentChannelThread[i],
                          currentChannelId: state.currentChannel.channelId,
                        )
                      ]
                    ]
                  ]),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
