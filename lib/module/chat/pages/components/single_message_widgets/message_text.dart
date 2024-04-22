import 'package:anytimeworkout/config/styles.dart';
import 'package:flutter/material.dart';
import '../../../../../config/app_colors.dart';
import '../../../model/chat_model.dart';

class MessageText extends StatelessWidget {
  final MessageRow messageRow;
  final dynamic messageData;
  final String appUserId;

  const MessageText(
      {super.key,
      required this.messageRow,
      required this.messageData,
      required this.appUserId});

  @override
  Widget build(BuildContext context) {
    Message message = messageRow.message;

    MessageContent? messageContent = message.content;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        messageContent!.getStringMessage(),
        textAlign: TextAlign.start,
        style: TextStyle(height: 2, color: blackColor, fontSize: pageTitleSize),
      ),
    );
  }
}
