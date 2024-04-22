import 'dart:async';
import 'dart:io';
import 'package:anytimeworkout/bloc/search_result/search_result_bloc.dart';
import 'package:anytimeworkout/module/chat/bloc/channel/channel_bloc.dart';
import 'package:anytimeworkout/module/internet/internet.dart';
import 'package:anytimeworkout/views/screens/result/result_screen.dart';
import 'package:anytimeworkout/views/screens/search/search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../bloc/current_user_bloc/current_user_bloc.dart';
import '../components/check_internet.dart';
import '../screens/profile_detail/profile_detail_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import '../components/drawer_menu.dart';
import '../../views/components/notify.dart';
import '../../views/components/check_login.dart';
import '../../config/app_colors.dart';
import '../../config/icons.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

// ignore: must_be_immutable
class MainLayout extends StatefulWidget {
  final Widget? child;
  final String appBarTitle;
  final List<Widget>? appBarAction;
  final bool bottomMenu;
  final bool appBarVisibility;
  int ctx;
  final bool color;
  final int? status;

  // Constructor
  MainLayout(
      {Key? key,
      this.child,
      this.appBarTitle = '',
      this.ctx = 0,
      this.status,
      this.bottomMenu = true,
      this.color = true,
      this.appBarVisibility = true,
      this.appBarAction})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final resultScreen = ResultScreenState();
  bool? isLogin = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   context.read<InternetBloc>().state.connectionStatus !=
    //           ConnectionStatus.disconnected
    //       ? postLimit()
    //       : null;
    // });

