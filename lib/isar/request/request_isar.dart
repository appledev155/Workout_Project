import 'package:isar/isar.dart';

part 'request_isar.g.dart';

@collection
@Name("Request")
class RequestIsar {
  @Name("requestId")
  @Index(unique: true)
  String? id;

  Id get isarId => fastHash(id!);

  late String serverId;
  late String descriptionAr;
  late String descriptionEn;
  late String location;
  late String budget;
  late String phone;
  late int createdAt;
  late int updatedAt;
  late int status;

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
    return '{"id": "$id", "status" : "$status",  "serverId": "$serverId", "descriptionAr": ", $descriptionAr", "descriptionEn": "$descriptionEn", "location": "$location", "budget": "$budget", "phone": "$phone", "createdAt": "$createdAt", "updatedAt": "$updatedAt"}';
  }
}
