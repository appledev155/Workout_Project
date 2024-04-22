import 'dart:convert';
import 'package:anytimeworkout/module/chat/bloc/chat/chat_bloc.dart';
import 'package:anytimeworkout/module/internet/config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../config/app_colors.dart';
import '../../../../../isar/app_config/app_config_isar.dart';
import '../../../../internet/bloc/internet_bloc.dart';
import '../../../bloc/channel/channel_bloc.dart';
import '../../../config/chat_config.dart';
import '../../../model/chat_model.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class PrivateChatActionButton extends StatefulWidget {
  final dynamic decodedChannelData;
  const PrivateChatActionButton({super.key, this.decodedChannelData});

  @override
  State<PrivateChatActionButton> createState() =>
      _PrivateChatActionButtonState();
}

class _PrivateChatActionButtonState extends State<PrivateChatActionButton> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {},
      buildWhen: (previous, current) =>
          (previous.currentChannel.chatFlag != current.currentChannel.chatFlag),
      builder: ((context, state) {
        return PopupMenuButton(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
          itemBuilder: (context) {
            return [
              if (widget.decodedChannelData['leave_block'].toString() ==
                  '0') ...[
                PopupMenuItem<int>(
                  value: 0,
                  child: Text("chat_section.lbl_block".tr()),
                ),
              ],
              PopupMenuItem<int>(
                value: 1,
                child: Text("chat_section.lbl_delete_chat".tr()),
              ),
            ];
          },
          onSelected: (value) {
            if (value == 0) {
              showBlockUserDialogue(
                context,
                state.currentChannel,
                state.currentChannel.chatToUser.first.userId,
              );
            }
            if (value == 1) {
              showDeleteDialogue(context, state.currentChannel);
            }
          },
        );
      }),
    );
  }

  // show block confirmation dialoge box
  Future<void> showBlockUserDialogue(
      BuildContext context, ChatChannel chatChannel, String toUserId) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "chat_section.lbl_block_confirmation".tr(),
              style: const TextStyle(color: blackColor),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  context.read<ChatBloc>().add(ValidateMessaging());
                  context.read<ChatBloc>().add(SignalSent(
                        currentChannel: chatChannel,
                        signalType: signalType.indexOf('blocked').toString(),
                      ));
                  Navigator.pop(context);

                  app_instance.appConfigStore.saveAppConfig(AppConfigIsar()
                    ..configName = "blockedUsers"
                    ..configValue = jsonEncode(chatChannel.channelId));

                  Future.delayed(const Duration(milliseconds: 300), () {
                    Fluttertoast.showToast(
                        msg: "chat_section.lbl_block_successfull".tr(),
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 5,
                        backgroundColor: blackColor);
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryDark),
                child: const Text("chat_section.lbl_block").tr(),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: lightColor,
                    side: const BorderSide(color: primaryDark, width: 1)),
                child: Text(
                  "chat_section.lbl_cancel".tr(),
                  style: const TextStyle(color: primaryDark),
                ),
              ),
            ],
          );
        });
  }

  Future<bool> moveToChannel(state, channelBlocRead) async {
    if (context.read<InternetBloc>().state.connectionStatus !=
        ConnectionStatus.disconnected) {
      List<MessageRow> firstTenMessages =
          (state.currentChannelThread.length > 10)
              ? state.currentChannelThread.sublist(
                  (state.currentChannelThread.length - 10),
                  state.currentChannelThread.length)
              : state.currentChannelThread;
      channelBlocRead.add(
        MovedChannelScreen(
          chatChannel: state.currentChannel.copyWith(
            messagesRow: firstTenMessages,
            disableTypingMessage: state.disableTypingMessage,
          ),
          toUsers: state.toUsers,
        ),
      );
    }
    Navigator.pushNamed(context, '/channel');
    return false;
  }

  // show delete channel confirmation dialoge box
  Future<void> showDeleteDialogue(
      BuildContext context, ChatChannel chatChannel) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "chat_section.lbl_delete_confirmation".tr(),
              style: const TextStyle(color: blackColor),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  context
                      .read<ChannelBloc>()
                      .add(DeleteChannel(chatChannel: chatChannel));

                  await moveToChannel(context.read<ChatBloc>().state,
                      BlocProvider.of<ChannelBloc>(context));

                  Future.delayed(const Duration(milliseconds: 300), () {
                    Fluttertoast.showToast(
                        msg: "chat_section.lbl_delete_successfull".tr(),
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 5,
                        backgroundColor: blackColor);
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryDark),
                child: Text("chat_section.lbl_delete_chat".tr()),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: lightColor,
                    side: const BorderSide(color: primaryDark, width: 1)),
                child: Text(
                  "chat_section.lbl_cancel".tr(),
                  style: const TextStyle(color: primaryDark),
                ),
              ),
            ],
          );
        });
  }
}
