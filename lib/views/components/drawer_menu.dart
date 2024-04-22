import 'package:anytimeworkout/bloc/favorite/favorite_bloc.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/module/chat/bloc/channel/channel_bloc.dart';
import 'package:anytimeworkout/module/chat/pages/components/user_image.dart';
import 'package:anytimeworkout/module/display_list/pages/home_page_list.dart';
import 'package:anytimeworkout/views/screens/my_properties/add_property_type_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:package_info/package_info.dart';
import '../../bloc/current_user_bloc/current_user_bloc.dart';
import '../../module/chat/model/chat_model.dart';
import '../../views/components/notify.dart';
import '../../views/screens/favorite/favorite_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../views/components/center_loader.dart';
import 'package:flutter/services.dart';
import '../../config/icons.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../config/app_colors.dart';
import '../../views/components/check_login.dart';
import 'custom_web_view_screen.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class DrawerMenu extends StatefulWidget {
  bool? comeFromMore = false;
  DrawerMenu({Key? key, this.comeFromMore}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  final privacyPolicyLink = dotenv.env['PRIVACYPOLICYLINK'];
  final termsConditionsLink = dotenv.env['TERMSCONDITIONSLINK'];
  bool? isLogin = false;
  String? displayName = '';
  bool? isChecked = false;
  String? _currentRoute = '';
  bool? isPhoneValid = false;
  String? _isPhoneValidate;
  String? _version = '';
  dynamic tempData;
  String? roleId = '';
  String? lastPage = '';
  int buttonClickCount = 0;
  ChatUser? currentUser = ChatUser.empty;

  Image favorite = Image.asset(
    "assets/icon/heart-grey.png",
    height: 20,
    width: 20,
  );
  Image contact = Image.asset(
    "assets/icon/phone-grey.png",
    height: 20,
    width: 20,
  );
  Image setting = Image.asset(
    "assets/icon/setting-grey.png",
    height: 20,
    width: 20,
  );
  Image logout = Image.asset(
    "assets/icon/logout-grey.png",
    height: 20,
    width: 20,
  );

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    _checkLogin();
    // getData();
  }

  dynamic appReleaseHash = dotenv.env['RELEASE_HASH'];

  // getData() async {
  //   final data = await app_instance.storage.read(key: 'contact_info');
  //   lastPage = await app_instance.storage.read(key: 'LastPage');
  //   tempData = jsonDecode(data.toString());
  //   setState(() {});
  //   if (lastPage != null && lastPage == "Account Upgrade") {
  //     if (!mounted) return;
  //     if (context.read<InternetBloc>().state.connectionStatus !=
  //         ConnectionStatus.disconnected) {
  //       checkAccountUpgradeRequest();
  //     }
  //   }
  // }

  checkPhone() async {
    _isPhoneValidate =
        await app_instance.storage.read(key: 'phone_number_validate');
    if (_isPhoneValidate != 'true') {
      CenterLoader.show(context);
      bool isPhoneValidate = await Notify().lookup();
      await app_instance.storage.write(
          key: 'phone_number_validate', value: isPhoneValidate.toString());
      CenterLoader.hide(context);
      _isPhoneValidate = isPhoneValidate.toString();
    }
    setState(() {});
  }

  dynamic redirectPage(context) async {
    isLogin = await Notify().checkLogin();
    setState(() {});

    if (!isLogin!) {
      Navigator.pushNamed(context, '/login');
    } else if (isLogin! && isPhoneValid!) {
      UserModel currentUser = await app_instance.utility.jwtUser();
      dynamic token = currentUser.token.toString();
      Object jsonData = {'token': token.toString()};
      dynamic limitStatus =
          await app_instance.userRepository.addPropertyLimitStatus(jsonData);
      await checkPhone();

      if (limitStatus['remaining_property_to_add'] > 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPropertyTypeScreen(
                privateProperty: "0",
              ),
            ));
        setState(() {
          buttonClickCount = 0;
        });
      } else {
        Fluttertoast.showToast(
            backgroundColor: primaryDark,
            msg:
                '${'addproperty.lbl_property_limit1'.tr()} ${limitStatus['property_limit']} ${'addproperty.lbl_property_limit2'.tr()}',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5);
        Navigator.pushNamed(context, '/search_result');
      }
    } else if (isLogin! && !isPhoneValid!) {
      Navigator.popAndPushNamed(context, '/add_new_number');
    }
    return isLogin;
  }

  dynamic doRoute(BuildContext context, String name, {dynamic arguments}) {
    if (_currentRoute != name) {
      _currentRoute = name;
      Navigator.popAndPushNamed(context, name, arguments: arguments);
    } else {
      _currentRoute = name;
      Navigator.pop(context);
    }
  }

  redirectToAddRequest() async {
    if (isLogin!) {
      doRoute(context, '/add_request');
    } else {
      Navigator.pushNamed(context, '/login');
    }
  }

  Future<bool> _checkLogin() async {
    _version = await app_instance.storage.read(key: 'build_number');
    UserModel getJwtUser = await app_instance.utility.jwtUser();
    if (getJwtUser != UserModel.empty) {
      currentUser = ChatUser(
        userId: getJwtUser.id.toString(),
        username: getJwtUser.name.toString(),
        userImage: (getJwtUser.profileImage != null)
            ? getJwtUser.profileImage.toString()
            : "",
        roleTypeId: getJwtUser.roleId.toString(),
      );
    }

    if (_version == null) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _version = packageInfo.buildNumber;
      await app_instance.storage
          .write(key: 'build_number', value: packageInfo.buildNumber);
    }
    isLogin = await Notify().checkLogin();
    displayName = getJwtUser.name.toString();
    roleId = getJwtUser.roleId.toString();
    final chkPhoneVerified = getJwtUser.phoneVerified.toString();
    setState(() {
      isPhoneValid = (chkPhoneVerified == '1') ? true : false;
    });
    return isLogin!;
  }

  _signOut() async {
    CenterLoader.show(context);
    context.read<ChannelBloc>().add(ChannelResetState());
    await app_instance.isarServices.cleanDb();
    await CheckLogin().deleteStore();
    await app_instance.utility.getAlgolia();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    context.read<CurrentUserBloc>().add(const IsAuthorized(UserModel.empty));
    context.read<CurrentUserBloc>().add(const LogOutRequest());
    print(
        "NumberOfChannel logout ${context.read<ChannelBloc>().state.channelList.length}");

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    CenterLoader.hide(context);
    if (mounted) {
      Navigator.popAndPushNamed(
        context,
        '/login',
      );
    }

    isLogin = false;
    setState(() {});
  }

  // myProp(BuildContext context) async {
  //   Navigator.pop(context);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => MyPropertiesScreen(),
  //       settings: const RouteSettings(name: 'my_properties'),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            systemNavigationBarColor: lightColor,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarColor: primaryColor,
            statusBarIconBrightness: Brightness.dark),
        child: Container(
            width: 280,
            child: Drawer(
              child: LayoutBuilder(builder: (context, constraint) {
                return SingleChildScrollView(
                    child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraint.maxHeight),
                        child: BlocConsumer<CurrentUserBloc, CurrentUserState>(
                          listenWhen: (previous, current) =>
                              previous.status != current.status,
                          listener: (context, state) {},
                          builder: (context, state) {
                            return IntrinsicHeight(
                                child: Column(
                              children: <Widget>[
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                              color: primaryColor,
                                              padding: (widget.comeFromMore ==
                                                      true)
                                                  ? const EdgeInsets.fromLTRB(
                                                      0, 15, 0, 10)
                                                  : const EdgeInsets.fromLTRB(
                                                      0, 50, 0, 10),
                                              child: Center(
                                                  child: const Text(
                                                'app.lbl_more',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              ).tr())),
                                        ),
                                        Align(
                                          alignment:
                                              (context.locale.toString() ==
                                                      "en_US")
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                          child: Container(
                                            margin:
                                                (widget.comeFromMore == true)
                                                    ? const EdgeInsets.all(0)
                                                    : const EdgeInsets.only(
                                                        top: 40),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: pageHPadding),
                                            child: UserImage(
                                                chatUser: currentUser),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                if (isLogin!)
                                  drawerMenuWidget('Add List', setting),
                                drawerMenuWidget(
                                    'app.lbl_favourites', favorite),
                                drawerMenuWidget('app.lbl_contact_us', contact),
                                if (isLogin!)
                                  drawerMenuWidget('app.lbl_settings', setting),
                                if (isLogin!)
                                  drawerMenuWidget('app.lbl_logout', logout),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 9),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                    text:
                                                        '${'app.lbl_by_using'.tr()} ${'appName.app_title'.tr()} ${'app.lbl_you_agree'.tr()} ',
                                                    style: TextStyle(
                                                        fontSize: pageTextSize,
                                                        color: blackColor,
                                                        fontFamily: 'DM Sans'),
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                              'app.lbl_terms_of_use'
                                                                  .tr(),
                                                          style: const TextStyle(
                                                              color:
                                                                  primaryColor,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              fontFamily:
                                                                  'DM Sans'),
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap = () =>
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                CustomWebViewScreen(
                                                                          title:
                                                                              'app.lbl_terms_of_use'.tr(),
                                                                          // html: (tempData['TERMSCONDITIONSLINK'] != null)
                                                                          //     ? tempData['TERMSCONDITIONSLINK']
                                                                          //     : termsConditionsLink,
                                                                        ),
                                                                      ),
                                                                    )),
                                                      TextSpan(
                                                        text:
                                                            ' ${'app.lbl_and'.tr()} ',
                                                        style: const TextStyle(
                                                            color: blackColor,
                                                            fontFamily:
                                                                'DM Sans'),
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              'app.lbl_privacy_policy'
                                                                  .tr(),
                                                          style: const TextStyle(
                                                              color:
                                                                  primaryColor,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              fontFamily:
                                                                  'DM Sans'),
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap = () =>
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                CustomWebViewScreen(
                                                                          title:
                                                                              'app.lbl_privacy_policy'.tr(),
                                                                          // html: (tempData['PRIVACYPOLICYLINK'] != null)
                                                                          //     ? tempData['PRIVACYPOLICYLINK']
                                                                          //     : privacyPolicyLink,
                                                                        ),
                                                                      ),
                                                                    ))
                                                    ])),
                                            ListTile(
                                                title: Text(
                                              "Version ${_version!} ${app_instance.appConfig.appReleaseHash}",
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            )),
                                          ]),
                                    ),
                                  ),
                                )
                              ],
                            ));
                          },
                        )));
              }),
            )));
  }

  drawerMenuWidget(String menuItemTitle, Image menuItemIcon) {
    return Container(
      child: ListTile(
        visualDensity: const VisualDensity(horizontal: -4.0, vertical: -2.0),
        title: Transform.translate(
          offset: const Offset(-16, 0),
          child: Text(menuItemTitle,
                  style: TextStyle(
                      color: blackColor,
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize))
              .tr(),
        ),
        leading: menuItemIcon,
        // Image.asset("assets/icon/heart-grey.png",
        //     height: 20, width: 20, opacity: const AlwaysStoppedAnimation(.3)),
        onTap: () {
          if (menuItemTitle == 'Add List') {
            listRoutes();
          }
          if (menuItemTitle == 'app.lbl_favourites') {
            favoriteRoutes();
          }

          if (menuItemTitle == 'app.lbl_contact_us') {
            doRoute(context, '/contact');
          }
          // if (menuItemTitle == "app.lbl_blocked_users") {
          //   doRoute(context, '/blocked_users');
          // }
          // if (menuItemTitle == 'app.lbl_account_upgrade') {
          //   doRoute(context, '/upgrade_account');
          // }
          /*   if (menuItemTitle == "request.lbl_user_request") {
            doRoute(context, '/requests_screen');
          } */
          if (menuItemTitle == 'app.lbl_settings') {
            doRoute(context, '/setting');
          }

          if (menuItemTitle == 'app.lbl_logout') {
            _signOut();
          }
        },
      ),
    );
  }

  // myRequestRoute() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => BlocProvider<MyRequestBloc>(
  //         create: (context) =>
  //             MyRequestBloc(currentUserBloc: context.read<CurrentUserBloc>())
  //               ..add(MyRequestFetched(status: MyRequestStatus.initial)),
  //         child: const MyRequestsScreen(),
  //       ),
  //     ),
  //   );
  // }

  favoriteRoutes() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<FavoriteBloc>(
          create: (context) => FavoriteBloc()..add(FavoriteFetched()),
          child: FavoriteScreen(),
        ),
      ),
    );
  }

  listRoutes() {
    
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomePageList()));
  }

  // checkAccountUpgradeRequest() async {
  //   try {
  //     UserModel currentUser = await app_instance.utility.jwtUser();
  //     Map<String, Object> jsonData = {'token': currentUser.token.toString()};

  //     final result = await app_instance.itemApiProvider
  //         .checkAccountApproveRequest(currentUser.id, jsonData);
  //     if (result['status'] == "true") {
  //       final getUserDetails = await app_instance.itemApiProvider
  //           .getUserProfile(currentUser.id.toString());
  //       if (currentUser.roleId.toString() !=
  //           getUserDetails['role_id'].toString()) {
  //         await app_instance.utility
  //             .updateJwtUser({"role_id": getUserDetails['role_id'].toString()});
  //       }

  //       setState(() {});
  //     }
  //   } catch (e, _) {
  //     print(e);
  //     print(_);
  //     print("Exception");
  //   }
  // }
}
