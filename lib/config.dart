import 'package:anytimeworkout/config/app_config.dart';
import 'package:anytimeworkout/isar/app_config/app_config_isar.dart';
import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:anytimeworkout/module/utility.dart';
import 'package:anytimeworkout/repository/chat_api_provider.dart';
import 'package:anytimeworkout/repository/contact_repository.dart';
import 'package:anytimeworkout/repository/item_api_provider.dart';
import 'package:anytimeworkout/repository/property_repository.dart';
import 'package:anytimeworkout/repository/property_type_repository.dart';
import 'package:anytimeworkout/repository/user_repository.dart';
import 'package:anytimeworkout/tasks/store_channel_chat.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:anytimeworkout/isar/app_config/app_config.dart' as app_config_store;

import 'isar/message/message_row.dart';

// Api Network Related Variables :
final UserRepository userRepository = UserRepository();
final ItemApiProvider itemApiProvider = ItemApiProvider();
final ChatApiProvider chatApiProvider = ChatApiProvider();
final ContactRepository contactRepository = ContactRepository();
final PropertyRepository propertyRepository = PropertyRepository();
final propertyTypeRepository = PropertyTypeRepository();

// local storage and database related variables :
const FlutterSecureStorage storage = FlutterSecureStorage();
final IsarServices isarServices = IsarServices();

// constant and config related variables :
final AppConfig appConfig = AppConfig();
final Utility utility = Utility();
final Connectivity connectivity = Connectivity();

final app_config_store.AppConfig appConfigStore = app_config_store.AppConfig();
final messageStore = MessageRow();
final appConfigIsar = AppConfigIsar();

final StoreChannelChat storeChannel = StoreChannelChat();
