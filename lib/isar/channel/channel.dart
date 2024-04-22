import 'package:anytimeworkout/isar/channel/channel_isar.dart';
import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:isar/isar.dart';

class Channel extends IsarServices {
  Future<void> saveChannel(ChannelIsar channel) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.channelIsars.put(channel);
    });
  }

  updateChannel(Id channelId, ChannelIsar channel) async {
    final isar = await db;
    await isar.writeTxn(() async {
      ChannelIsar? channelCollection = await isar.channelIsars.get(channelId);
      channelCollection!.lastMessageSentTime = channel.lastMessageSentTime;
      channelCollection.lastMessageRow = channel.lastMessageRow;
      await isar.channelIsars.put(channelCollection);
    });
  }

  Stream<dynamic> watchChannel() async* {
    final isar = await db;
    yield* isar.channelIsars.watchLazy();
  }

  Future<int> countChannel() async {
    final isar = await db;
    final result = await isar.channelIsars.count();
    return result;
  }

  compareTypingIndicator() async {
    final isar = await db;
    await isar.channelIsars
        .filter()
        .typingIndicatorStartTimeIsNotEmpty()
        .findAll();
  }

  Future<List<ChannelIsar>> fetchSavedChannel(
      {int offset = 0, int limit = 10}) async {
    final isar = await db;
    final result = await isar.channelIsars
        .filter()
        .channelNameIsNotEmpty()
        .sortByLastMessageTimeDesc()
        .offset(offset)
        .limit(limit)
        .findAll();
    return result;
  }

  // for fetch specific channel lastMessageSentTime by channelId
  Future<String> fetchLastMessageSentTime({required Id channelId}) async {
    final isar = await db;
    final result = await isar.channelIsars.get(channelId);
    if (result != null) {
      return result.lastMessageSentTime.toString();
    } else {
      return "16871555519911730";
    }
  }

  deleteChannel({required Id channelId}) async {
    if (channelId > 2) {
      final isar = await db;
      await isar.writeTxn(() async {
        await isar.channelIsars.delete(channelId);
      });
    }
  }

  // clear deleted user related channels
  clearDeletedUserChannels({required String userId}) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.channelIsars
          .filter()
          .chatUserIdEqualTo(int.parse(userId))
          .deleteAll();
    });

    await isar.writeTxn(() async {
      await isar.channelIsars
          .filter()
          .chatToUserIdElementEqualTo(int.parse(userId))
          .deleteAll();
    });
  }
}
