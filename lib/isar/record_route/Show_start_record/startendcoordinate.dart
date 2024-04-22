import 'package:isar/isar.dart';
part 'startendcoordinate.g.dart';

@Collection()
@Name('startendcoordinate')
class StartEndCoordinate {
  Id? id = Isar.autoIncrement;
  String? date;
  String? duration;
  String? distance;
  List<double>? startLatlng = [];
  List<double>? endLatlng = [];
  StartEndCoordinate(
      {this.id,
      this.date,
      this.duration,
      this.distance,
      this.startLatlng,
      this.endLatlng});
}
