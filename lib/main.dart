import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:anytimeworkout/bloc/display_list_bloc/display_list_bloc.dart';
import 'package:anytimeworkout/bloc/map_coordinates/map_coordinates_bloc.dart';
import 'package:anytimeworkout/module/display_list/pages/home_page_list.dart';
import 'package:anytimeworkout/module/map/pages/route.dart';
// import 'package:anytimeworkout/module/settings_page/pages/settingPage.dart';
import 'package:anytimeworkout/tasks/store_channel_chat.dart';
import 'package:anytimeworkout/views/screens/result/home_list.dart';
import 'package:anytimeworkout/views/screens/result/map_coordinate.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pubnub/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'firebase_options.dart';

import 'package:anytimeworkout/splash.dart';
import 'package:anytimeworkout/config/data.dart' as globals;
import 'package:anytimeworkout/config.dart' as app_instance;
import 'config/app_colors.dart';

import 'package:anytimeworkout/module/chat/bloc/channel/channel_bloc.dart';
import 'package:anytimeworkout/module/chat/bloc/chat/chat_bloc.dart';
import 'package:anytimeworkout/module/chat/pages/channel_page.dart';
import 'package:anytimeworkout/module/request/bloc/addRequest/add_request_bloc.dart';
import 'package:anytimeworkout/module/request/bloc/my_request/my_request_bloc.dart';
import 'package:anytimeworkout/module/request/pages/add_request_screen.dart';
import 'package:anytimeworkout/module/request/pages/my_request_screen.dart';
import 'package:anytimeworkout/module/chat/bloc/download_image_bloc/download_image_bloc.dart';
import 'package:anytimeworkout/module/chat/bloc/upload_progress_bloc/upload_progress_bloc.dart';
import 'package:anytimeworkout/module/internet/internet.dart';
import 'package:anytimeworkout/module/internet/pages/offline_page.dart';

import 'package:anytimeworkout/views/screens/blocked_users/blocked_users_screen.dart';
import 'package:anytimeworkout/views/screens/setting/add_number_screen_new.dart';
import 'package:anytimeworkout/views/screens/setting/delete_account_screen.dart';
import 'package:anytimeworkout/module/chat/pages/chat_page.dart';
import 'package:anytimeworkout/views/screens/account_upgrade/account_upgrade_screen.dart';
import 'package:anytimeworkout/views/screens/login/signin_screen.dart';
import 'package:anytimeworkout/views/screens/more/more_left_drawer.dart';
import 'package:anytimeworkout/views/screens/profile_detail/agent_property_screen.dart';
import 'package:anytimeworkout/views/screens/profile_detail/profile_detail_screen.dart';
import 'package:anytimeworkout/views/screens/setting/search_api_screen.dart';
import 'package:anytimeworkout/views/components/check_internet.dart';
import 'package:anytimeworkout/views/screens/my_properties/add_property_type_screen.dart';
import 'package:anytimeworkout/views/screens/visitor/visitors_start_map.dart';

import './bloc/login_form/login_form_bloc.dart';
import './views/screens/setting/phone_verification_screen.dart';
import './views/screens/requirement/payment_confirmation_screen.dart';
import './views/screens/requirement/request_review_screen.dart';
import './navigation_route/back_gesture_width_theme.dart';
import './navigation_route/cupertino_page_transitions_builder.dart';
import 'bloc/setting/bloc/add_form_bloc.dart';

/// view import
import './views/screens/search/search_screen.dart';
import './views/screens/contact/contact_screen.dart';
import './views/screens/login/login_screen.dart';
import './views/screens/setting/setting_screen.dart';
import './views/screens/my_properties/add_screen.dart';
import './views/screens/about/about_screen.dart';
import './views/screens/saved/saved_screen.dart';

/// repository import
import './repository/property_type_repository.dart';

