import 'package:isar/isar.dart';
part 'profile.g.dart';
@Collection()
@Name("profile")
class Profile{
  @Index(unique: true)
  Id? id;
  String selectedValue;
  Profile({this.id,required this.selectedValue});
}