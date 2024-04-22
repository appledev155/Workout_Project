import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:isar/isar.dart';

import 'beaconlocation.dart';

class BeaconOperation extends IsarServices{
  insert(BeaconLocation beaconLocation)async{
  final isar=await db;
  await isar.writeTxn(() async{
    await isar.beaconLocations.put(beaconLocation);
  });
  }
  Future<List<BeaconLocation>> getlocationselectedvalue()async{
    final isar=await db;
    final result=await isar.beaconLocations.filter().locationselectedvalueEqualTo(true).findAll();
    return result;
  }
}