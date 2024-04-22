import 'package:isar/isar.dart';
part 'homelist.g.dart';

@Collection()
@Name('homelist')
class HomeList {
  Id? id = Isar.autoIncrement;
  String? name;
  String? duration;
  String? date;
  String? distance;
  double? latitude;
  double? longitude;
  HomeList(
      {this.id,
      this.name,
      this.date,
      this.distance,
      this.duration,
      this.latitude,
      this.longitude});
}
