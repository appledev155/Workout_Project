import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/data.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/module/chat/bloc/upload_progress_bloc/upload_progress_bloc.dart';
import 'package:anytimeworkout/module/chat/config/chat_config.dart';
import 'package:anytimeworkout/module/chat/model/chat_model.dart';
import 'package:anytimeworkout/module/chat/pages/components/single_message_widgets/replied_images_preview.dart';
import 'package:anytimeworkout/module/chat/pages/components/typing_box_placeholder.dart';
import 'package:anytimeworkout/module/internet/internet.dart';
import 'package:anytimeworkout/views/components/bottom_loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:anytimeworkout/isar/app_config/app_config.dart' as app_config_store;

import 'package:anytimeworkout/config.dart' as app_instance;

import '../../../../bloc/current_user_bloc/current_user_bloc.dart';
import '../../bloc/chat/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TypingBox extends StatefulWidget {
  final ScrollController? scrollController;
  final ChatUser? toUserId;
  final String? channelName;
  final String? chatFlag;
  final String? lastMessageSentTime;

  const TypingBox(
      {super.key,
      this.scrollController,
      this.channelName,
      this.toUserId,
      this.chatFlag,
      this.lastMessageSentTime});

  @override
  State<TypingBox> createState() => _TypingBoxState();
}

class _TypingBoxState extends State<TypingBox> {
  final TextEditingController textFieldController = TextEditingController();
  app_config_store.AppConfig appConfigStore = app_config_store.AppConfig();
  List<dynamic> propertyImages = <dynamic>[];
  int buttonClickCount = 0;
  String verifiedMobileNumber = "";
  dynamic currentUserId;

