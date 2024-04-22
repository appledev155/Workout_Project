import 'dart:io';
import 'package:anytimeworkout/bloc/current_user_bloc/current_user_bloc.dart';
import 'package:anytimeworkout/bloc/favorite/favorite_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../config/app_colors.dart';
import '../../../config/icons.dart';
import '../../../module/chat/bloc/channel/channel_bloc.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class DeleteAccount extends StatelessWidget {
  DeleteAccount({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: lightColor,
        appBar: AppBar(
          centerTitle: true,
          systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarColor: lightColor,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarColor: primaryColor,
              statusBarIconBrightness: Brightness.dark),
          iconTheme: const IconThemeData(color: blackColor),
          backgroundColor: primaryColor,
          leading: ModalRoute.of(context)?.canPop == true
              ? IconButton(
                  icon: Icon(
                    (context.locale.toString() == "en_US")
                        ? (Platform.isIOS)
                            ? iosBackButton
                            : backArrow
                        // : (context.locale.toString() == "ar_AR")
                        //     ? (Platform.isIOS)
                        //         ? iosForwardButton
                        //         : forwardArrow
                        : iosForwardButton,
                    color: blackColor,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null,
        ),
        body: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'settings.lbl_delete_account',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                      ),
                    ).tr(),
                  ]),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("settings.lbl_delete_message_1",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400))
                        .tr(),
                    const SizedBox(height: 25),
                    const Text("settings.lbl_delete_message_2",
                            style: TextStyle(fontSize: 14))
                        .tr(),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                        ),
                        onPressed: () {
                          deleteAccountConfirmationDialogBox(context);
                        },
                        child:
                            const Text("settings.lbl_delete_my_account").tr(),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  clearAdditionalData() async {
    await app_instance.storage.delete(key: 'favUpdated');
    await app_instance.storage.delete(key: 'favIds');
    await app_instance.storage.delete(key: 'favIdsGuest');
    await app_instance.storage.delete(key: 'jsonLastSearch');
    await app_instance.storage.delete(key: 'resetSearch');
    await app_instance.storage.delete(key: 'itemSearch');
    await app_instance.storage.delete(key: 'jsonAmenitiesSearch');
    await app_instance.storage.delete(key: 'sortBy');
    await app_instance.storage.delete(key: "locationIdIndex");
    await app_instance.storage.delete(key: "searchSavedLists");
    await app_instance.storage.delete(key: "searchIds");
  }

  deleteAccountConfirmationDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("settings.lbl_delete_message_1").tr(),
            actions: [
              ElevatedButton(
                onPressed: () {
                  clearAdditionalData();
                  context.read<FavoriteBloc>().add(ResetFavoriteState());
                  context
                      .read<CurrentUserBloc>()
                      .add(const UpdateProfile(deleteAccount: true));
                  context.read<ChannelBloc>().add(ChannelResetState());
                  context.read<ChannelBloc>().add(ResetUnreadChannelCount());
                  Navigator.pushNamed(context, '/search_result');

                  Fluttertoast.showToast(
                      msg: "settings.lbl_account_delete_successfully",
                      backgroundColor: primaryColor,
                      textColor: lightColor,
                      toastLength: Toast.LENGTH_LONG);
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                child: Text("settings.lbl_delete_account".tr()),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: lightColor,
                    side: const BorderSide(color: primaryDark, width: 1)),
                child: Text(
                  "settings.lbl_cancel".tr(),
                  style: const TextStyle(color: primaryDark),
                ),
              ),
            ],
          );
        });
  }
}
