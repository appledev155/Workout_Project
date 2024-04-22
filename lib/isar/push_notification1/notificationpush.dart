import 'package:isar/isar.dart';
part 'notificationpush.g.dart';
@Collection()
@Name('notificationpush')
class NotificationPush{
  @Index(unique:true)
  Id? id;
  List<String>? acitivities=[];
  List<String>? friends=[];
  List<String>? challenges=[];
  List<String>? clubs=[];
  List<String>? events=[];
  List<String>? posts=[];
  String? dataselectedvalue;
  List<String>? other=[];
 
  NotificationPush({this.id,this.acitivities,this.friends,this.challenges,this.clubs,this.events,this.posts,this.dataselectedvalue,this.other});
} 