import 'dart:async';
import 'dart:convert';
import 'package:anytimeworkout/bloc/current_user_bloc/current_user_bloc.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/module/chat/bloc/channel/channel_bloc.dart';
import 'package:anytimeworkout/module/chat/bloc/chat/chat_bloc.dart';
import 'package:anytimeworkout/module/internet/bloc/internet_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/styles.dart';
import '../../model/chat_model.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class ChannelRow extends StatefulWidget {
  final ChatChannel channel;
  final Color cardColor;

  const ChannelRow({
    super.key,
    required this.channel,
    required this.cardColor,
  });

  @override
  State<StatefulWidget> createState() {
    return ChannelRowState();
  }
}

class ChannelRowState extends State<ChannelRow> with WidgetsBindingObserver {
  Color cardColor = lightColor;
  bool isSelected = false;
  AppLifecycleState appLifecycleState = AppLifecycleState.detached;

  static int i = 0;

  toggleSelection() {
    setState(() {
      if (isSelected == true) {
        cardColor = lightColor;
        isSelected = false;
      } else {
        cardColor = primaryColor;
        isSelected = true;
      }
    });
  }

  // function for set card color according to diffrent conditions (select / deselect / block)
  Color setCardColor() {
    dynamic decodedChannelData =
        jsonDecode(widget.channel.channelData.toString());
    if (widget.channel.chatFlag == "0" && isSelected == false) {
      changeCardColorState(lightColor);
    }
    if (widget.channel.chatFlag == "2" && isSelected == true) {
      changeCardColorState(primaryColor);
    }
    if (widget.channel.chatFlag == "2" &&
        isSelected == false &&
        int.parse(widget.channel.channelId) > 2) {
      changeCardColorState(lightGreyColor);
    }
    if (widget.channel.chatFlag == "1" && isSelected == true) {
      changeCardColorState(primaryColor);
    }
    if (widget.channel.chatFlag == "1" && isSelected == false) {
      changeCardColorState(lightColor);
    }

    if (int.parse(widget.channel.chatFlag.toString()) >= 2 &&
        isSelected == false &&
        int.parse(widget.channel.channelId) > 2) {
      if (decodedChannelData['type'] != 'private_chat') {
        changeCardColorState(lightGreyColor);
      } else {
        changeCardColorState(lightColor);
        if (decodedChannelData['leave_block'] != 0) {
          changeCardColorState(lightGreyColor);
        } else {
          changeCardColorState(lightColor);
        }
      }
    }
    if (widget.channel.chatFlag == "3" && isSelected == false) {
      changeCardColorState(lightColor);
    }
    return cardColor;
  }

  // set state of the color variable from single function.
  void changeCardColorState(dynamic color) {
    setState(() {
      cardColor = color;
    });
  }