    context.read<UserInfo>().getUserInfo();
  }

  // postLimit() async {
  //   final chkLogin = await Notify().checkLogin();
  //   if (chkLogin) {
  //     bool isPhoneValidate = await Notify().lookup();

  //     await app_instance.storage.write(
  //         key: 'phone_number_validate', value: isPhoneValidate.toString());
  //     String? loginBy = await app_instance.storage.read(key: 'loginBy');

  //     if (mounted) {
  //       if (context.read<UserInfo>().userInfo.emailVerified != 1 &&
  //           loginBy == 'Email') {
  //         if (context.read<CurrentUserBloc>().state.currentUser!.id == null) {
  //           await CheckLogin().deleteStore();
  //           if (mounted) {
  //             Navigator.of(context).pushNamedAndRemoveUntil(
  //                 '/search_result', (Route<dynamic> route) => false);
  //           }
  //         }
  //       }
  //     }
  //     await FirebaseAnalytics.instance
  //         .setCurrentScreen(screenName: widget.appBarTitle);
  //   }
  // }

  _chatMessageRoute(CurrentUserStatus status) async {
    isLogin = await Notify().checkLogin();
    if (status == CurrentUserStatus.authorized && isLogin == true) {
      // Remove for Testing purpose only so that you will get recent data every time
      // BlocProvider.of<ChannelBloc>(context)
      //     .add(const ChannelFetched(status: ChannelStatus.initial));
      // Future.delayed(const Duration(milliseconds: 1000));

      Navigator.of(context, rootNavigator: true).pushNamed("/channel");
    } else {
      Navigator.pushNamed(context, '/login');
    }
  }

  _mapScreenRoute(context, CurrentUserStatus status) async {
    isLogin = await Notify().checkLogin();
    if (status == CurrentUserStatus.authorized && isLogin == true) {
      Navigator.pushNamed(context, '/map_page');
    } else {
      //  Navigator.pushNamed(context, '/login');
      Navigator.pushNamed(context, '/visitor-startmap');
    }
  }
  _homepagelist(context, CurrentUserStatus status) async {
    isLogin = await Notify().checkLogin();
    if (status == CurrentUserStatus.authorized && isLogin == true) {
      print('called----------------');
      Navigator.pushNamed(context, '/map_cor_page');
    } else {
        Navigator.pushNamed(context, '/login');
      // Navigator.pushNamed(context, '/visitor-startmap');
    }
  }

  // // reset search result in home page
  // resetSearchResultScreen() async {
  //   await app_instance.storage.delete(key: 'jsonLastSearch');
  //   await app_instance.storage.delete(key: 'jsonOldSearch');
  //   await app_instance.storage.delete(key: 'resetSearch');
  //   await app_instance.storage.delete(key: 'itemSearch');
  //   await app_instance.storage.delete(key: 'jsonAmenitiesSearch');
  //   await app_instance.storage.delete(key: 'sortBy');
  //   await app_instance.storage.delete(key: "locationIdIndex");
  //   await app_instance.storage.write(key: "resetSearch", value: '1');

  //   if (mounted) {
  //     Navigator.pushNamed(context, '/search_result', arguments: [2, true]);
  //   }
  // }

  // void lastSearch(BuildContext context) async {
    // dynamic jsonLastSearch =
    //     await app_instance.storage.read(key: 'jsonLastSearch');
    // dynamic jsonLastSearchTemp =
    //     await app_instance.storage.read(key: 'jsonLastSearchTemp');

    // if (jsonLastSearch != null) {
    //   if (mounted) {
    //     Navigator.of(context).popUntil(ModalRoute.withName('/search_result'));
    //   }
    // } else if (jsonLastSearchTemp != null) {
    //   dynamic itemSearchTemp =
    //       await app_instance.storage.read(key: 'itemSearchTemp');
    //   dynamic jsonAmenitiesSearchTemp =
    //       await app_instance.storage.read(key: 'jsonAmenitiesSearchTemp');
    //   dynamic sortByTemp = await app_instance.storage.read(key: 'sortByTemp');

    //   await app_instance.storage
    //       .write(key: "jsonLastSearch", value: jsonLastSearchTemp);

    //   if (itemSearchTemp != null) {
    //     await app_instance.storage
    //         .write(key: "itemSearch", value: itemSearchTemp);
    //   }
    //   if (jsonAmenitiesSearchTemp != null) {
    //     await app_instance.storage
    //         .write(key: "jsonAmenitiesSearch", value: jsonAmenitiesSearchTemp);
    //   }
    //   if (sortByTemp != null) {
    //     await app_instance.storage.write(key: "sortBy", value: sortByTemp);
    //   }
    //   if (mounted) {
    //     Navigator.of(context).popUntil(ModalRoute.withName('/search_result'));
    //   }
    // } else {
    //   if (mounted) {
    //     Navigator.of(context).popUntil(ModalRoute.withName('/search_result'));
    //   }
    // }
  // }

  PreferredSizeWidget appBar(bool appBarVisibility) {
    String? routeName = ModalRoute.of(context)!.settings.name;
    if (appBarVisibility == true) {
      return AppBar(
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
            systemNavigationBarColor: greyColor,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarColor: primaryColor,
            statusBarIconBrightness: Brightness.dark),
        backgroundColor: (widget.color == true) ? primaryColor : lightColor,
        elevation:
            (routeName == '/search_result' || widget.color == true) ? 0 : 1,
        title: Text(
          widget.appBarTitle,
          style: const TextStyle(color: blackColor),
        ), // Remove the bottom shadow
        actions: widget.appBarAction,
        leading: (widget.status! < 2 || widget.status == 3)
            ? IconButton(
                icon: Icon(
                  (context.locale.toString() == "en_US")
                      ? (Platform.isIOS)
                          ? iosBackButton
                          : backArrow
                      // : (context.locale.toString() == "en_US")
                      //     ? (Platform.isIOS)
                      //         ? iosForwardButton
                      //         : forwardArrow
                          : iosForwardButton,
                  color: blackColor,
                ),
                onPressed: () {
                  if (widget.status == 1) {
                    Navigator.pushNamed(context, "/more_drawer");
                  } else {
                    Navigator.popUntil(
                        context, ModalRoute.withName('/search_result'));
                  }
                },
              )
            : (widget.status == 2)
                ? IconButton(
                    constraints: const BoxConstraints(),
                    icon: Text(
                      String.fromCharCode(Icons.search_outlined.codePoint),
                      style: TextStyle(
                        inherit: false,
                        fontSize: 44,
                        color: blackColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: Icons.search_outlined.fontFamily,
                      ),
                    ),
                    onPressed: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          settings: const RouteSettings(name: '/search'),
                          pageBuilder: (
                            BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                          ) =>
                              const SearchScreen(
                                  comeFromSearch: true,
                                  // refreshList: resultScreen.refreshParent
                                  ),
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
                        )))
                : Container(),
      );
    }
    return PreferredSize(
      preferredSize: Size.zero,
      child: AppBar(
        iconTheme: const IconThemeData(color: lightColor, size: 0),
        backgroundColor: lightColor,
        elevation: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? routeName = ModalRoute.of(context)!.settings.name;
    return WillPopScope(
        onWillPop: () {
          Navigator.popUntil(context, ModalRoute.withName('/search_result'));
          return Future.value(true);
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: greyColor,
          // (routeName != '/contact' && routeName != '/saved_search')
          //     ? routeName == '/search_result'
          //         ? primaryColor
          //         : lightColor
          //     : backgroundColor,
          appBar: appBar(widget.appBarVisibility),
          drawer: DrawerMenu(),
          body: widget.child,
          bottomNavigationBar: Visibility(
            maintainState: false,
            visible: widget.bottomMenu,
            child: BlocConsumer<CurrentUserBloc, CurrentUserState>(
              listenWhen: (previous, current) {
                if (current.currentUser!.id != 0) {
                  if (previous.currentUser!.id != current.currentUser!.id) {
                    print('*****New channel list has been fetched******');
                    if (current.status == CurrentUserStatus.authorized) {
                      BlocProvider.of<ChannelBloc>(context).add(
                          const FetchFromStore(status: ChannelStatus.initial));
                    }
                  }
                  return previous.currentUser!.id != current.currentUser!.id;
                }
                return false;
              },
              listener: (context, state) {},
              builder: (context, state) {
                var connectionStatus = Provider.of<ConnectivityStatus>(context);
                return BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: lightColor,
                    selectedItemColor: (routeName != 'my_properties')
                        ? (routeName == "/setting")
                            ? blackColor
                            : primaryColor
                        : greyColor,
                    unselectedItemColor: blackColorLight,
                    selectedFontSize: 12,
                    unselectedFontSize: 12,
                    currentIndex: widget.ctx,
                    onTap: (int value) async {
                      dynamic searchCount =
                          context.read<SearchResultBloc>().state.searchCounts;
                      dynamic defaultSearch =
                          await app_instance.storage.read(key: 'defaultSearch');

                      switch (value) {
                        case 0:
                           if (widget.ctx != 0) {
                            _homepagelist(context,state.status);
                          }
                          break;
                        case 1:
                          if (widget.ctx != 1) {
                            _mapScreenRoute(context, state.status);
                          }
                          break;
                        case 2:
                          if (widget.ctx != 2) {
                            _chatMessageRoute(state.status);
                          }
                          break;
                        case 3:
                          // if (widget.ctx != 3) {
                          // }
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed("/more_drawer");
                          break;
                      }
                    },
                    items: [
                      BottomNavigationBarItem(
                        label: 'app.lbl_home'.tr(),
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Image.asset(
                            "assets/icon/home-grey.png",
                            height: 18,
                            width: 18,
                          ),
                        ),
                        activeIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Image.asset(
                            "assets/icon/home-active.png",
                            height: 18,
                            width: 18,
                          ),
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: 'request.lbl_start_activity'.tr(),
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Image.asset(
                            "assets/icon/location-grey.png",
                            height: 18,
                            width: 18,
                          ),
                        ),
                        activeIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Image.asset(
                            "assets/icon/location-active.png",
                            height: 18,
                            width: 18,
                          ),
                        ),
                      ),
                      BottomNavigationBarItem(
                          label: 'app.lbl_message'.tr(),
                          icon: (state.currentUser!.id == 0)
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Image.asset(
                                    "assets/icon/chat-grey.png",
                                    height: 18,
                                    width: 18,
                                  ),
                                )
                              : messageIconComp(context),
                          activeIcon: (state.currentUser!.id == 0)
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Image.asset(
                                    "assets/icon/chat-active.png",
                                    height: 18,
                                    width: 18,
                                  ),
                                )
                              : messageIconCompActive(context)),
                      BottomNavigationBarItem(
                        label: 'app.lbl_more'.tr(),
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Image.asset(
                            "assets/icon/more-grey.png",
                            height: 18,
                            width: 18,
                          ),
                        ),
                        activeIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Image.asset(
                            "assets/icon/more-active.png",
                            height: 18,
                            width: 18,
                          ),
                        ),
                      ),
                    ]);
              },
            ),
          ),
        ));
  }

  storeUnreadChannelCount(BuildContext context) async {
    try {
      dynamic unreadPrivateChannelCount =
          context.read<ChannelBloc>().state.unreadPrivateChannelCount;
      await app_instance.storage.write(
          key: 'unreadPrivateChannelCount',
          value: unreadPrivateChannelCount.toString());
    } catch (er, _) {
      print("error is : $er");
    }
  }

  Widget messageIconComp(BuildContext context) {
    return BlocConsumer<ChannelBloc, ChannelState>(
      listenWhen: (previous, current) {
        return previous.unreadChannelCount != current.unreadChannelCount;
      },
      buildWhen: (previous, current) {
        if (context.read<CurrentUserBloc>().state.status ==
            CurrentUserStatus.authorized) {
          storeUnreadChannelCount(context);
          if (current.status == ChannelStatus.serverSyncEnd &&
              app_instance.appConfig.sendLoginTokenActivity == true) {
            app_instance.appConfig.sendLoginTokenActivity = false;
            app_instance.userRepository.loginTokenActivity(
                unreadPrivateChannelCount:
                    current.unreadPrivateChannelCount.toString());
          }
        }
        return (previous.unreadChannelCount != current.unreadChannelCount);
      },
      listener: (context, state) {},
      builder: (context, state) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Image.asset(
                "assets/icon/chat-grey.png",
                height: 18,
                width: 18,
              ),
            ),

            // TO DO: Keep for message count show
            Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: (state.unreadChannelCount == 0)
                        ? transparentColor
                        : darkRedColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: (state.unreadChannelCount == 0)
                      ? const SizedBox.shrink()
                      : Text(
                          "${state.unreadChannelCount}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                )),
          ],
        );
      },
    );
  }

  Widget messageIconCompActive(BuildContext context) {
    return BlocConsumer<ChannelBloc, ChannelState>(
      listenWhen: (previous, current) {
        return previous.unreadChannelCount != current.unreadChannelCount;
      },
      buildWhen: (previous, current) {
        if (context.read<CurrentUserBloc>().state.status ==
            CurrentUserStatus.authorized) {
          storeUnreadChannelCount(context);
          if (current.status == ChannelStatus.serverSyncEnd &&
              app_instance.appConfig.sendLoginTokenActivity == true) {
            app_instance.appConfig.sendLoginTokenActivity = false;
            app_instance.userRepository.loginTokenActivity(
                unreadPrivateChannelCount:
                    current.unreadPrivateChannelCount.toString());
          }
        }
        return (previous.unreadChannelCount != current.unreadChannelCount);
      },
      listener: (context, state) {},
      builder: (context, state) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Image.asset(
                "assets/icon/chat-active.png",
                height: 18,
                width: 18,
              ),
            ),

            // TO DO: Keep for message count show
            Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: (state.unreadChannelCount == 0)
                        ? transparentColor
                        : darkRedColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: (state.unreadChannelCount == 0)
                      ? const SizedBox.shrink()
                      : Text(
                          "${state.unreadChannelCount}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                )),
          ],
        );
      },
    );
  }
}
