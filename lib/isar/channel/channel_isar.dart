import 'package:isar/isar.dart';

part 'channel_isar.g.dart';

@collection
@Name("Channel")
class ChannelIsar {
  @Name("channelId")
  @Index(unique: true, replace: true)
  late Id id;

  @Index(unique: true, replace: true)
  late String channelName;

  late int chatUserId;
  late List<int> chatToUserId;
  late String unreadMessageCount;
  late String? chatFlag;
  late String? channelData;
  late String? typingIndicator;
  late String? typingIndicatorStartTime;
  late String lastMessageRow;
  late int lastVisitTime;
  late int lastMessageSentTime;
  late int totalNumberOfMessages;

  @Index()
  late int lastMessageTime;
}
