import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../bloc/current_user_bloc/current_user_bloc.dart';
import '../../../../../config/app_colors.dart';
import '../../../bloc/channel/channel_bloc.dart';
import '../../../bloc/chat/chat_bloc.dart';
import '../../../model/chat_model.dart';

class AlertDialogueWidget extends StatelessWidget {
  final MessageRow messageRow;
  final String currentChannelId;
  const AlertDialogueWidget(
      {super.key, required this.messageRow, required this.currentChannelId});

  @override
  Widget build(BuildContext context) {
    final String? appUserId = BlocProvider.of<CurrentUserBloc>(context)
        .state
        .currentUser
        ?.id
        .toString();

    Message message = messageRow.message;
    MessageContent messageContent =
        MessageContent.fromJson(jsonDecode(message.content.toString()));
    dynamic messageString = messageContent.data;
    String lblMessageReplyTo = 'chat_section.lbl_message_reply_to'.tr();

    return AlertDialog(
      backgroundColor: transparentColor,
      elevation: 0,
      titlePadding: (messageContent.cardType == 'text' ||
              messageContent.cardType == 'URL')
          ? const EdgeInsets.only(top: 10)
          : const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.only(top: 12),
      title: (messageContent.cardType != "onlyMedia")
          ? Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                  color: lightColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: (messageString['text'] != null)
                  ? Text(
                      messageString["text"],
                      style: TextStyle(fontSize: 18.sp),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    )
                  : (messageContent.cardType == 'URL')
                      ? Text(
                          (messageString["url"] != null)
                              ? messageString["url"]
                              : "",
                          style:
                              TextStyle(fontSize: 18.sp, color: primaryColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox.shrink(),
            )
          : const SizedBox.shrink(),
      content: Container(
        decoration: const BoxDecoration(
            color: lightColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: ListBody(
            children: [
              (int.parse(currentChannelId) <= 2 &&
                      messageRow.chatUser.userId != appUserId &&
                      messageRow.chatUser.userId != "null" &&
                      messageRow.chatUser.userId != "0")
                  ? Column(
                      children: [
                        TextButton(
                          onPressed: () => messageReply(
                              context, messageRow, currentChannelId),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(lblMessageReplyTo.tr(),
                                  style: TextStyle(
                                      color: blackColor,
                                      fontSize: 16.sp)), // <-- Text
                              const Spacer(),
                              const Icon(
                                Icons.reply,
                                size: 24.0,
                                color: blackColor,
                              ),
                            ],
                          ),
                        ),
                        (messageContent.cardType == 'text' ||
                                messageContent.cardType == 'URL')
                            ? const Divider()
                            : const SizedBox.shrink(),
                      ],
                    )
                  : const SizedBox.shrink(),
              (messageContent.cardType == 'text' ||
                      messageContent.cardType == 'URL')
                  ? TextButton(
                      onPressed: () async {
                        (messageContent.cardType == 'URL')
                            ? copyShareDialog(
                                context,
                                (messageString['url'] != null)
                                    ? messageString['url'].toString()
                                    : messageString['text'])
                            : copyShareDialog(
                                context, messageString["text"].toString());
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              (messageContent.cardType == 'text')
                                  ? 'chat_section.lbl_copy'.tr()
                                  : "chat_section.lbl_copy_link".tr(),
                              style: TextStyle(
                                  color: blackColor,
                                  fontSize: 16.sp)), // <-- Text
                          const Spacer(),
                          const Icon(
                            Icons.copy,
                            size: 24.0,
                            color: blackColor,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              (messageContent.cardType == 'text' ||
                      messageContent.cardType == 'URL')
                  ? const SizedBox(height: 5)
                  : const SizedBox(height: 0)
            ],
          ),
        ),
      ),
    );
  }

  // copy text
  copyShareDialog(BuildContext context, messageString) {
    Clipboard.setData(ClipboardData(text: messageString.toString()))
        .then((value) {
      Fluttertoast.showToast(msg: "chat_section.msg_copied".tr());
      Navigator.pop(context);
    });
  }

  // reply when long press on message
  void messageReply(
      BuildContext context, MessageRow message, String parentChannelId) {
    // Generate channel name
    String channelName = context.read<ChatBloc>().generateStaticChannelName(
          toUserId: message.chatUser.userId,
          propRequestId: "",
        );

    // Get channel from channel list
    ChatChannel chatChannel = context
        .read<ChannelBloc>()
        .state
        .channelList
        .firstWhere((element) => element.channelName == channelName,
            orElse: () => ChatChannel.empty);
    ChatChannel parentChatChannel = context
        .read<ChannelBloc>()
        .state
        .channelList
        .firstWhere(
            (element) =>
                element.channelId.toString() == parentChannelId.toString(),
            orElse: () => ChatChannel.empty);

    if (chatChannel == ChatChannel.empty) {
      context
          .read<ChannelBloc>()
          .add(UpdateSingleChannel(channelName: channelName));
    }

    context.read<ChatBloc>().add(
          ChatInitiated(
            chatToUser: [message.chatUser],
            currentChannel: chatChannel,
            replyTo: message.toString(),
            replyToChannelId: currentChannelId.toString(),
          ),
        );
    context.read<ChannelBloc>().add(MovedChannelScreen(
        chatChannel: parentChatChannel,
        toUsers: context.read<ChannelBloc>().state.toUsers));

    Navigator.pop(context);
  }
}
