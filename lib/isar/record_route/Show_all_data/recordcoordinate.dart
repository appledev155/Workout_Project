
import 'package:isar/isar.dart';
part 'recordcoordinate.g.dart';
@Collection()
@Name('recordcoordinate')
class RecordCoordinate {
  // @Index(unique:true)
  Id? id = Isar.autoIncrement;
  String? duration;
  String? date;
  String? distance;
  List<double>? latitude;
  List<double>? longitude;
  RecordCoordinate(
     { this.id,this.duration,this.date,this.distance,this.latitude,this.longitude});
}

