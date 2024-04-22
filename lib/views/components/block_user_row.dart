import 'package:anytimeworkout/bloc/blocked_users_bloc/blocked_users_bloc.dart';
import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/module/chat/bloc/channel/channel_bloc.dart';
import 'package:anytimeworkout/module/chat/bloc/chat/chat_bloc.dart';
import 'package:anytimeworkout/module/chat/model/chat_model.dart';
import 'package:anytimeworkout/module/chat/repo/chat_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

import '../../bloc/current_user_bloc/current_user_bloc.dart';
import '../../module/chat/config/chat_config.dart';
import '../../module/chat/pages/components/chat_profile_image.dart';
import 'center_loader.dart';

class BlockUserRow extends StatefulWidget {
  final dynamic user;

  const BlockUserRow({super.key, this.user});

  @override
  State<BlockUserRow> createState() => _BlockUserRowState();
}

class _BlockUserRowState extends State<BlockUserRow> {
  // int buttonClickCount = 0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/profile_detail_screen',
            arguments: [widget.user['id'], 'Details']);
      },
      child: Card(
        color: lightColor,
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ListTile(
            leading: ChatProfileImage(
              imagePath: widget.user['photo_url'] ?? "",
              size: 20.0,
              userId: widget.user['id'].toString(),
            ),
            title: Text(
              "${widget.user['displayName'] ?? ""}",
              style: TextStyle(
                  color: blackColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700),
            ),
            trailing: ElevatedButton(
                onPressed: () {
                  showBlockUnblockDialogue(
                      context,
                      widget.user['id'].toString(),
                      widget.user['displayName'] ?? "User");
                },
                child: const Text("Unblock")),
          ),
        ),
      ),
    );
  }

  String lblUnblockConfirmation = "chat_section.lbl_unblock_confirmation".tr();

  Future<void> showBlockUnblockDialogue(
      BuildContext context, String toUserId, String userName) async {
    dynamic currentUserBloc = context.read<CurrentUserBloc>();
    late ChatChannel chatChannel;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "$lblUnblockConfirmation $userName",
              style: const TextStyle(color: blackColor),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  CenterLoader.show(context);
                  dynamic channelName = context
                      .read<ChatBloc>()
                      .generateStaticChannelName(
                          toUserId: toUserId, propRequestId: '');

                  dynamic getChannelDetails = await app_instance.chatApiProvider
                      .getChannelDetailsByName(channelName);

                  if (getChannelDetails != '') {
                    Map<dynamic, dynamic> channelDetails = getChannelDetails
                        .map((key, value) => MapEntry(key, value?.toString()));

                    dynamic chatUser =
                        context.read<CurrentUserBloc>().state.chatUser;

                    dynamic senderInfo;

                    senderInfo = ChatUser(
                      userId: currentUserBloc.state.currentUser!.id.toString(),
                      username:
                          currentUserBloc.state.currentUser!.name.toString(),
                      userImage: currentUserBloc.state.currentUser!.profileImage
                          .toString(),
                      roleTypeId:
                          currentUserBloc.state.currentUser!.roleId.toString(),
                    );

                    ChatUser chatToUser = await ChatRepo(
                            currentUser: context
                                .read<CurrentUserBloc>()
                                .state
                                .currentUser)
                        .getChatUser(userId: toUserId);
                    chatChannel = ChatChannel(
                      channelId: channelDetails['id'].toString(),
                      channelName: channelDetails['friendlyName'],
                      lastMessageRow: MessageRow.empty,
                      typingIndicator: '',
                      lastMessageTime: channelDetails['timetoken'],
                      unreadMessageCount: '0',
                      chatFlag: '1',
                      lastVisitTime: '',
                      channelData: channelDetails['channelData'].toString(),
                      chatUser: senderInfo,
                      chatToUser: [chatToUser],
                      typingIndicatorStartTime: '',
                      disableTypingMessage: '',
                    );
                  }

                  context.read<ChatBloc>().add(SignalSent(
                      currentChannel: chatChannel,
                      signalType: signalType.indexOf('unblock').toString()));

                  context
                      .read<ChannelBloc>()
                      .add(PrivateSubscribe(newChannel: chatChannel));

                  Future.delayed(const Duration(milliseconds: 2000), () {
                    context
                        .read<BlockedUsersBloc>()
                        .add(const BlockedUsersFetched());
                    CenterLoader.hide(context);
                    context.read<ChannelBloc>().add(UpdateSingleChannel(
                        channelName: channelName.toString()));
                    Navigator.popAndPushNamed(context, '/blocked_users');
                  });

                  String lblUnblock =
                      "chat_section.lbl_unblock_successfully".tr();
                  Future.delayed(const Duration(milliseconds: 300), () {
                    Fluttertoast.showToast(
                        msg: "$userName $lblUnblock",
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 5,
                        backgroundColor: blackColor);
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryDark),
                child: const Text("chat_section.lbl_un_unblock").tr(),
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
