import 'package:anytimeworkout/isar/activities/activities.dart';
import 'package:anytimeworkout/isar/aggregated_data_usage/aggregate.dart';
import 'package:anytimeworkout/isar/beacon_mobile/beaconlocation.dart';
import 'package:anytimeworkout/isar/channel/channel_isar.dart';
import 'package:anytimeworkout/isar/contact_access/access.dart';
import 'package:anytimeworkout/isar/data_permission/dataPermissionOptions.dart';
import 'package:anytimeworkout/isar/display/display.dart';
import 'package:anytimeworkout/isar/edit_past_activities/activity_visibility/activityvisible.dart';
import 'package:anytimeworkout/isar/edit_past_activities/select_details/selectdetail.dart';
import 'package:anytimeworkout/isar/email_notification/updation.dart';
import 'package:anytimeworkout/isar/feed_ordering/feed.dart';
import 'package:anytimeworkout/isar/flybys/flybys.dart';
import 'package:anytimeworkout/isar/group_activities/groupactivity.dart';
import 'package:anytimeworkout/isar/highlight_media/highlight.dart';
import 'package:anytimeworkout/isar/home_lists/homelist.dart';
import 'package:anytimeworkout/isar/local_legends/local.dart';
import 'package:anytimeworkout/isar/mentions/mention.dart';
import 'package:anytimeworkout/isar/message/message_isar.dart';
import 'package:anytimeworkout/isar/messaging/message.dart';
import 'package:anytimeworkout/isar/messaging_visibility/visible.dart';
import 'package:anytimeworkout/isar/personal_information/personalinformation.dart';
import 'package:anytimeworkout/isar/profile/profile.dart';
import 'package:anytimeworkout/isar/public_photos/sharePhoto.dart';
import 'package:anytimeworkout/isar/record_route/Show_all_data/recordcoordinate.dart';
import 'package:anytimeworkout/isar/record_route/Show_start_record/startendcoordinate.dart';
import 'package:anytimeworkout/isar/request/request_isar.dart';
import 'package:anytimeworkout/isar/user/user_isar.dart';
import 'package:anytimeworkout/isar/app_config/app_config_isar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'push_notification1/notificationpush.dart';

class IsarServices {
  late Future<Isar> db;

  IsarServices() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      try {
        return await Isar.open(
          [
            RequestIsarSchema,
            UserIsarSchema,
            ChannelIsarSchema,
            MessageIsarSchema,
            AppConfigIsarSchema,
            RecordCoordinateSchema,
            StartEndCoordinateSchema,
            ProfileSchema,
            ActivitySchema,
            GroupActivitySchema,
            FlybysSchema,
            LocalSchema,
            MentionSchema,
            MessageSchema,
            HighlightSchema,
            FeedSchema,
            VisibleSchema,
            AggregateSchema,
            PersonalInformationSchema,
            SharePhotoSchema,
            SelectDetailSchema,
            ActivityVisibleSchema,
            DisplaySchema,
            UpdationSchema,
            AccessSchema,
            NotificationPushSchema,
            DataPermissionOptionsSchema,
            BeaconLocationSchema,
            HomeListSchema
          
          ],
          directory: dir.path,
          inspector: dotenv.env['ENVIRONMENT'] == 'local' ? true : false,
        );
      } catch (e) {
        if (kDebugMode) {
          print(e);
          print('Instance has been already opend!');
        }
      }
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  int fastHash(String string) {
    var hash = 0xcbf29ce484222325;

    var i = 0;
    while (i < string.length) {
      final codeUnit = string.codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }

    return hash;
  }
}
