import 'dart:async';
import 'dart:io';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/module/chat/bloc/channel/channel_bloc.dart';
import 'package:anytimeworkout/module/internet/internet.dart';
import 'package:flutter/services.dart';
import '../../../bloc/display_list_bloc/display_list_bloc.dart';
import '../../../config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../views/screens/main_layout.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class ResultScreen extends StatefulWidget {
  final int? status;
  final bool? defaultSearch; // default search show title bar "Latest Search"
  const ResultScreen({super.key, this.status = 2, this.defaultSearch});
  @override
  ResultScreenState createState() => ResultScreenState();
}

class ResultScreenState extends State<ResultScreen> {
  bool isInternet = false;
  String? unit;
  bool isNotSaved = false;
  String curPage = '0';
  List<String> searchIdsList = <String>[];
  List<dynamic> searchSavedList = <dynamic>[];
  TextEditingController tempcontroller = TextEditingController();
  TextEditingController tempScrollFlagcontroller = TextEditingController();
  String? resetSearch = '';
  dynamic params;
  bool isData = true;
  String searchCounts = '';
  String? text;
  dynamic saveSerach;
  String? recSearch;
  bool? shoulKeepAlive = true;
  dynamic counterValue;

  bool? isLoading = true;
  String? lastPage;

  String? token;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        initialCallMethod();
      });
    });
  }

  refreshData() {
    setState(() {});
  }

  Future<void> showExitConfirmation(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "exit.lbl_exit_confirmation".tr(),
              style: const TextStyle(color: blackColor),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  if (Platform.isAndroid) {
                    try {
                      if (context.read<InternetBloc>().state.connectionStatus !=
                          ConnectionStatus.disconnected) {
                        String unreadPrivateChannelCount = context
                            .read<ChannelBloc>()
                            .state
                            .unreadPrivateChannelCount
                            .toString();
                        app_instance.userRepository.storeUserLastVisitedTime(
                            unreadPrivateChannelCount:
                                unreadPrivateChannelCount.toString());
                      }
                      SystemNavigator.pop();
                    } catch (er) {
                      exit(0);
                    }
                  } else {
                    try {
                      if (context.read<InternetBloc>().state.runtimeType ==
                          InternetConnected) {
                        String unreadPrivateChannelCount = context
                            .read<ChannelBloc>()
                            .state
                            .unreadPrivateChannelCount
                            .toString();
                        app_instance.userRepository.storeUserLastVisitedTime(
                            unreadPrivateChannelCount:
                                unreadPrivateChannelCount.toString());
                      }
                      exit(0);
                    } catch (er) {
                      exit(0);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                child: Text("exit.lbl_lbl_exit".tr()),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: lightColor,
                    side: const BorderSide(color: primaryDark, width: 1)),
                child: Text(
                  "exit.lbl_cancel".tr(),
                  style: const TextStyle(color: blackColorDark),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          showExitConfirmation(context);
          return false;
        },
        child: MainLayout(
          color: true,
          ctx: 0,
          status: widget.status,
          appBarTitle:'list.lbl_latest'.tr(),
          appBarAction: [
            _filterButton(),
          ],
          child: BlocBuilder<DisplayListBloc, DisplayListState>(
            bloc: DisplayListBloc(),
            builder: (context, state) {
              return ListView.builder(
                  itemCount: state.listpostmodel!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title:
                            Text(state.listpostmodel![index].date.toString()),
                        subtitle: Text(
                            state.listpostmodel![index].duration.toString()));
                  });
            },
          ),
        ));
  }

  _filterButton() {
    return SizedBox(
      child: IconButton(
        constraints: const BoxConstraints(),
        padding: (context.locale.toString() == "ar_AR")
            ? const EdgeInsets.only(left: 15)
            : const EdgeInsets.only(right: 20),
        icon: const Icon(
          filterIcon,
          size: 40,
          color: blackColor,
        ),
        onPressed: () {},
      ),
    );
  }

  void initialCallMethod() async {
    if (lastPage == "Sign In") {
      showSnakBarMethod();
    }
  }

  waitMethod() async {
    await Future.delayed(const Duration(seconds: 20));
  }

  showSnakBarMethod() {
    final snackBar = SnackBar(
      backgroundColor: activeColor,
      content: const Text('login.lbl_login_successful').tr(),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'login.lbl_dismiss'.tr(),
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