  @override
  void initState() {
    super.initState();
    getVerifiedMobileNumber();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    bool readOnlyStatus = false;

    return BlocConsumer<ChatBloc, ChatState>(
      buildWhen: (previous, current) =>
          (previous.currentChannel.disableTypingMessage !=
              current.currentChannel.disableTypingMessage) ||
          (previous.replyTo != current.replyTo),
      listener: (context, state) async {},
      builder: (context, state) {
        if (state.disableTypingMessage != "") {
          readOnlyStatus = true;
        }

        currentUserId = BlocProvider.of<CurrentUserBloc>(context)
            .state
            .currentUser
            ?.id
            .toString();

        MessageRow replyMessageRow = MessageRow.empty;
        Message replyMessage = Message.empty;
        MessageContent replyMessageContent = MessageContent.empty;
        dynamic messageObject = {};
        if (state.replyTo.isNotEmpty) {
          replyMessageRow =
              MessageRow.fromJson(jsonDecode(state.replyTo.toString()));
          replyMessage =
              Message.fromJson(jsonDecode(replyMessageRow.message.toString()));
          replyMessageContent = MessageContent.fromJson(
              jsonDecode(replyMessage.content.toString()));
          messageObject = replyMessageContent.data;
        }
        return state.status != ChatStatus.loading ||
                state.status != ChatStatus.initial ||
                state.status != ChatStatus.error ||
                state.status != ChatStatus.paused ||
                state.status != ChatStatus.endChat ||
                state.status != ChatStatus.chatClosed ||
                state.status != ChatStatus.movedToChannel ||
                state.disableTypingMessage == ""
            ? Column(
                children: [
                  if (replyMessageRow != MessageRow.empty &&
                      replyMessageContent.cardType == 'text') ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 5, top: 6, bottom: 6),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: fentBlueColor,
                          border: Border(
                            left: BorderSide(
                              color: blueColor,
                              width: 4,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${'chat_section.lbl_reply_to'.tr()} ${state.toUsers.first.username}...",
                                style: const TextStyle(
                                    color: primaryDark,
                                    fontWeight: FontWeight.bold)),
                            Text(
                              messageObject["text"].toString(),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: const TextStyle(color: blackColor),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                  if (replyMessageRow != MessageRow.empty &&
                      replyMessageContent.cardType == 'onlyMedia') ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 5, top: 6, bottom: 6),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: fentBlueColor,
                          border: Border(
                            left: BorderSide(
                              color: blueColor,
                              width: 4,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                "${'chat_section.lbl_reply_to'.tr()} ${state.toUsers.first.username}...",
                                style: const TextStyle(
                                    color: primaryDark,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),

                            RepliedImagesPreview(
                                decodedImages: jsonEncode(
                                    messageObject)) // reply images preview
                          ],
                        ),
                      ),
                    )
                  ],
                  if (replyMessageRow != MessageRow.empty &&
                      replyMessageContent.cardType == 'URL') ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 5, top: 6, bottom: 6),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: fentBlueColor,
                          border: Border(
                            left: BorderSide(
                              color: blueColor,
                              width: 4,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                "${'chat_section.lbl_reply_to'.tr()} ${state.toUsers.first.username}...",
                                style: const TextStyle(
                                    color: primaryDark,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Text(
                              (messageObject["url"] != null)
                                  ? messageObject["url"].toString()
                                  : messageObject["text"].toString(),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: const TextStyle(color: blackColor),
                            ),

                            // reply images preview
                          ],
                        ),
                      ),
                    )
                  ] else ...[
                    const SizedBox.shrink(),
                  ],
                  Row(
                    children: [
                      // const UploadProgressIndicator(),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 10.0),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(blurRadius: 4.0, color: Colors.grey)
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Row(children: [
                            (state.currentUser.roleTypeId == "4" &&
                                    state.currentChannel.channelId == "2")
                                ? const SizedBox.shrink()
                                : state.disableTypingMessage.isNotEmpty == false
                                    ? IconButton(
                                        constraints:
                                            const BoxConstraints(maxWidth: 40),
                                        iconSize: 30,
                                        onPressed: () async {
                                          if (readOnlyStatus == true) return;
                                          showModalBottomSheet<dynamic>(
                                            useRootNavigator: true,
                                            context: context,
                                            isDismissible: true,
                                            constraints: BoxConstraints(
                                              minWidth: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  20,
                                            ),
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            25.0))),
                                            builder: (_) =>
                                                shareModalBottomSheet(context,
                                                    state.currentChannel),
                                          );
                                        },
                                        icon: const Icon(Icons.add,
                                            color: primaryDark))
                                    : const SizedBox.shrink(),
                            Expanded(
                              child: Padding(
                                padding: (state.currentUser.roleTypeId == "3")
                                    ? const EdgeInsets.only(left: 0)
                                    : const EdgeInsets.only(left: 10),
                                child: FocusScope(
                                  child: Focus(
                                    onFocusChange: (value) => {
                                      if (value == false)
                                        {
                                          BlocProvider.of<ChatBloc>(context)
                                              .add(SignalSent(
                                            currentChannel:
                                                state.currentChannel,
                                            signalType: signalType
                                                .indexOf('typingOff')
                                                .toString(),
                                          ))
                                        }
                                      else
                                        {
                                          BlocProvider.of<ChatBloc>(context)
                                              .add(SignalSent(
                                            currentChannel:
                                                state.currentChannel,
                                            signalType: signalType
                                                .indexOf('typingOn')
                                                .toString(),
                                          ))
                                        }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: TextField(
                                        inputFormatters: [
                                          NoLeadingSpaceFormatter(),
                                        ],
                                        readOnly: readOnlyStatus,
                                        keyboardType: TextInputType.multiline,
                                        minLines: 1,
                                        maxLines: 3,
                                        controller: textFieldController,
                                        onTap: () => {
                                          widget.scrollController!.animateTo(
                                              0.0,
                                              duration: const Duration(
                                                  milliseconds: 10),
                                              curve: Curves.ease)
                                        },
                                        onChanged: (value) {
                                          BlocProvider.of<ChatBloc>(context)
                                              .add(
                                            ChatMessageUpdated(value),
                                          );
                                        },
                                        decoration: InputDecoration(
                                            hintText: (state
                                                        .disableTypingMessage
                                                        .toString() !=
                                                    "")
                                                ? state.disableTypingMessage
                                                    .toString()
                                                : "chat_section.lbl_type_message"
                                                    .tr(),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: primaryDark,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: state.disableTypingMessage.isNotEmpty == false
                            ? IconButton(
                                onPressed: () async {
                                  if (buttonClickCount > 1) return;
                                  if (readOnlyStatus == true) return;
                                  if (textFieldController.text.isEmpty) return;
                                  if (context
                                          .read<InternetBloc>()
                                          .state
                                          .connectionStatus ==
                                      ConnectionStatus.disconnected) {
                                    Fluttertoast.showToast(
                                        msg: "connection.checkConnection".tr(),
                                        toastLength: Toast.LENGTH_SHORT,
                                        timeInSecForIosWeb: 3,
                                        gravity: ToastGravity.BOTTOM);
                                    return;
                                  }
                                  ;

                                  MessageContent textMessage =
                                      MessageContent.empty;

                                  Map<String, dynamic> messageData = {};

                                  if (state.replyTo.isNotEmpty) {
                                    messageData = updateMessageData(state);
                                  }

                                  RegExp exp = RegExp(
                                      r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?');
                                  Iterable<RegExpMatch> matches =
                                      exp.allMatches(textFieldController.text);

                                  if (messageData.runtimeType == Null) {
                                    messageData = {
                                      'text': textFieldController.text.trim(),
                                      'channelId':
                                          state.currentChannel.channelId,
                                    };
                                  } else {
                                    messageData['text'] =
                                        textFieldController.text.trim();
                                  }
                                  textMessage = MessageContent(
                                    cardType:
                                        (matches.isNotEmpty) ? "URL" : "text",
                                    timeStamp: "0",
                                    data: jsonEncode(messageData),
                                  );
                                  // }
                                  if (!textFieldController.text
                                      .startsWith(" ")) {
                                    if (!mounted) return;
                                    if (buttonClickCount < 2) {
                                      BlocProvider.of<ChatBloc>(context).add(
                                        ChatMessageSent(
                                            textMessage, state.currentChannel,
                                            storeInDB: true,
                                            replyTo: (state.replyTo.isNotEmpty)
                                                ? true
                                                : false),
                                      );
                                    }
                                  }
                                  textFieldController.clear();
                                  if (textFieldController.text.isEmpty) {
                                    setState(() {
                                      buttonClickCount = 0;
                                    });
                                  }
                                },
                                icon:
                                    const Icon(Icons.send, color: Colors.white),
                              )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(width: 10)
                    ],
                  ),
                ],
              )
            : (state.disableTypingMessage != "")
                ? TypingBoxPlaceholder()
                : const BottomLoader();
      },
    );
  }

  dynamic updateMessageData(dynamic state) {
    MessageRow decodedReplyToMessage =
        MessageRow.fromJson(jsonDecode(state.replyTo));

    String replyToChannelId = state.replyToChannelId;
    String messageTimeStamp = decodedReplyToMessage.timeStamp;
    String userId = decodedReplyToMessage.chatUser.userId;
    String replyToMessageId = "$userId-$replyToChannelId-$messageTimeStamp";

    dynamic messageData = {
      'channelId': state.currentChannel.channelId,
      'replyTo': state.replyTo,
      'replyToMessageId': replyToMessageId
    };
    return messageData;
  }

  shareModalBottomSheet(BuildContext context, ChatChannel currentChannel) {
    dynamic decodedChannelData =
        jsonDecode(currentChannel.channelData.toString());

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //TO DO Share Property Code
            // (currentChannel.channelId == "1" || currentChannel.channelId == "2")
            //     ? const SizedBox.shrink()
            //     : (channelData['type'] != "private_chat")
            //         ? TextButton.icon(
            //             onPressed: () {
            //               Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                     builder: (context) => AddPrivatePropertyScreen(
            //                       key: widget.key,
            //                       chatChannel: currentChannel,
            //                     ),
            //                   ));
            //             },
            //             icon: const Icon(Icons.add),
            //             label: Text("chat_section.lbl_add_new_real_estate".tr(),
            //                 style: const TextStyle(height: 2, fontSize: 16)))
            //         : const SizedBox.shrink(),

            // TextButton.icon(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => MyPropertiesScreen(
            //                     shareFrom: "1",
            //                     channelName: widget.channelName,
            //                     toUser: widget.toUserId,
            //                   ),
            //               settings:
            //                   const RouteSettings(name: 'my_properties')));
            //     },
            //     icon: const Icon(Icons.attach_file),
            //     label: Text("chat_section.lbl_share_property".tr(),
            //         style: const TextStyle(height: 2, fontSize: 16))),
            pickedButtonWidget(currentChannel, context),
            const Divider(),
            if (decodedChannelData['type'].toString() == "private_chat" &&
                verifiedMobileNumber != null &&
                verifiedMobileNumber != "") ...[
              whatsAppMeButton(currentChannel),
              const Divider(),
              callMeButton(currentChannel),
            ],

            Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("chat_section.lbl_cancel".tr()))),
            )
          ],
        ),
      ),
    );
  }

  getVerifiedMobileNumber() async {
    final data = await app_instance.storage.read(key: 'JWTUser');
    dynamic rec = json.decode(data.toString());
    if (rec.containsKey('phoneNumber') && rec['phoneNumber'] != null) {
      dynamic getDialCode = rec['phoneNumber'].substring(0, 3);
      if (dialCodes.contains(getDialCode.toString())) {
        setState(() {
          verifiedMobileNumber =
              "+971 ${rec['phoneNumber'].toString().substring(1)}";
        });
      } else {
        setState(() {
          verifiedMobileNumber = "+91 ${rec['phoneNumber'].toString()}";
        });
      }
    }
  }

  sendCallWhatsAppCard(
      ChatChannel currentChannel, int cardType, String verifiedPhoneNumber) {
    MessageContent textMessage = MessageContent.empty;
    Map<String, dynamic> messageData = {};
    messageData = {
      'channelId': currentChannel.channelId,
      'userId': currentUserId
    };
    textMessage = MessageContent(
      cardType: (cardType == 1) ? "whatsapp" : "call",
      timeStamp: "0",
      data: jsonEncode(messageData),
    );

    BlocProvider.of<ChatBloc>(context).add(
      ChatMessageSent(textMessage, currentChannel,
          storeInDB: true, replyTo: false),
    );
  }

  callMeButton(ChatChannel currentChannel) {
    return TextButton.icon(
      onPressed: () async {
        if (verifiedMobileNumber != null && verifiedMobileNumber != "") {
          sendCallWhatsAppCard(currentChannel, 2, verifiedMobileNumber);
        }
        if (mounted) {
          Navigator.pop(context);
        }
      },
      icon: const Icon(contactUsIcon),
      label: Text(
        "chat_section.lbl_call_me".tr(),
        style: const TextStyle(height: 2, fontSize: 16),
      ),
    );
  }

  whatsAppMeButton(ChatChannel currentChannel) {
    return TextButton.icon(
        onPressed: () async {
          if (verifiedMobileNumber != null && verifiedMobileNumber != "") {
            sendCallWhatsAppCard(currentChannel, 1, verifiedMobileNumber);
          }
          if (mounted) {
            Navigator.pop(context);
          }
        },
        icon: const Icon(wpIcon),
        label: Text("chat_section.lbl_whatsapp_me".tr(),
            style: const TextStyle(height: 2, fontSize: 16)));
  }

  pickedButtonWidget(ChatChannel currentChannel, BuildContext context) {
    return TextButton.icon(
        onPressed: () async {
          Future.delayed(const Duration(microseconds: 1), () {
            Navigator.pop(context);
          });
          await pickedMedia(currentChannel, context);
        },
        icon: const Icon(galleryIcon),
        label: Text("chat_section.lbl_share_image".tr(),
            style: const TextStyle(height: 2, fontSize: 16)));
  }

  pickedMedia(currentChannel, BuildContext context) async {
    propertyImages.clear();
    final mediaProgressBloc = BlocProvider.of<UploadProgressBloc>(context);
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    try {
      List<dynamic>? selectedImages = [];

      if (Platform.isAndroid) {
        // final directory = await getTemporaryDirectory();
        // directory.delete(recursive: true);
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'png', 'webp', 'bmp', 'HEIC', 'mp4'],
          allowMultiple: app_instance.appConfig.allowMultipleMedia,
        );

        if (result != null) {
          selectedImages = result.paths.map((path) => File(path!)).toList();
        }
      } else {
        selectedImages = await AssetPicker.pickAssets(context,
            pickerConfig: AssetPickerConfig(
              maxAssets:
                  app_instance.appConfig.maxMediaUpload - propertyImages.length,
              requestType: RequestType.all,
            ));
      }

      if (selectedImages != null && selectedImages.isNotEmpty) {
        propertyImages.addAll(selectedImages);
        setState(() {});
      }

      if (selectedImages != null && selectedImages.isNotEmpty) {
        String uniqueTimeStamp =
            app_instance.utility.getUnixTimeStampInPubNubPrecision();
        String uniqueId =
            '${currentChannel.chatUser.userId}-${currentChannel.channelId}-$uniqueTimeStamp';

        print("Picked Image For Unique ID");
        print(uniqueId);
        print("Picked Image For Unique ID");

        dynamic data;
        if (chatBloc.state.replyTo.isNotEmpty) {
          data = updateMessageData(chatBloc.state);
        } else {
          data = chatBloc.state;
        }

        Map<String, dynamic> otherData = {
          "upload_from": "chat",
          "cardType": "onlyMedia",
          "data": (chatBloc.state.replyTo.isNotEmpty)
              ? jsonEncode({
                  "replyToData": jsonEncode(data),
                  "currentChannel": jsonEncode(currentChannel)
                })
              : jsonEncode({"currentChannel": jsonEncode(currentChannel)}),
          "timetoken": uniqueTimeStamp,
          "upload_path":
              'chat-media/channels/${currentChannel.channelId.toString()}/${currentChannel.chatUser.userId}/',
        };

        UploadBox uploadBox = UploadBox(
          uniqueId: uniqueId,
          uploadBoxStatus: UploadBoxStatus.start,
          uploadFiles: await app_instance.utility.getFileList(selectedImages),
          otherData: jsonEncode(otherData),
          progressValue: '0.0',
        );
        List<dynamic> fileList =
            await app_instance.utility.getFileList(selectedImages);
        if (fileList.isNotEmpty) {
          mediaProgressBloc.add(MediaPicked(
            uploadBox: uploadBox,
            chatUser: currentChannel.chatUser,
          ));
        }

        // For Message to display in chat
        if (fileList.isNotEmpty) {
          MessageContent messageContent = MessageContent(
            cardType: "mediaPlaceholder",
            timeStamp: app_instance.utility.getUnixTimeStampInPubNubPrecision(),
            data: (chatBloc.state.replyTo.isNotEmpty)
                ? jsonEncode({
                    "uniqueId": uniqueId,
                    'replyTo': data['replyTo'],
                    "replyToMessageId": data['replyToMessageId'],
                    "uploadFiles": jsonEncode(
                        await app_instance.utility.getFileList(selectedImages)),
                    "mediaForChannel": ChatChannel(
                      channelName: currentChannel.channelName,
                      channelId: currentChannel.channelId,
                      // Kept some item empty just to save message size.
                      chatToUser: [],
                      chatUser: ChatUser.empty,
                      lastMessageRow: MessageRow.empty,
                      lastMessageTime: '',
                      unreadMessageCount: '',
                    ).toString(),
                    "timetoken": uniqueTimeStamp,
                  })
                : jsonEncode({
                    "uniqueId": uniqueId,
                    "uploadFiles": jsonEncode(
                        await app_instance.utility.getFileList(selectedImages)),
                    "mediaForChannel": ChatChannel(
                      channelName: currentChannel.channelName,
                      channelId: currentChannel.channelId,
                      // Kept some item empty just to save message size.
                      chatToUser: [],
                      chatUser: ChatUser.empty,
                      lastMessageRow: MessageRow.empty,
                      lastMessageTime: '',
                      unreadMessageCount: '',
                    ).toString(),
                    "timetoken": uniqueTimeStamp,
                  }),
          );
          MessageContent message = messageContent;
          chatBloc.add(ChatMessageSent(message, currentChannel,
              storeInDB: false, messageId: uniqueId));
        }
      }
    } catch (e, stacktrace) {
      setState(() {});
      if (kDebugMode) {
        print('''Error: $e \n StackTrace: $stacktrace''');
      }
    }
  }
}

// for input formatter which removes leading whitespaces from TextFields
class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final String trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }

    return newValue;
  }
}
