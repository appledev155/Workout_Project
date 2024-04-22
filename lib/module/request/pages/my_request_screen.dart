import 'package:anytimeworkout/bloc/current_user_bloc/current_user_bloc.dart';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/views/components/notify.dart';
import 'package:anytimeworkout/views/components/request_skeleton.dart';
import 'package:anytimeworkout/views/screens/main_layout.dart';
import '../../../views/components/forms/text_prop_label.dart';
import '../../../config/icons.dart';
import '../../../config/app_colors.dart';
import '../../../config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

import '../bloc/my_request/my_request_bloc.dart';
import '../components/request_row.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  MyRequestsScreenState createState() => MyRequestsScreenState();
}

class MyRequestsScreenState extends State<MyRequestsScreen> {
  final _scrollController = ScrollController();
  String propertyAreaUnit = 'Sq. Ft.';
  String? unit;
  String? curPage = '0';
  final GlobalKey<TextPropLabelState> textPropLabelStateKey =
      GlobalKey<TextPropLabelState>();
  TextEditingController tempcontroller = TextEditingController();
  TextEditingController tempScrollFlagcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isTop &&
        context.read<MyRequestBloc>().state.hasReachedMaxRequest == false) {
      context.read<MyRequestBloc>().add(MyRequestFetched(
          status: context.read<MyRequestBloc>().state.status!));
    }
  }

  bool get _isTop {
    if (_scrollController.position.extentAfter < 500 &&
        context.read<MyRequestBloc>().state.status !=
            MyRequestStatus.localSyncLoading) {
      return true;
    }
    return false;
  }

  // Add Request Button
  Widget getSaveButton() {
    return ButtonTheme(
        height: 15,
        child: TextButton.icon(
            icon: Icon(
              addIcon,
              size: pageIconSize,
              color: lightColor,
            ),
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1),
                    side: const BorderSide(color: primaryDark, width: 1)),
                backgroundColor: primaryDark),
            label: Text(
              'request.lbl_title'.tr(),
              style: TextStyle(color: lightColor, fontSize: pageSmallIconSize),
            ),
            onPressed: () async {
              context
                  .read<MyRequestBloc>()
                  .add(AddNewRequest(status: MyRequestStatus.changeScreen));
              app_instance.storage.write(key: 'isAddPress', value: "1");
              Navigator.pushNamed(context, '/add_request');
            }));
  }

  @override
  Widget build(BuildContext context) {
    final myState = context.watch<MyRequestBloc>();
    final myRequestBloc = context.read<MyRequestBloc>().state;
    bool shouldPop = true;

    return WillPopScope(
      onWillPop: (() async {
        Navigator.pop(context);
        return shouldPop;
      }),
      child: MainLayout(
        status: 3,
        color: false,
        ctx: 1,
        appBarTitle: "request.lbl_request_text1".tr(),
        appBarAction: [
          (myRequestBloc.itemMyRequest!.isEmpty ||
                  context.read<CurrentUserBloc>().state.status !=
                      CurrentUserStatus.authorized)
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.all(10), child: getSaveButton())
        ],
        child: RefreshIndicator(
            onRefresh: () async {
              context.read<MyRequestBloc>().add(MyRequestFetched(
                  status: MyRequestStatus.initial,
                  hasReachedMaxRequest: false));
            },
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (myState.state.itemMyRequest!.isNotEmpty) ...[
                    Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: backgroundColor),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "${context.read<MyRequestBloc>().state.myRequestCount} ${'request.lbl_request_text1'.tr()}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: pageIconSize))
                            ])),
                  ],
                  Expanded(
                      child: Padding(
                          padding:
                              const EdgeInsets.only(top: 2, left: 5, right: 5),
                          child: BlocConsumer<MyRequestBloc, MyRequestState>(
                              listener: (context, state) => {},
                              listenWhen: (previous, current) =>
                                  (previous.status != current.status),
                              buildWhen: (previous, current) =>
                                  previous.status != current.status,
                              builder: (context, state) {
                                // if (state.status == MyRequestStatus.success &&
                                //     context.read<InternetBloc>().state
                                //         is InternetConnected) {
                                //   context
                                //       .read<MyRequestBloc>()
                                //       .add(SyncToServer());
                                // }
                                if (state.status ==
                                        MyRequestStatus.localSyncLoading &&
                                    state.myRequestCount == "0") {
                                  tempcontroller.text = '';
                                  return RequestSkeleton();
                                }
                                // else if(state.status == MyRequestStatus.localSyncLoading && state.myRequestCount == "0") {
                                //   return const CenterLoader();
                                // }
                                else {
                                  if (state.status == MyRequestStatus.success &&
                                      (state.myRequestCount!.isEmpty ||
                                          state.myRequestCount == "0")) {
                                    tempcontroller.text = '';
                                    app_instance.storage.write(
                                        key: 'is_first_request', value: "1");
                                    return visitorAddPage();
                                  } else {
                                    tempScrollFlagcontroller.text =
                                        state.page.toString();
                                    tempcontroller.text = state.myRequestCount!;
                                    app_instance.storage
                                        .delete(key: 'is_first_request');
                                    return SingleChildScrollView(
                                      controller: _scrollController,
                                      child: Column(children: [
                                        for (int i = 0;
                                            i < state.itemMyRequest!.length;
                                            i++) ...[
                                          RequestRow(
                                            item: state.itemMyRequest![i],
                                          )
                                        ]
                                      ]),
                                    );
                                  }
                                }
                              }))),
                ])),
      ),
    );
  }

  Widget visitorAddPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.file_copy,
          size: 100,
          color: greyColor,
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "request.lbl_did_not_find",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ).tr(),
        const SizedBox(
          height: 8,
        ),
        Center(
            child: Padding(
          padding: const EdgeInsets.all(3),
          child: const Text(
            "request.lbl_click_on_add_request",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ).tr(),
        )),
        const SizedBox(
          height: 10,
        ),
        SafeArea(
            minimum: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
            child: Container(
              height: 40 * unitWidth,
              width: deviceWidth,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: primaryDark),
                onPressed: () async {
                  if (context.read<CurrentUserBloc>().state.status ==
                      CurrentUserStatus.authorized) {
                    Navigator.pushNamed(context, '/add_request');
                  } else {
                    Navigator.pushNamed(context, '/login');
                  }
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        plusIcon,
                        color: lightColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'request.lbl_title',
                        style: TextStyle(
                          color: lightColor,
                          fontSize: pageIconSize,
                        ),
                      ).tr(),
                    ],
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