/// bloc import
import 'package:anytimeworkout/bloc/account_upgrade_bloc/account_upgrade_bloc.dart';
import 'package:anytimeworkout/bloc/agent_detail/agent_detail_bloc.dart';
import 'package:anytimeworkout/bloc/agent_property_bloc/agent_property_bloc.dart';
import 'package:anytimeworkout/bloc/blocked_users_bloc/blocked_users_bloc.dart';
import 'package:anytimeworkout/bloc/current_user_bloc/current_user_bloc.dart';
import 'package:anytimeworkout/bloc/search_result/search_result_bloc.dart';
import 'package:anytimeworkout/bloc/login_form/forgot_form_bloc.dart';
import 'package:anytimeworkout/bloc/setting/verified_number_form_bloc.dart';
import 'package:anytimeworkout/bloc/contact_form/contact_form_bloc.dart';
import 'package:anytimeworkout/bloc/favorite/favorite_bloc.dart';
import 'package:anytimeworkout/bloc/my_properties/add/add_form_bloc.dart';
import 'package:anytimeworkout/bloc/my_properties/rent/rent_bloc.dart';
import 'package:anytimeworkout/bloc/my_properties/sale/sale_bloc.dart';
import 'package:anytimeworkout/bloc/saved/saved_bloc.dart';
import 'package:anytimeworkout/bloc/login_form/register_form_bloc.dart';
import 'package:anytimeworkout/bloc/setting/basic_info_form_bloc.dart';
import 'package:anytimeworkout/bloc/setting/change_password_form_bloc.dart';
import 'package:anytimeworkout/bloc/setting/otp_form_bloc.dart';
import 'package:anytimeworkout/bloc/setting/verification_form_bloc.dart';

import 'model/user_model.dart';

import 'views/components/notify.dart';
import 'views/screens/login/forgot_screen.dart';
import 'views/screens/login/register_screen.dart';
import 'views/screens/result/result_screen.dart';
import 'views/screens/setting/basic_info_screen.dart';
import 'views/screens/setting/change_password_screen.dart';
import 'views/screens/setting/otp_screen.dart';
import 'views/screens/setting/verifed_number_screen.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (kDebugMode) {
      if (bloc.state.toString().contains('status') == true) {
        try {
          print('the current bloc state ${bloc.state?.status.toString()}');
        } catch (e, stackTrace) {
          print(e);
        }
      }
    }
    super.onTransition(bloc, transition);
  }
}

StreamController<int> streamController = StreamController<int>.broadcast();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
String? resetSearch;
dynamic params;
bool isData = true;
late dynamic pn;
late UserModel loggedUser;
late String? token;
dynamic environment;

// VM Entry Point functions Start
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
}

@pragma('vm:entry-point')
void onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) {}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  // DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually
  await dotenv.load(fileName: 'assets/.env');

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // Task do not use in the App.
  final StoreChannelChat storeChannel = StoreChannelChat();

  // bring to foreground
  Timer.periodic(const Duration(seconds: 20), (timer) async {
    print("Background Process for storing new channel and message");
    // await storeChannel.getChannelChatStore();
    // // OPTIONAL for use custom notification
    // // the notification id must be equals with AndroidConfiguration when you call configure() method.
    // flutterLocalNotificationsPlugin.show(
    //   888,
    //   'COOL SERVICE',
    //   'Awesome ${DateTime.now()}',
    //   const NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       'my_foreground',
    //       'MY FOREGROUND SERVICE',
    //       icon: '@drawable/icon',
    //       ongoing: true,
    //     ),
    //   ),
    // );

    // /// you can see this log in logcat
    // print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    // // test using external plugin
    // final deviceInfo = DeviceInfoPlugin();
    // String? device;
    // if (Platform.isAndroid) {
    //   final androidInfo = await deviceInfo.androidInfo;
    //   device = androidInfo.model;
    // }

    // if (Platform.isIOS) {
    //   final iosInfo = await deviceInfo.iosInfo;
    //   device = iosInfo.model;
    // }

    // service.invoke(
    //   'update',
    //   {
    //     "current_date": DateTime.now().toIso8601String(),
    //     "device": device,
    //   },
    // );
  });
}
// VM Entry Point functions End

late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('icon');

