import 'package:isar/isar.dart';
part 'aggregate.g.dart';
@Collection()
@Name("aggregate")
class Aggregate{
  @Index(unique:true)
  Id? id;
  late bool aggregateselectvalue;
  Aggregate({this.id,required this.aggregateselectvalue});
}