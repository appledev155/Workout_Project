import 'package:anytimeworkout/bloc/login_form/login_form_bloc.dart';
import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/views/screens/login/login_screen.dart';
import 'package:anytimeworkout/views/screens/main_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/notify.dart';

class VisitorStartMap extends StatefulWidget {
  const VisitorStartMap({super.key});

  @override
  State<VisitorStartMap> createState() => _VisitorStartMapState();
}

class _VisitorStartMapState extends State<VisitorStartMap> {
  bool isLogin = false;
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    bool shouldPop = true;

    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: MainLayout(
          status: 3,
          color: true,
          ctx: 1,
          appBarTitle: "request.lbl_activity_map".tr(),
          appBarAction: [],
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  googleMap,
                  size: 100,
                  color: blackColorLight,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: const Text(
                    "request.lbl_did_find",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: blackColor),
                  ).tr(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 9),
                  child: const Text(
                    "request.lbl_click_on_locaton",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: blackColor),
                  ).tr(),
                ),
                const SizedBox(
                  height: 20,
                ),
                SafeArea(
                    minimum:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                    child: Container(
                      height: 40 * unitWidth,
                      width: deviceWidth,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            backgroundColor: primaryColor),
                        onPressed: () {
                          if (!isLogin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BlocProvider<LoginFormBloc>(
                                  create: (context) => LoginFormBloc(),
                                  child: const LoginScreen(),
                                ),
                              ),
                            );
                          } else {
                            Navigator.pushNamed(context, '/map_page');
                          }
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                start,
                                color: blackColor,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'request.lbl_new_title',
                                style: TextStyle(
                                  color: blackColor,
                                  fontSize: pageIconSize,
                                ),
                              ).tr(),
                            ],
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          )),
    );
  }

  checkLogin() async {
    isLogin = await Notify().checkLogin();
  }
}