IOSInitializationSettings iosInitializationSettings =
    const IOSInitializationSettings(
  requestAlertPermission: true,
  requestBadgePermission: true,
  requestSoundPermission: true,
  onDidReceiveLocalNotification: onDidReceiveLocalNotification,
);

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    iOS: IOSInitializationSettings(),
    android: initializationSettingsAndroid,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String? payload) async {
      navigatorKey.currentState!
          .pushNamed('/message', arguments: {"fromNotification": true});
      if (payload != null) {
        if (kDebugMode) {
          print('notification payload: $payload');
        }
      }
    },
  );

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void displayNotificationPopup(
    dynamic remoteData, AndroidNotificationChannel channel) {
  flutterLocalNotificationsPlugin.show(
    int.parse(remoteData['id']),
    remoteData['title'],
    remoteData['body'],
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        icon: '@drawable/icon',
      ),
    ),
  );
}

void showFlutterNotification(RemoteMessage message) async {
  dynamic remoteData = message.data;
  if (remoteData != null && !kIsWeb) {
    if (kDebugMode) {
      print("notification received = ${remoteData.toString()}");
    }
    // Update the badge count for flutter
    FlutterAppBadger.updateBadgeCount(1);
    UserModel loggedUser = await app_instance.utility.jwtUser();
    if (loggedUser.id.toString() == remoteData['userId'].toString()) {
      if (remoteData['title'].toString() == "Unread messages") {
        displayNotificationPopup(remoteData, channel);
      } else if (remoteData['title'].toString() != "Unread messages") {
        displayNotificationPopup(remoteData, channel);
      }
    } else if (remoteData['userId'].toString() == "0") {
      displayNotificationPopup(remoteData, channel);
    }
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

// this will be used as notification channel id
const notificationChannelId = 'my_foreground';

// this will be used for notification id, So you can update your custom notification with this id.
const notificationId = 888;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: IOSInitializationSettings(),
        android: AndroidInitializationSettings('icon'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

Future<void> main() async {
  await dotenv.load(fileName: 'assets/.env');

  await EasyLocalization.ensureInitialized();
  final getLoggedInUser = await app_instance.storage.read(key: 'JWTUser');
  dynamic decodedLoggedUser =
      (getLoggedInUser != null) ? jsonDecode(getLoggedInUser) : UserModel.empty;
  if (decodedLoggedUser != UserModel.empty) {
    token = decodedLoggedUser['token'].toString();
  } else {
    token = null;
  }
  if (token != null) {
    dynamic userData = await json.decode(getLoggedInUser.toString());
    loggedUser = UserModel.recJson(userData);
  } else {
    loggedUser = UserModel.empty;
  }

  if (dotenv.env['ENVIRONMENT'] == 'local') {
    Bloc.observer = SimpleBlocObserver();
  }
  environment = dotenv.env['ENVIRONMENT'];

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await initializeService();

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
    if (!kIsWeb) {
      await setupFlutterNotifications();
    }
    // final firebaseCrashlytics = FirebaseCrashlytics.instance;
    // Crashlytics Error Handling
    if (environment != "local") {
      String userIdentifier;
      if (loggedUser != UserModel.empty) {
        userIdentifier = loggedUser.id.toString();
      } else {
        userIdentifier = "NEW-${DateTime.now().millisecondsSinceEpoch}";
      }

      // firebaseCrashlytics.setUserIdentifier(userIdentifier);
      // firebaseCrashlytics.setCustomKey('ENVIROMENT', environment.toString());
      // firebaseCrashlytics.setCrashlyticsCollectionEnabled(true);

      // FlutterError.onError = firebaseCrashlytics.recordFlutterFatalError;
      // FlutterError.onError = (errorDetails) {
      //   firebaseCrashlytics.recordFlutterFatalError(errorDetails);
      // };
      // // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      // PlatformDispatcher.instance.onError = (error, stack) {
      //   firebaseCrashlytics.recordError(error, stack, fatal: true);
      //   return true;
      // };
    }
    // Crashlytics Error Handling

    // For debugging Pubnub
    // final logger = StreamLogger.root('myApp', logLevel: Level.all);
    // logger.stream.listen(LogRecord.defaultPrinter);
    // provideLogger(logger, () async {
    //   runApp(EasyLocalization(
    //     supportedLocales: const [Locale('en', 'US'), Locale('ar', 'AR')],
    //     path: 'assets/translations', // <-- change patch to your
    //     fallbackLocale: const Locale('ar', 'AR'),
    //     startLocale: const Locale('ar', 'AR'),
    //     useOnlyLangCode: true,
    //     child: const MyApp(),
    //   ));
    // });

    runApp(EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('en', 'US')],
      path: 'assets/translations', // <-- change patch to your
      fallbackLocale: const Locale('en', 'US'),
      startLocale: const Locale('en', 'US'),
      useOnlyLangCode: true,
      child: const MyApp(),
    ));
    bool isLogin = await Notify().checkLogin();
  }, (error, stack) {
    print('$error \n $stack');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (globals.notifykey == '') {
      globals.notifykey = navigatorKey;
    }

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild!.unfocus();
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<InternetBloc>(
            create: (context) => InternetBloc(connectivity: Connectivity())
              ..add(InternetConnected(connectionType: ConnectionType.unknown)),
          ),
          BlocProvider<DisplayListBloc>(
            create: (context) => DisplayListBloc()..add(const FetchIsarData()),
          ),
          BlocProvider<MapCoordinatesBloc>(
            create: (context) =>
                MapCoordinatesBloc()..add(const FetchMapData()),
          ),
          BlocProvider<UploadProgressBloc>(
            create: (context) => UploadProgressBloc(),
          ),
          BlocProvider<CurrentUserBloc>(
            create: (context) => CurrentUserBloc(
                loggedUser: loggedUser,
                uploadProgressBloc: context.read<UploadProgressBloc>()),
          ),
          BlocProvider<SearchResultBloc>(
            create: (BuildContext context) =>
                SearchResultBloc()..add(SearchResultFetched()),
          ),
          BlocProvider<SearchResultBloc>(
            create: (BuildContext context) =>
                SearchResultBloc()..add(SearchAgentResultFetched()),
          ),
          BlocProvider<FavoriteBloc>(
            create: (BuildContext context) =>
                FavoriteBloc()..add(FavoriteFetched()),
          ),
          BlocProvider<SaleBloc>(
            create: (BuildContext context) => SaleBloc()..add(SaleFetched()),
          ),
          BlocProvider<RentBloc>(
            create: (BuildContext context) => RentBloc()..add(RentFetched()),
          ),
          BlocProvider<ChannelBloc>(
              create: (context) => ChannelBloc(
                  currentUserBloc: context.read<CurrentUserBloc>())),
          BlocProvider<MyRequestBloc>(
            create: (BuildContext context) =>
                MyRequestBloc(currentUserBloc: context.read<CurrentUserBloc>()),
          ),
          BlocProvider<ChatBloc>(
            create: (context) => ChatBloc(
                currentUserBloc: context.read<CurrentUserBloc>(),
                channelBloc: context.read<ChannelBloc>(),
                uploadProgressBloc: context.read<UploadProgressBloc>())
              ..add(const ResetChat()),
          ),
          BlocProvider<DownloadImageBloc>(
            create: (context) => DownloadImageBloc(),
          ),
          BlocProvider<BlockedUsersBloc>(
            create: (context) => BlockedUsersBloc(),
          ),
          BlocProvider<AddFormBlocNew>(
            create: (context) => AddFormBlocNew(),
          ),
        ],
        child: const Aqar(),
      ),
    );
  }
}

