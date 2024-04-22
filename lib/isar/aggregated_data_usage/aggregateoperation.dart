import 'package:anytimeworkout/isar/aggregated_data_usage/aggregate.dart';
import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:isar/isar.dart';

class AggregateOperation extends IsarServices{
  insert(Aggregate aggregate)async{
    final isar=await db;
    await isar.writeTxn(()async{
      await isar.aggregates.put(aggregate);
    });
  }
   Future <List<Aggregate>> getaggregate()async{
  final isar=await db;
  final result=await isar.aggregates.filter().aggregateselectvalueEqualTo(true).findAll();
  print(result);
  return result;
  }
}