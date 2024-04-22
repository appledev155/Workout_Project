import 'dart:convert';
import 'package:anytimeworkout/bloc/current_user_bloc/current_user_bloc.dart';
import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/module/chat/bloc/chat/chat_bloc.dart';
import 'package:anytimeworkout/module/chat/pages/components/single_message_widgets/alert_dialogue.dart';
import 'package:anytimeworkout/module/chat/pages/components/single_message_widgets/call_me_card.dart';
import 'package:anytimeworkout/module/chat/pages/components/single_message_widgets/media_placeholder.dart';
import 'package:anytimeworkout/module/chat/pages/components/single_message_widgets/message_text.dart';
import 'package:anytimeworkout/module/chat/pages/components/single_message_widgets/private_property_widget.dart';
import 'package:anytimeworkout/module/chat/pages/components/single_message_widgets/replied_images_preview.dart';
import 'package:anytimeworkout/module/chat/pages/components/single_message_widgets/single_property_widget.dart';
import 'package:anytimeworkout/module/chat/pages/components/single_message_widgets/url_widget.dart';
import 'package:anytimeworkout/module/chat/pages/components/single_message_widgets/user_name_and_time_stamp.dart';
import 'package:anytimeworkout/model/item_model.dart';
import 'package:anytimeworkout/module/chat/pages/components/single_message_widgets/whatapp_me_card.dart';
import 'package:anytimeworkout/views/components/property_row.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;

