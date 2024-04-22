import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/module/chat/bloc/channel/channel_bloc.dart';
import 'package:anytimeworkout/module/chat/pages/components/single_message_widgets/action_button_widget.dart';
import 'package:anytimeworkout/module/chat/pages/components/typing_box_placeholder.dart';
import 'package:anytimeworkout/module/chat/pages/components/typing_indicator.dart';
import 'package:anytimeworkout/module/internet/bloc/internet_bloc.dart';
import 'package:anytimeworkout/module/internet/config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:anytimeworkout/isar/channel/channel.dart' as channel_store;
import 'package:anytimeworkout/isar/message/message_row.dart' as message_store;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../chat/bloc/chat/chat_bloc.dart';

import '../model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/chat_title.dart';
import 'components/single_message_widgets/private_chat_action_button_widget.dart';
import 'components/typing_box.dart';
import 'components/message_list.dart';

class ChatScreen extends StatefulWidget {
  final String? toUserString;
  final ChatChannel? chatChannel;

  const ChatScreen({super.key, this.toUserString, this.chatChannel});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  channel_store.Channel channelStore = channel_store.Channel();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addObserver(this);
  }

  int messageValidation = 0;

  void _onScroll() {
    if (_isTop && context.read<ChatBloc>().state.hasReachedMin == false) {
      if (kDebugMode) {
        print("On the top");
      }
      context.read<ChatBloc>().add(ChatFetched());
    }
  }

  bool get _isTop {
    if (_scrollController.position.extentAfter < 500 &&
        context.read<ChatBloc>().state.status != ChatStatus.loadinghistory) {
      return true;
    }
    return false;
  }

  Future<bool> moveToChannel(ChatState state, channelBlocRead) async {
    if (context.read<InternetBloc>().state.connectionStatus !=
        ConnectionStatus.disconnected) {
      int maximumMessageLimit =
          int.parse(dotenv.env['MAX_MESSAGE_PAUSE'].toString());
      List<MessageRow> firstTenMessages =
          (state.currentChannelThread.length > maximumMessageLimit)
              ? state.currentChannelThread.sublist(
                  (state.currentChannelThread.length - maximumMessageLimit),
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
      context.read<ChatBloc>().add(ResetCurrentChannelThread());
    }
    context.read<ChannelBloc>().add(ResumeEnvelopeStream());
    Navigator.pushNamed(context, '/channel');
    return false;
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ChannelBloc channelBlocRead = BlocProvider.of<ChannelBloc>(context);

    if (context.read<ChatBloc>().state.currentChannel.chatFlag == '0') {
      context.read<ChannelBloc>().add(PrivateSubscribe(
          newChannel: context.read<ChatBloc>().state.currentChannel));
    }

    if (context.read<ChannelBloc>().state.currentActiveChannel.channelId !=
        context.read<ChatBloc>().state.currentChannel.channelId) {
      channelBlocRead.add(SetCurrentActiveChannel(
          currentActiveChannel: context.read<ChatBloc>().state.currentChannel));
    }

    dynamic decodedChannelData =
        (context.read<ChatBloc>().state.currentChannel.channelData != null &&
                context
                    .read<ChatBloc>()
                    .state
                    .currentChannel
                    .channelData!
                    .isNotEmpty)
            ? jsonDecode(context
                .read<ChatBloc>()
                .state
                .currentChannel
                .channelData
                .toString())
            : {};

    return WillPopScope(
      onWillPop: () async {
        moveToChannel(context.read<ChatBloc>().state, channelBlocRead);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 40,
          titleSpacing: 10,
          backgroundColor: Colors.white,
          leading: ModalRoute.of(context)?.canPop == true
              ? IconButton(
                  icon: Icon(
                    (context.locale.toString() == "en_US")
                        ? (Platform.isIOS)
                            ? iosBackButton
                            : backArrow
                        : (context.locale.toString() == "ar_AR")
                            ? (Platform.isIOS)
                                ? iosForwardButton
                                : forwardArrow
                            : iosForwardButton,
                    color: blackColor,
                  ),
                  onPressed: () => moveToChannel(
                      context.read<ChatBloc>().state, channelBlocRead))
              : null,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          actions: <Widget>[
            (context.read<ChatBloc>().state.currentChannel.channelId.isNotEmpty)
                ? (int.parse(context
                            .read<ChatBloc>()
                            .state
                            .currentChannel
                            .channelId) <=
                        2)
                    ? const SizedBox.shrink()
                    : (decodedChannelData['type'] == "private_chat")
                        ? PrivateChatActionButton(
                            decodedChannelData: decodedChannelData)
                        : RequestChatActionButton(
                            decodedChannelData: decodedChannelData)
                : const SizedBox.shrink() // action button widget (three dots)
          ],
          title: BlocConsumer<ChatBloc, ChatState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            listenWhen: (previous, current) =>
                previous.currentChannel.channelName !=
                current.currentChannel.channelName,
            builder: (context, state) {
              return Row(
                children: [
                  (state.toUsers.isNotEmpty)
                      ? ChatTitle(
                          toUser: state.toUsers.first,
                          channelId: state.currentChannel.channelId,
                        )
                      : const SizedBox.shrink(),
                  (decodedChannelData != null)
                      ? (decodedChannelData['type'] == "private_chat")
                          ? Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Image.asset('assets/icon/reply.png',
                                  color: blackColor))
                          : const SizedBox.shrink()
                      : const SizedBox.shrink()
                ],
              );
            },
          ),
        ),
        body: BlocConsumer<ChatBloc, ChatState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return Container(
              color: const Color.fromARGB(255, 240, 240, 240),
              child: Column(
                children: [
                  (state.status == ChatStatus.loading ||
                          state.status == ChatStatus.loadinghistory ||
                          state.status == ChatStatus.loadingNewMessages)
                      ? Center(
                          child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: lightGreyColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text("Updating conversation....")))
                      : const SizedBox.shrink(),
                  MessageList(
                    scrollController: _scrollController,
                    currentChannel: state.currentChannel,
                  ),
                  (state.currentChannel.chatFlag == '1' ||
                          state.currentChannel.chatFlag == '-1')
                      ? const TypingIndicator()
                      : const SizedBox.shrink(),
                  BlocConsumer<InternetBloc, InternetState>(
                    listener: (context, internetState) {},
                    listenWhen: (previous, current) =>
                        previous.connectionStatus != current.connectionStatus,
                    builder: ((context, internetState) {
                      return (internetState.connectionStatus ==
                              ConnectionStatus.disconnected)
                          ? Center(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  "connection.checkConnection".tr(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : (state.disableTypingMessage.isNotEmpty)
                              ? TypingBoxPlaceholder()
                              : (state.status == ChatStatus.movedToChat)
                                  ? const SizedBox.shrink()
                                  : TypingBox(
                                      key: widget.key,
                                      scrollController: _scrollController,
                                      channelName:
                                          state.currentChannel.channelName,
                                      toUserId: state.currentChannel.chatUser,
                                      chatFlag: state.currentChannel.chatFlag,
                                      lastMessageSentTime: state
                                          .currentChannel.lastMessageSentTime,
                                    );
                    }),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
