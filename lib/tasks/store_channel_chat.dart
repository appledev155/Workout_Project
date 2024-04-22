import 'package:anytimeworkout/isar/message/message_isar.dart';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/module/chat/model/chat_model.dart';
import 'package:anytimeworkout/module/chat/repo/chat_repo.dart';
import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:anytimeworkout/isar/message/message_row.dart' as message_store;

import 'package:anytimeworkout/config.dart' as app_instance;

class StoreChannelChat {
  final message_store.MessageRow messageStore = message_store.MessageRow();

  Future<dynamic> initiateChatObject() async {
    UserModel loggedUser = await app_instance.utility.jwtUser();
    if (loggedUser == UserModel.empty ||
        loggedUser.id == null ||
        loggedUser.id == 0) {
      return false;
    }
    ChatRepo chatRepo = ChatRepo(currentUser: loggedUser);
    return chatRepo;
  }

  getChannelChatStore() async {
    // final IsarServices isarServices = IsarServices();
    // final appConfigStore = app_config_store.AppConfig();

    dynamic getchannelLastSyncTime = await app_instance.appConfigStore
        .fetchConfig(configName: 'channelLastSyncTime');
    if (getchannelLastSyncTime.runtimeType == Null) {
      getchannelLastSyncTime = '0';
    }
    print(getchannelLastSyncTime);

    dynamic chatRepo = await initiateChatObject();
    print("Runtime TYPE : ${chatRepo.runtimeType}");
    if (chatRepo.runtimeType == bool) {
      return;
    }

    // //  get Updates/New Channels and store on local Storage.
    dynamic getChannelList = await chatRepo.getChannels(
        channelLastSyncTime: getchannelLastSyncTime.toString());
    // print("++++++++");
    // print(getChannelList.toString());
    // print("++++++++");

    // await app_instance.appConfigStore.saveAppConfig(app_instance.appConfigIsar
    //   ..configName = "channelLastSyncTime"
    //   ..configValue = app_instance.utility.getUnixTimeStampInPubNubPrecision());

    // If we gets channels then fetch message store on local Storage
    if (getChannelList.runtimeType != Null && getChannelList.isNotEmpty) {
      List<ChatChannel> serverChannelList = getChannelList["channelList"];

      print("serverChannelList: ${serverChannelList.length}");

      for (int i = 0; i < serverChannelList.length; i++) {
        ChatChannel chatChannel = serverChannelList[i];
        List<MessageIsar> storedMessageCollection =
            await messageStore.fetchLastMessage(chatChannel.channelName);

        String getMessageLastSyncTime = '0';

        if (storedMessageCollection.isNotEmpty) {
          getMessageLastSyncTime =
              storedMessageCollection[0].timeStamp.toString();
        }
        await chatRepo.getMessageFromServer(
            chatChannel: chatChannel,
            timeStamp: getMessageLastSyncTime,
            getNewMessages: true);
      }
      print("serverChannelList: ${serverChannelList.length}");
    }
    print('background Call');
  }

  // Called at Channel Chat Screen when new message is received
  storeSingleMessage(ChatRepo chatRepo, ChatChannel chatChannel) async {
    List<MessageIsar> storedMessageCollection =
        await messageStore.fetchLastMessage(chatChannel.channelName);

    String getMessageLastSyncTime = '0';

    if (storedMessageCollection.isNotEmpty) {
      getMessageLastSyncTime = storedMessageCollection[0].timeStamp.toString();
    }
    await chatRepo.getMessageFromServer(
        chatChannel: chatChannel,
        timeStamp: getMessageLastSyncTime,
        getNewMessages: true);
  }
}
