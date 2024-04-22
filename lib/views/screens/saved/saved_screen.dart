import 'dart:io';
import 'package:anytimeworkout/config/icons.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import '../../../views/components/check_login.dart';
import '../../../config/app_colors.dart';
import '../../../config/styles.dart';
import '../../../views/components/saved_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../views/components/bottom_loader.dart';
import '../../../bloc/saved/saved_bloc.dart';

class SavedScreen extends StatefulWidget {
  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  void initState() {
    super.initState();
    logScreenEvent();
  }

  logScreenEvent() async {
    await FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'savedSearches.lbl_saved_searches'.tr());
  }

  refresh() {
    context.read<SavedBloc>().add(SavedFetched());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool shouldPop = true;
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: lightColor,
          elevation: 1,
          title: const Text(
            'savedSearches.lbl_saved_searches',
            style: TextStyle(color: blackColor),
          ).tr(),
          leading: ModalRoute.of(context)?.canPop == true
              ? IconButton(
                  icon: Icon(
                    (context.locale.toString() == "en_US")
                        ? (Platform.isIOS)
                            ? iosBackButton
                            : backArrow
                        : (context.locale.toString() == "ar_AR")
                            ? (Platform.isIOS)
                                ? iosForwardButton
                                : forwardArrow
                            : iosForwardButton,
                    color: blackColor,
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/more_drawer'))
              : null,
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
          child: BlocBuilder<SavedBloc, SavedState>(builder: (context, state) {
            if (state.saveStatus == SaveStatus.initial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.saveStatus == SaveStatus.failure) {
              return Center(
                  child: const Text('list.lbl_no_results_found').tr());
            }

            if (state.saveStatus == SaveStatus.success) {
              if (state.items!.isEmpty) {
                return SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Center(
                        child: Column(children: <Widget>[
                      const Text('savedSearches.lbl_no_any_saved_property',
                          style: TextStyle(
                            fontSize: 17,
                            // fontWeight: FontWeight.w500,
                            // color: primaryColor
                          )).tr(),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            backgroundColor: primaryDark),
                        onPressed: () => CheckLogin.resetForm(context, refresh),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'list.lbl_search_now_button',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: lightColor),
                              ).tr(),
                            ]),
                      ),
                    ])));
              }

              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return index >= state.items!.length
                      ? const BottomLoader()
                      : SavedRow(
                          item: state.items![index],
                          idx: index,
                          hashKey: state.recIdsList![index],
                          filterRoomsOptionSize: filterRoomsOptionSize,
                          refreshParent: refresh);
                },
                itemCount: state.hasReachedMax!
                    ? state.items!.length
                    : state.items!.length + 1,
              );
            }
            return Container();
          }),
        ),
      ),
    );
  }
}
