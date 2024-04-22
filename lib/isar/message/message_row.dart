import 'package:anytimeworkout/isar/message/message_isar.dart';
import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isar/isar.dart';

class MessageRow extends IsarServices {
  Future<void> saveMessage(MessageIsar message) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.messageIsars.put(message);
    });
  }

  Future<List<MessageIsar>> fetchSavedMessage(
      String channelName, int timeStamp) async {
    int messageCountLimit =
        int.parse(dotenv.env['MESSAGE_PER_PAGE'].toString());
    final isar = await db;
    final result = await isar.messageIsars
        .filter()
        .channelNameEqualTo(channelName)
        .and()
        .timeStampLessThan(timeStamp)
        .sortByTimeStampDesc()
        .limit(messageCountLimit)
        .findAll();
    return result;
  }

  Future<List<MessageIsar>> fetchLastMessage(String channelName,
      [int limit = 1]) async {
    final isar = await db;
    final result = await isar.messageIsars
        .filter()
        .channelNameEqualTo(channelName)
        .sortByTimeStampDesc()
        .limit(limit)
        .findAll();
    return result;
  }

  Future<MessageIsar?> getMessageById(String messageId) async {
    final isar = await db;
    Id isarId = fastHash(messageId);
    MessageIsar? result = await isar.messageIsars.get(isarId);
    return result;
  }

  deleteMessage(String messageId) async {
    final isar = await db;
    Id isarId = fastHash(messageId);
    await isar.writeTxn(() async {
      await isar.messageIsars.delete(isarId);
    });
  }

  deleteMessageByMessageId(String messageId) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.messageIsars.deleteById(messageId);
    });
  }

  deleteMessageByChannelName(String channelName) async {
    final isar = await db;
    await isar.messageIsars
        .filter()
        .channelNameEqualTo(channelName)
        .deleteAll();
  }

  clearChatHistory({required List<String> idValues}) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.messageIsars.deleteAllById(idValues);
    });
  }

  // this function is used for only testing purpose - in this function we removing messages from isar db batch of (last 10 messages).
  clearLastTenMessages(String channelName) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.messageIsars
          .filter()
          .channelNameEqualTo(channelName)
          .sortByTimeStampDesc()
          .limit(10)
          .deleteAll();
    });
  }

  clearDeletedUserMessages(String userId) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.messageIsars
          .filter()
          .messageFromUserIdEqualTo(int.parse(userId))
          .deleteAll();
    });
  }

  // delete all stored messages from particular channel
  deleteAllMessagesForPerticularChannel(
      String channelName, int lastMessageTimeStamp) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.messageIsars
          .filter()
          .channelNameEqualTo(channelName)
          .timeStampLessThan(lastMessageTimeStamp)
          .deleteAll();
    });
  }
}