class Aqar extends StatelessWidget {
  const Aqar({super.key});

  // String? initialMessage;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          systemNavigationBarColor: lightColor,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarColor: lightColor,
          statusBarIconBrightness: Brightness.dark),
      // ignore: missing_required_param

      child: BlocListener<InternetBloc, InternetState>(
        listenWhen: (previous, current) =>
            previous.connectionSpeed != current.connectionSpeed,
        listener: (context, state) async {
          // If internet connected then fetch the channels from the server
          if (state.connectionStatus != ConnectionStatus.disconnected &&
              state.connectionSpeed > 0.001) {
            if (state.connectionSpeed <= 0.009) {
              app_instance.appConfig.numberOfRecords = 100;
              app_instance.appConfig.algoliaTimeOut = 60;
            }
            if (state.connectionSpeed > 0.009) {
              app_instance.appConfig.numberOfRecords = 500;
              app_instance.appConfig.algoliaTimeOut = 30;
            }

            if (app_instance.appConfig.firstBoot == false) {
              context
                  .read<CurrentUserBloc>()
                  .add(const GetPushNotificatoinPermission());

              if (int.parse(context
                      .read<CurrentUserBloc>()
                      .state
                      .currentUser!
                      .id
                      .toString()) >
                  0) {
                context.read<CurrentUserBloc>().add(IsAuthorized(
                      loggedUser,
                    ));
                // Future.delayed(const Duration(milliseconds: 10000), () {
                context.read<ChannelBloc>().add(
                      const FetchFromStore(status: ChannelStatus.initial),
                    );
                // });
                app_instance.appConfig.firstBoot = true;
              }
            }
          }
          context.read<InternetBloc>().add(BootApplication());
          if (state.connectionStatus == ConnectionStatus.disconnected) {
            if (app_instance.appConfig.displayToastMessage == true) {
              Fluttertoast.showToast(
                  msg: "connection.checkConnection".tr(),
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 3,
                  gravity: ToastGravity.BOTTOM);
            }
          }
        },
        child: StreamProvider<ConnectivityStatus>(
          initialData: ConnectivityStatus.Cellular,
          create: (context) =>
              CheckInternet().connectionStatusController.stream,
          child: BlocConsumer<CurrentUserBloc, CurrentUserState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.currentUser!.id != 0) {
                context.read<ChatBloc>().add(const ResetChat());
                context.read<ChannelBloc>().add(ChannelResetState());

                // Required Stable Internet connection
                if (context.read<InternetBloc>().state.connectionStatus !=
                        ConnectionStatus.disconnected &&
                    context.read<InternetBloc>().state.connectionSpeed >
                        0.001) {
                  context
                      .read<ChannelBloc>()
                      .add(const FetchFromStore(status: ChannelStatus.initial));
                  if (kDebugMode) {
                    print(
                        "Here we are sycing the channels ${state.currentUser!.id}");
                  }
                }
              }
            },
            builder: (context, state) {
              return BackGestureWidthTheme(
                backGestureWidth: BackGestureWidth.fixed(80),
                child: ScreenUtilInit(
                  minTextAdapt: true,
                  designSize: Size(app_instance.appConfig.designWidth,
                      app_instance.appConfig.designHeight),
                  builder: (context, widget) => ChangeNotifierProvider(
                    create: (_) => UserInfo(),
                    child: MaterialApp(
                      builder: (context, widget) {
                        return widget!;
                      },
                      navigatorKey: navigatorKey,
                      localizationsDelegates: context.localizationDelegates,
                      supportedLocales: context.supportedLocales,
                      locale: context.locale,
                      debugShowCheckedModeBanner: false,
                      title: 'Welcome to ANYTIME WORKOUT',
                      theme: ThemeData(
                        primarySwatch: const MaterialColor(0xff096CAD, {
                          50: Color(0xff096CAD),
                          100: Color(0xff096CAD),
                          200: Color(0xff096CAD),
                          300: Color(0xff096CAD),
                          400: Color(0xff096CAD),
                          500: Color(0xff096CAD),
                          600: Color(0xff096CAD),
                          700: Color(0xff096CAD),
                          800: Color(0xff096CAD),
                          900: Color(0xff096CAD),
                        }),
                        fontFamily: 'DM Sans',
                        pageTransitionsTheme: const PageTransitionsTheme(
                          builders: {
                            TargetPlatform.android:
                                CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
                            TargetPlatform.iOS:
                                CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
                          },
                        ),
                      ),
                      initialRoute: '/',
                      onGenerateRoute: (settings) {
                        if (settings.name == '/') {
                          return PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const Splash(),
                              settings: settings);
                        } else if (settings.name == '/search_result') {
                          dynamic params;

                          if (settings.arguments != null) {
                            params = settings.arguments;
                          } else {
                            params = [2, true];
                          }

                          // return PageRouteBuilder(
                          //     transitionDuration: const Duration(seconds: 0),
                          //     pageBuilder: (_, __, ___) =>
                          //         BlocProvider<DisplayListBloc>(
                          //             create: (context) => DisplayListBloc()
                          //               ..add(const FetchIsarData()),
                          //             child: const HomePageView()),
                          //     settings: settings);

                          return PageRouteBuilder(
                              transitionDuration: const Duration(seconds: 0),
                              pageBuilder: (_, __, ___) =>
                                  BlocProvider<MapCoordinatesBloc>(
                                      create: (context) => MapCoordinatesBloc()
                                        ..add(const FetchMapData()),
                                      child: MapCoordinate()),
                              settings: settings);
                        } else if (settings.name == '/setting') {
                          return PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const SettingScreen(),
                              // const SettingPage(),
                              // const SettingScreen(),
                              settings: settings);
                        } else if (settings.name == '/message') {
                          Map<String, dynamic> params =
                              settings.arguments as Map<String, dynamic>;
                          return PageRouteBuilder(
                              pageBuilder: (_, __, ___) => ChannelPage(
                                    fromNotification:
                                        params['fromNotification'],
                                  ),
                              settings: settings);
                        } else if (settings.name == '/chatScreen') {
                          return PageRouteBuilder(
                              transitionDuration: const Duration(seconds: 0),
                              pageBuilder: (_, __, ___) => const ChatScreen(),
                              settings: settings);
                        } /*  else if (settings.name == '/request_screen') {
                                  return PageRouteBuilder(
                                    transitionDuration: const Duration(seconds: 0),
                                    pageBuilder: (_, __, ___) => BlocProvider<RequestBloc>(
                                      create: (context) =>
                                          RequestBloc()..add(RequestFetched()),
                                      child: RequestsScreen(
                                          // status: 1,
                                          ),
                                    ),
                                  );
                                 */
                        else if (settings.name == '/search_screen') {
                          return PageRouteBuilder(
                            pageBuilder: (
                              BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                            ) =>
                                const SearchScreen(),
                            transitionsBuilder: (
                              BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                              Widget child,
                            ) =>
                                SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 1),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        } else if (settings.name == '/profile_detail_screen') {
                          List params = settings.arguments as List;
                          return PageRouteBuilder(
                              transitionDuration: const Duration(seconds: 0),
                              pageBuilder: (_, __, ___) =>
                                  BlocProvider<AgentDetailBloc>(
                                      create: (BuildContext context) =>
                                          AgentDetailBloc()
                                            ..add(AgentDetailFetched(
                                                userId: params[0] as int)),
                                      child: ProfileDetailScreen(
                                        userId: params[0] as int,
                                        currentScreen: params[1],
                                      )));
                        } else if (settings.name == '/agent_property_screen') {
                          List params = settings.arguments as List;
                          return PageRouteBuilder(
                              transitionDuration: const Duration(seconds: 0),
                              pageBuilder: (_, __, ___) =>
                                  BlocProvider<AgentPropertyBloc>(
                                    create: (BuildContext context) =>
                                        AgentPropertyBloc()
                                          ..add(AgentPropertyFetched(
                                              userId: params[4] as int,
                                              buyRentType: params[0],
                                              propertyTypeId: params[1],
                                              propertyType: params[2])),
                                    child: AgentPropertyScreen(
                                      title: params[3],
                                    ),
                                  ));
                        }
                        return null;
                      },
                      routes: {
                        // '/home_page': (context) =>
                        //     BlocProvider<DisplayListBloc>(
                        //       create: (context) =>
                        //           DisplayListBloc()..add(const FetchIsarData()),
                        //       child: const HomePageView(),
                        //     ),
                        '/map_cor_page': (context) =>
                            BlocProvider<MapCoordinatesBloc>(
                              create: (context) => MapCoordinatesBloc()
                                ..add(const FetchMapData()),
                              child: MapCoordinate(),
                            ),
                        '/about': (context) => const AboutScreen(),
                        '/search': (context) => const SearchScreen(),
                        '/contact': (context) => BlocProvider<ContactFormBloc>(
                              create: (context) => ContactFormBloc(),
                              child: ContactScreen(),
                            ),
                        "/blocked_users": (context) =>
                            BlocProvider<BlockedUsersBloc>(
                                create: (context) => BlockedUsersBloc()
                                  ..add(const BlockedUsersFetched(
                                      status: BlockedUsersStatus.initial)),
                                child: const BlockedUsersScreen()),
                        '/login': (context) => BlocProvider<LoginFormBloc>(
                            create: (context) => LoginFormBloc(),
                            child: const LoginScreen()),
                        '/signin': (context) => BlocProvider<LoginFormBloc>(
                            create: (context) => LoginFormBloc(),
                            child: SigninScreen()),
                        '/register': (context) =>
                            BlocProvider<RegisterFormBloc>(
                                create: (context) => RegisterFormBloc(),
                                child: RegisterScreen()),
                        '/verify_new_number': (context) =>
                            BlocProvider<VerificationScreenBloc>(
                                create: (context) => VerificationScreenBloc(),
                                child: const PhoneVerificationScreen()),
                        '/verfied_numbers': (context) =>
                            BlocProvider<VerifiedNumberFormBloc>(
                                create: (context) => VerifiedNumberFormBloc(),
                                child: const VerifedNumberScreen()),
                        '/add_new_number': (context) =>
                            /*  BlocProvider<AddNumberFormBloc>(
                                    create: (context) => AddNumberFormBloc(),
                                    child: const AddNumberScreen()), */
                            BlocProvider<AddFormBlocNew>(
                                create: (context) => AddFormBlocNew(),
                                child: const AddNumberScreenNew()),
                        '/change_password': (context) =>
                            BlocProvider<ChangePasswordFormBloc>(
                                create: (context) => ChangePasswordFormBloc(),
                                child: const ChangePasswordScreen()),
                        '/forgot_password': (context) =>
                            BlocProvider<ForgotFormBloc>(
                                create: (context) => ForgotFormBloc(),
                                child: const ForgotScreen()),
                        '/saved_search': (context) => BlocProvider<SavedBloc>(
                              create: (context) =>
                                  SavedBloc()..add(SavedFetched()),
                              child: SavedScreen(),
                            ),
                        '/add_properties': (context) =>
                            BlocProvider<AddFormBloc>(
                              create: (context) => AddFormBloc(),
                              child: AddScreen(
                                privateProperty: "0",
                              ),
                            ),
                        '/add_property_type': (context) =>
                            AddPropertyTypeScreen(),
                        '/add_request': (context) => /* VisitorAddRequest() */
                            BlocProvider<AddRequestBloc>(
                              create: (context) => AddRequestBloc(),
                              child: const AddRequestScreen(),
                            ),
                        '/upgrade_account': (context) => BlocProvider(
                              create: (context) => AccountUpgradeBloc()
                                ..add(const CheckAccountUpgradeVerification()),
                              child: AccountUpgradeScreen(),
                            ),
                        '/review_request': (context) =>
                            const RequestReviewScreen(),
                        '/map_page': (context) => MapPage(),
                        // '/my_requests_screen': (context) =>
                        //     BlocProvider<MyRequestBloc>(
                        //       create: (context) => MyRequestBloc(
                        //           currentUserBloc:
                        //               context.read<CurrentUserBloc>())
                        //         ..add(MyRequestFetched(
                        //             status: MyRequestStatus.initial,
                        //             hasReachedMaxRequest: false)),
                        //       child: const MyRequestsScreen(),
                        //     ),
                        '/payment_screen': (context) =>
                            PaymentConfirmationScreen(),
                        '/basic_info': (context) =>
                            BlocProvider<BasicInfoFormBloc>(
                                create: (context) => BasicInfoFormBloc(),
                                child: const BasicInfoScreen()),
                        '/delete_account': (context) => DeleteAccount(),
                        '/otp_screen': (context) => BlocProvider<OtpFormBloc>(
                            create: (context) => OtpFormBloc(),
                            child: const OtpScreen()),
                        '/search_api_screen': (context) => SearchApiScreen(),
                        '/more_drawer': (context) => const MoreDrawer(),
                        '/visitor-startmap': (context) =>
                            const VisitorStartMap(),
                        '/channel': (context) => const ChannelPage(),
                        '/offline': (context) => const OfflinePage(),
                        '/start_activity': (context) => const HomePageList(),
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