import '../../config/chat_config.dart';
import '../../model/chat_model.dart';
import 'package:flutter/material.dart';
import 'chat_profile_image.dart';
import 'single_message_widgets/images_widget.dart';
import 'single_message_widgets/private_property_placeholder.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class SingleMessage extends StatelessWidget {
  final MessageRow? messageRow;
  final MessageRow? previousMessageRow;
  final String currentChannelId;

  SingleMessage(
      {super.key,
      this.messageRow,
      required this.currentChannelId,
      required this.previousMessageRow});
  String propertyImagePath = '';

  final String gifPath = dotenv.env['GifPath'].toString();

  @override
  Widget build(BuildContext context) {
    List<Message> chatCard = [];

    final String? appUserId = BlocProvider.of<CurrentUserBloc>(context)
        .state
        .currentUser
        ?.id
        .toString();

    Message message = messageRow!.message;
    MessageContent? messageContent = message.content == MessageContent.empty
        ? MessageContent.empty
        : message.content;

    String cardType = messageContent!.cardType.toString();
    MessageRow messageRowReply = messageContent.getReplyMessage();

    Widget displayMessageDateTime(MessageRow messageRow, String appUserId) {
      return Text(
        app_instance.utility
            .getMessageTimeInVariousFormat(messageRow.timeStamp),
        locale: const Locale('en', 'US'),
        textAlign: TextAlign.end,
        style: const TextStyle(height: 2, color: fadeGreyColor, fontSize: 11),
        textDirection: ui.TextDirection.ltr,
      );
    }

    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return InkWell(
          onLongPress: () {
            if (currentChannelId != "1" &&
                currentChannelId != "2" &&
                messageContent.getCard() != 'URL' &&
                messageContent.cardType != "text") {
              const SizedBox.shrink();
            } else if (int.parse(currentChannelId) <= 2 &&
                messageRow!.chatUser.userId == appUserId &&
                messageContent.cardType != "text" &&
                messageContent.cardType != 'URL') {
              const SizedBox.shrink();
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialogueWidget(
                    messageRow: messageRow!,
                    currentChannelId: currentChannelId,
                  );
                },
              );
            }
          },
          child: Container(
            margin:
                (cardTypePlaceholderList.contains(messageContent.cardType) ==
                        false)
                    ? const EdgeInsets.only(top: 2, bottom: 5)
                    : const EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: (messageRow!.chatUser.userId == appUserId)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (messageRow!.chatUser.userId != appUserId &&
                        (previousMessageRow!.chatUser.userId !=
                            messageRow!.chatUser.userId))
                    ? ChatProfileImage(
                        imagePath: messageRow!.chatUser.userImage,
                        size: 20.0,
                        userId: (messageRow!.chatUser.userId != "null")
                            ? messageRow!.chatUser.userId
                            : "0",
                      )
                    : const SizedBox.shrink(),
                const SizedBox(width: 7),
                (messageRow!.chatUser.userId != appUserId &&
                        messageRow!.chatUser.userId ==
                            previousMessageRow!.chatUser.userId)
                    ? const SizedBox(width: 43)
                    : const SizedBox.shrink(),
                Column(
                  crossAxisAlignment: (messageRow!.chatUser.userId == appUserId)
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    (previousMessageRow!.chatUser.userId !=
                            messageRow!.chatUser.userId)
                        ? UserNameAndTimeStampWidget(messageRow: messageRow!)
                        : const SizedBox.shrink(),

                    const SizedBox(height: 5),
                    // show reply message in blue background it can be text or url and images
                    if (messageRowReply
                        .message.content!.cardType!.isNotEmpty) ...[
                      showReplyWidget(
                          context, appUserId!, state, messageRowReply),
                    ],
                    Container(
                      constraints: BoxConstraints(
                          minWidth: 98.w,
                          maxWidth: (cardType == "URL")
                              ? MediaQuery.of(context).size.width * 0.8
                              : MediaQuery.of(context).size.width * 0.7),
                      padding: (chatCard.isEmpty)
                          ? (messageContent.cardType == "firstMessage")
                              ? const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0)
                              : EdgeInsets.symmetric(
                                  horizontal: (cardType == "URL") ? 0 : 10,
                                  vertical: 3)
                          : const EdgeInsets.all(0),
                      decoration: decorationWidget(chatCard, appUserId, context,
                          messageContent.cardType.toString()),
                      child: Stack(
                        alignment: (context.locale.toString() == "en_US")
                            ? Alignment.topLeft
                            : Alignment.topRight,
                        children: [
                          if (cardType == 'propertyDetail') ...[
                            PropertyRow(
                              comeFromMessage: true,
                              item: ItemModel.fromJson(
                                jsonDecode(messageContent.data.toString()),
                              ),
                            )
                          ] else if (cardType == 'URL') ...[
                            UrlWidget(
                                messageRow: messageRow!,
                                appUserId: appUserId.toString()) //
                          ] else if (cardType == 'firstMessage') ...[
                            SinglePropertyWidget(
                                messageRow: messageRow!,
                                appUserId: appUserId.toString())
                          ] else if (cardType ==
                              "privatePropertyPlaceholder") ...[
                            PrivatePropertyPlaceholder(
                                messageRow: messageRow!,
                                currentUserId: appUserId!)
                          ] else if (cardType == 'mediaPlaceholder') ...[
                            (messageRow!.chatUser.userId != appUserId)
                                ? const SizedBox.shrink()
                                : MediaPlaceholder(
                                    messageRow: messageRow!,
                                    currentUserId: appUserId!) //
                          ] else if (cardType == 'onlyImages' ||
                              cardType == 'onlyMedia') ...[
                            ImagesWidget(
                                messageRow: messageRow!,
                                currentUserId: appUserId!) //
                          ] else if (cardType == 'privateProperty') ...[
                            PrivatePropertyWidget(
                                privateProperty: messageRow!.message.toString(),
                                appUserId: appUserId.toString())
                          ] else if (cardType == "call") ...[
                            CallMeCard(messageRow: messageRow!)
                          ] else if (cardType == "whatsapp") ...[
                            WhatsAppMeCard(messageRow: messageRow!)
                          ] else ...[
                            MessageText(
                                messageRow: messageRow!,
                                messageData: cardType.toString(),
                                appUserId: appUserId.toString())
                          ],

                          // show time under message
                          (context.locale.toString() == "en_US")
                              ? Positioned(
                                  bottom: (cardType == 'text') ? 0 : 5,
                                  right: (cardType == 'text') ? 0 : 10,
                                  child: displayMessageDateTime(
                                      messageRow!, appUserId!))
                              : Positioned(
                                  bottom: (cardType == 'text') ? 0 : 5,
                                  left: (cardType == 'text') ? 0 : 10,
                                  child: displayMessageDateTime(
                                      messageRow!, appUserId!),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
                (messageRow!.chatUser.userId ==
                            previousMessageRow!.chatUser.userId &&
                        messageRow!.chatUser.userId == appUserId)
                    ? const SizedBox(width: 43)
                    : const SizedBox.shrink(),
                const SizedBox(width: 7),
                (messageRow!.chatUser.userId == appUserId &&
                        (messageRow!.chatUser.userId !=
                            previousMessageRow!.chatUser.userId))
                    ? ChatProfileImage(
                        imagePath: messageRow!.chatUser.userImage,
                        size: 20.0,
                        userId: (messageRow!.chatUser.userId != "null")
                            ? messageRow!.chatUser.userId
                            : "0",
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }

  showReplyWidget(
    BuildContext context,
    String appUserId,
    ChatState state,
    MessageRow messageRowReply,
  ) {
    dynamic decodedUrl;
    if (messageRowReply.message.content!.cardType == "URL") {
      decodedUrl = jsonDecode(messageRowReply.message.content!.data);
    }
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 3, top: 2, bottom: 2),
      constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.1,
          maxWidth: MediaQuery.of(context).size.width * 0.7),
      decoration: BoxDecoration(
        color: fentBlueColor,
        border: Border(
          left: BorderSide(
            color: (messageRow!.chatUser.userId == appUserId)
                ? blueColor
                : fentBlueColor,
            width: 4,
          ),
          right: BorderSide(
            color: (messageRow!.chatUser.userId == appUserId)
                ? fentBlueColor
                : blueColor,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (messageRow!.chatUser.userId == appUserId)
              ? Text(
                  state.toUsers.first.username,
                  style: const TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
                )
              : Text(
                  state.toUsers.last.username,
                  style: const TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
          if (messageRowReply.message.content!.cardType == "onlyMedia") ...[
            RepliedImagesPreview(
                decodedImages: messageRowReply.message.content!.data,
                messageUserName: state.toUsers.first.username)
          ],
          if (messageRowReply.message.content!.cardType == "URL") ...[
            UrlWidget(
                messageRow: messageRowReply,
                appUserId: appUserId.toString(),
                maxLines: 4)
          ],
          if (messageRowReply.message.content!.cardType == "text") ...[
            Text(messageRowReply.message.content!.messageText(),
                style: const TextStyle(color: blackColor)),
          ]
        ],
      ),
    );
  }

  decorationWidget(List<Message> chatCard, String? appUserId,
      BuildContext context, String cardType) {
    dynamic decodedMessageData;
    if (cardType == "URL") {
      decodedMessageData = jsonDecode(messageRow!.message.content!.data);
    }
    return BoxDecoration(
        boxShadow: [
          (cardType == 'firstMessage')
              ? BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                )
              : const BoxShadow(
                  color: transparentColor,
                  spreadRadius: 0,
                  blurRadius: 0,
                  offset: Offset(0, 0),
                )
        ],
        color: (messageRow!.chatUser.userId != appUserId)
            ? (chatCard.isEmpty)
                ? (cardType == "URL" &&
                        decodedMessageData != null &&
                        decodedMessageData.containsKey('html'))
                    ? transparentColor
                    : (cardType == "URL" &&
                            decodedMessageData != null &&
                            decodedMessageData.containsKey('html') == false)
                        ? lightColor
                        : (messageRow!.message != Message.empty &&
                                    cardType == "onlyImages" ||
                                cardType == "onlyMedia" ||
                                cardType == "privateProperty" ||
                                cardType == "propertyDetail" ||
                                cardType == "mediaPlaceholder" ||
                                cardType == "privatePropertyPlaceholder")
                            ? transparentColor
                            : lightColor
                : transparentColor
            : (chatCard.isEmpty)
                ? (messageRow!.message != Message.empty &&
                            cardType == "onlyImages" ||
                        cardType == "onlyMedia" ||
                        cardType == "privateProperty" ||
                        cardType == "propertyDetail" ||
                        cardType == "mediaPlaceholder" ||
                        cardType == "privatePropertyPlaceholder")
                    ? transparentColor
                    : (cardType == "URL" &&
                            decodedMessageData != null &&
                            decodedMessageData.containsKey('html'))
                        ? transparentColor
                        : selfChatBubbleColor
                : transparentColor,
        borderRadius: (messageRow!.chatUser.userId == appUserId)
            ? (context.locale.toString() == "ar_AR")
                ? const BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))
                : const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))
            : (context.locale.toString() == "ar_AR")
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                    topLeft: Radius.circular(25))
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                    topRight: Radius.circular(25)));
  }
}
