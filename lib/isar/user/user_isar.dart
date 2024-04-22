import 'package:isar/isar.dart';

part 'user_isar.g.dart';

@collection
@Name("User")
class UserIsar {
  @Name("userId")
  late Id id;
  late String username;
  late String userImage;
  late String roleTypeId;
  late int publicUpdatedTimeToken;
}
