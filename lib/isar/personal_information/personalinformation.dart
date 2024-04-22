import 'package:isar/isar.dart';
part 'personalinformation.g.dart';
@Name("personalinformation")
@Collection()
class PersonalInformation{
  @Index(unique:true)
  Id? id;
  bool selectedvalue;
  PersonalInformation({this.id,required this.selectedvalue});
}