  dynamic movedOnChatScreen(dynamic currentUser) {
    if (isSelected == false) {
      BlocProvider.of<ChatBloc>(context).add(const ResetChat());
      BlocProvider.of<ChannelBloc>(context).add(MovedOnChatScreen(
          currentActiveChannel: widget.channel,
          connectionStatus:
              context.read<InternetBloc>().state.connectionStatus.toString()));
      String channelName = widget.channel.channelName;

      ChatChannel currentChannel = ChatChannel(
        channelId: widget.channel.channelId.toString(),
        channelName: channelName,
        lastMessageRow: widget.channel.lastMessageRow,
        lastMessageTime: widget.channel.lastMessageTime,
        chatUser: ChatUser(
          userId: currentUser.id.toString(),
          username: currentUser.name.toString(),
          userImage: currentUser.profileImage.toString(),
          roleTypeId: currentUser.roleId.toString(),
        ),
        chatToUser: widget.channel.chatToUser,
        chatFlag: widget.channel.chatFlag,
        unreadMessageCount: "0",
        channelData: widget.channel.channelData,
        lastVisitTime: widget.channel.lastVisitTime,
        lastMessageSentTime: widget.channel.lastMessageSentTime,
        messagesRow: widget.channel.messagesRow,
        disableTypingMessage: widget.channel.disableTypingMessage,
        totalNumberOfMessages: widget.channel.totalNumberOfMessages,
      );

      BlocProvider.of<ChatBloc>(context).add(
        ChatInitiated(
          chatToUser: widget.channel.chatToUser,
          currentChannel: currentChannel,
        ),
      );
      Navigator.pushNamed(
        context,
        '/chatScreen',
      );
      setState(() {});
      return;
    } else {
      setState(() {
        isSelected = false;
        cardColor = lightColor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic decodedChannelData;
    UserModel? currentUser = context.read<CurrentUserBloc>().state.currentUser;
    String currentUserId = currentUser!.id.toString();
    bool isCurrentUserRequest = false;
    String privateMessageLabel = "chat_section.lbl_private_message".tr();
    String requestNoLabel = "chat_section.lbl_request_no".tr();
    String requestId = "";

    if (widget.channel.channelId != "" && widget.channel != ChatChannel.empty) {
      if (int.parse(widget.channel.channelId) > 2) {
        if (widget.channel.channelData != null) {
          decodedChannelData = jsonDecode(widget.channel.channelData!);
          requestId = decodedChannelData['reference_id'].toString();
          try {
            if (decodedChannelData['chat_user'] != null) {
              String ownerUserId =
                  decodedChannelData['chat_user']['0'].toString();
              if (ownerUserId == currentUserId) {
                isCurrentUserRequest = true;
              }
            }
          } catch (e, _) {
            print(_);
            print(
                'Channel Row line number 74 ${e.toString()} ${widget.channel.channelId}');
          }
        }
      }
      // app_instance.storeChannel.storeSingleMessage(
      //     context.read<CurrentUserBloc>().state.chatRepo!, widget.channel);
    }

    return widget.channel.channelId != "" &&
            widget.channel != ChatChannel.empty &&
            widget.channel.lastMessageRow != MessageRow.empty
        ? Card(
            color: setCardColor(),
            elevation: 2.0,
            child: InkWell(
              onTap: () {
                if (isSelected == false) {
                  movedOnChatScreen(currentUser);
                } else {
                  setState(() {
                    isSelected = false;
                  });
                }
              },
              onLongPress: () {
                if (widget.channel.channelId == "1" ||
                    widget.channel.channelId == "2") return;
                toggleSelection();
              },
              child: ListTile(
                  selected: isSelected,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      (widget.channel.lastMessageTime != "")
                          ? Text(
                              style: TextStyle(
                                  locale: const Locale('en'),
                                  fontSize: channelRowTextSize,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: (isSelected == true)
                                      ? lightColor
                                      : greyColor),
                              app_instance.utility
                                  .getMessageTimeInVariousFormat(
                                      widget.channel.lastMessageTime),
                            )
                          : const Text(""),

                      const SizedBox(height: 10),

                      // TO DO : Keep for count for message
                      (isSelected)
                          ? GestureDetector(
                              child: const Icon(trashIcon, color: lightColor),
                              onTap: () {
                                showActivateDeactivateDialog(
                                    context, widget.channel);
                              },
                            )
                          : (widget.channel.unreadMessageCount != "0")
                              ? Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          primaryColor,
                                          primaryColor.withOpacity(0.8),
                                          primaryColor.withOpacity(0.5),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(4.0)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  child: Text(
                                    widget.channel.unreadMessageCount
                                        .toString(),
                                    style: const TextStyle(color: lightColor),
                                  ))
                              : const SizedBox.shrink(),
                    ],
                  ),
                  leading: (int.parse(widget.channel.channelId.toString()) <= 2)
                      ? (int.parse(widget.channel.channelId.toString()) == 1)
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
                      : GestureDetector(
                          onTap: () {
                            if (isSelected == false) {
                              movedOnChatScreen(currentUser);
                            }
                          },
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: transparentColor,
                            child: CachedNetworkImage(
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) {
                                return CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      app_instance.appConfig.staticUserImage),
                                );
                              },
                              imageUrl: (widget
                                          .channel.chatToUser.first.userImage
                                          .toString()
                                          .length >
                                      5)
                                  ? widget.channel.chatToUser.first.userImage
                                      .toString()
                                  : app_instance.appConfig.staticUserImage,
                            ),
                          ),
                        ),
                  title: Wrap(
                    children: [
                      Text(
                        (int.parse(widget.channel.channelId.toString()) <= 2)
                            ? (int.parse(widget.channel.channelId.toString()) ==
                                    1)
                                ? "chat_section.lbl_agents_group".tr()
                                : "chat_section.lbl_members_group".tr()
                            : widget.channel.chatToUser.first.username,
                        style: TextStyle(
                            color:
                                (isSelected == true) ? lightColor : blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      (widget.channel.chatToUser.isNotEmpty &&
                              widget.channel.chatToUser.first.roleTypeId == '3')
                          ? Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Icon(
                                verifyIcon,
                                color: (isSelected == true)
                                    ? lightColor
                                    : blackColor,
                                size: 20,
                              ),
                            )
                          : const SizedBox.shrink(),

                      ((decodedChannelData != null))
                          ? (decodedChannelData['type'].toString() ==
                                  "request_prop")
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text("($requestNoLabel $requestId)",
                                      style: TextStyle(fontSize: 14.sp)))
                              : const SizedBox.shrink()
                          : const SizedBox.shrink(),

                      // For self request blue rounded dot icon.
                      /*  ((decodedChannelData != null))
                    ? (isCurrentUserRequest == true &&
                            decodedChannelData['type'].toString() ==
                                "request_prop")
                        ? Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child:
                            Icon(
                              selfRequestIcon,
                              color: (isSelected == true)
                                  ? lightColor
                                  : primaryColor,
                              size: 20,
                            ),
                            )
                        : const SizedBox.shrink()
                    : const SizedBox.shrink(), */
                      (decodedChannelData != null)
                          ? (decodedChannelData['type'].toString() ==
                                  "private_chat")
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "($privateMessageLabel)",
                                    style: TextStyle(
                                        fontSize: channelRowTextSize,
                                        fontWeight: FontWeight.bold,
                                        color: greyColor),
                                  ),
                                )
                              : const SizedBox.shrink()
                          : const SizedBox.shrink()
                    ],
                  ),
                  subtitle: (widget.channel.typingIndicator.runtimeType !=
                              Null &&
                          widget.channel.typingIndicator != 'null' &&
                          widget.channel.typingIndicator != null &&
                          widget.channel.typingIndicator!.isNotEmpty)
                      ? Text(
                          '${widget.channel.typingIndicator.toString()} ${"chat_section.lbl_is_typing".tr()}',
                          style: const TextStyle(color: Colors.lightGreen))
                      : Text(
                          getLastMessage(currentUser, widget.channel,
                              widget.channel.lastMessageRow),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: channelRowTextSize,
                              fontWeight: FontWeight.bold,
                              color: (isSelected == true)
                                  ? lightColor
                                  : greyColor),
                        )),
            ),
          )
        : const SizedBox.shrink();
  }

  String getLastMessage(
      UserModel currentUser, ChatChannel channel, MessageRow lastMessageRow) {
    return lastMessageRow.message.content!.messageText(
      channel: channel,
      currentUser: ChatUser(
        userId: currentUser.id.toString(),
        username: currentUser.name.toString(),
        userImage: currentUser.profileImage.toString(),
        roleTypeId: currentUser.roleId.toString(),
      ),
    );
  }

  Future<void> showActivateDeactivateDialog(
      BuildContext context, ChatChannel currentChannel) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "chat_section.lbl_delete_channel_confirmation".tr(),
              style: const TextStyle(color: blackColor),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (int.parse(currentChannel.channelId) <= 2) {
                    Navigator.pop(context);
                    return;
                  } else {
                    context
                        .read<ChannelBloc>()
                        .add(DeleteChannel(chatChannel: currentChannel));

                    context.read<ChannelBloc>().add(ChannelResetState());

                    setState(() {
                      isSelected = false;
                      cardColor = lightColor;
                    });

                    Navigator.pop(context);

                    Future.delayed(const Duration(milliseconds: 300), () {
                      Fluttertoast.showToast(
                          msg: "chat_section.lbl_channel_deleted".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIosWeb: 5,
                          backgroundColor: blackColor);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                child: Text("chat_section.lbl_delete".tr()),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    isSelected = false;
                    cardColor = lightColor;
                  });
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: lightColor,
                    side: const BorderSide(color: primaryColor, width: 1)),
                child: Text(
                  "chat_section.lbl_cancel".tr(),
                  style: const TextStyle(color: primaryColor),
                ),
              ),
            ],
          );
        });
  }
}
