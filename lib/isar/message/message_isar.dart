import 'dart:convert';

import 'package:isar/isar.dart';

part 'message_isar.g.dart';

@collection
@Name("Message")
class MessageIsar {
  @Name("messageId")
  @Index(unique: true)
  String? id;

  Id get isarId => fastHash(id!);

  late String channelName;
  late String message;
  late int messageFromUserId;
  late int timeStamp;

  int fastHash(String string) {
    var hash = 0xcbf29ce484222325;

    var i = 0;
    while (i < string.length) {
      final codeUnit = string.codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }

    return hash;
  }

  @override
  String toString() {
    return '{"id": "$id", "channelName": "$channelName", "message": ${jsonEncode(message)}, "timeStamp": "$timeStamp", "messageFromUserId": $messageFromUserId }';
  }
}
