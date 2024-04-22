import 'package:isar/isar.dart';
part 'beaconlocation.g.dart';
@Name('beaconlocation')
@Collection()
class BeaconLocation{
  @Index(unique:true)
  Id? id;
  late bool locationselectedvalue;
 BeaconLocation({this.id,required this.locationselectedvalue});
}