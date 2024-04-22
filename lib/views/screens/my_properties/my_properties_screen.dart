import 'dart:async';
import 'dart:io';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/module/chat/bloc/chat/chat_bloc.dart';
import 'package:anytimeworkout/views/screens/my_properties/add_property_type_screen.dart';
import 'package:flutter/services.dart';
import '../../../config/constant.dart';
import '../../../main.dart';
import '../../../module/chat/model/chat_model.dart';
import '../../../views/components/skeleton.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../config/app_colors.dart';
import '../../../config/icons.dart';
import '../../../config/styles.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../views/components/check_login.dart';
import '../../../bloc/my_properties/rent/rent_bloc.dart';
import '../../../bloc/my_properties/sale/sale_bloc.dart';
import '../../../views/components/bottom_loader.dart';
import '../../../views/components/property_row.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class MyPropertiesScreen extends StatefulWidget {
  String? shareFrom;
  String? channelName;
  ChatUser? toUser;
  MyPropertiesScreen({this.shareFrom, Key? key, this.channelName, this.toUser})
      : super(key: key);
  @override
  MyPropertiesScreenState createState() => MyPropertiesScreenState();
}

class MyPropertiesScreenState extends State<MyPropertiesScreen> {
  final _scrollControllerSale = ScrollController();
  final _scrollControllerRent = ScrollController();
  final _playStoreLink = dotenv.env['PLAYSTORELINK'];
  final _appStoreLink = dotenv.env['APPSTORELINK'];
  TextEditingController saleTempScrollFlagcontroller = TextEditingController();
  TextEditingController rentTempScrollFlagcontroller = TextEditingController();

  bool isPhoneValid = false;
  var selIdx = 0;
  bool loader = false;
  String status = '';
  String? postLimitNumber;
  String salePage = '0';
  String rentPage = '0';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollControllerSale.addListener(_onScrollSale);
      _scrollControllerRent.addListener(_onScrollRent);

      CheckLogin().test(context);

      this.initialTab();
    });
    streamController.stream.asBroadcastStream().listen((event) {
      if (event == 2) refresh();
    });
  }

  refresh() {
    if (mounted) {
      Constants.refresh.add(0);
      saleTempScrollFlagcontroller.text = '0';
      rentTempScrollFlagcontroller.text = '0';
      _scrollControllerSale.addListener(_onScrollSale);
      _scrollControllerRent.addListener(_onScrollRent);
      context.read<SaleBloc>().add(SaleResetStateState());
      context.read<SaleBloc>().add(SaleFetched());
      context.read<RentBloc>().add(RentResetStateState());
      context.read<RentBloc>().add(RentFetched());

      setState(() {
        salePage = '0';
        rentPage = '0';
      });
    }
  }

  initialTab() async {
    saleTempScrollFlagcontroller.text = '0';
    rentTempScrollFlagcontroller.text = '0';
    dynamic myPropUpdated =
        await app_instance.storage.read(key: 'myPropUpdated');
    if (myPropUpdated == 'true') {
      context.read<SaleBloc>().add(SaleResetStateState());
      context.read<SaleBloc>().add(SaleFetched());
      context.read<RentBloc>().add(RentResetStateState());
      context.read<RentBloc>().add(RentFetched());

      app_instance.storage.delete(key: 'myPropUpdated');
    }

    String? getType = await app_instance.storage.read(key: 'buyRentType');
    if (getType != null) {
      if (getType.trim() == '1') {
        setState(() {
          salePage = '0';
          rentPage = '0';
          selIdx = 1;
          loader = true;
        });
      } else {
        setState(() {
          salePage = '0';
          rentPage = '0';
          loader = true;
        });
      }
    } else {
      setState(() {
        salePage = '0';
        rentPage = '0';
        loader = true;
      });
    }
  }

  redirectPage(context) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    setState(() {
      isPhoneValid =
          (currentUser.phoneVerified.toString() == '1') ? true : false;
    });

    dynamic token = currentUser.token.toString();
    Object jsonData = {'token': token.toString()};
    dynamic limitStatus =
        await app_instance.userRepository.addPropertyLimitStatus(jsonData);
    if (isPhoneValid) {
      if (limitStatus['remaining_property_to_add'] > 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPropertyTypeScreen(
                privateProperty: "0",
              ),
            ));
      } else {
        Fluttertoast.showToast(
            msg:
                '${'addproperty.lbl_property_limit1'.tr()} ${limitStatus['property_limit']!} ${'addproperty.lbl_property_limit2'.tr()}',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5);
      }
    } else {
      Navigator.pushNamed(context, '/add_new_number');
    }
  }

  // Alert dialogue box for share confirmation
  Future<void> showShareConfirmation(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "addproperty.lbl_share_property_confirmation".tr(),
              style: const TextStyle(color: blackColor),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  final chatState = context.read<ChatBloc>().state;
                  for (int i = 0; i < selectedPropertyList.length; i++) {
                    context
                        .read<ChatBloc>()
                        .add(ChatMessageUpdated('Shared $i'));

                    MessageContent selectedProperty = selectedPropertyList[i];

                    context.read<ChatBloc>().add(ChatMessageSent(
                        selectedProperty, chatState.currentChannel));
                  }

                  selectedPropertyList.clear();
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName('/chatScreen'));
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryDark),
                child: const Text("addproperty.lbl_share").tr(),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: lightColor,
                    side: const BorderSide(color: primaryDark, width: 1)),
                child: const Text(
                  "addproperty.lbl_cancel",
                  style: TextStyle(color: primaryDark),
                ).tr(),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    bool shouldPop = true;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/more_drawer');
        return shouldPop;
      },
      child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: lightColor,
            centerTitle: true,
            elevation: 1,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            title: const Text(
              'filter.lbl_my_properties',
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
                    onPressed: () => (widget.channelName == null)
                        ? Navigator.pushNamed(context, '/more_drawer')
                        : Navigator.of(context)
                            .popUntil(ModalRoute.withName('/chatScreen')),
                  )
                : null,
            actions: [
              IconButton(
                  icon: const Icon(refreshIcon, color: blackColor),
                  onPressed: () => refresh()),
              (widget.shareFrom == "1")
                  ? TextButton(
                      onPressed: () async {
                        showShareConfirmation(context);
                      },
                      child: const Text("addproperty.lbl_done").tr())
                  : Container()
            ],
          ),
          body: loader
              ? Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: DefaultTabController(
                      length: 2,
                      initialIndex: selIdx,
                      child: WillPopScope(
                        onWillPop: () async {
                          Navigator.pushNamed(context, '/more_drawer');
                          return shouldPop;
                        },
                        child: Scaffold(
                          backgroundColor: backgroundColor,
                          appBar: TabBar(
                              unselectedLabelColor: primaryDark,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: primaryDark),
                              tabs: [
                                Tab(
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: primaryDark, width: 2.0)),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'filter.lbl_sell',
                                        style: TextStyle(
                                          fontSize: pageIconSize,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ).tr(),
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: primaryDark, width: 2.0)),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'filter.lbl_for_rent',
                                        style: TextStyle(
                                          fontSize: pageIconSize,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ).tr(),
                                    ),
                                  ),
                                ),
                              ]),
                          body: TabBarView(
                            children: [
                              // Icon(Icons.apps),
                              BlocBuilder<SaleBloc, SaleState>(
                                  builder: (context, state) {
                                if (state.saleStatus == SaleStatus.initial) {
                                  //this.unsubscribe();
                                  return Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Skeleton());
                                }

                                if (state.saleStatus == SaleStatus.failure) {
                                  return Center(
                                      child: const Text(
                                              'list.lbl_no_results_found')
                                          .tr());
                                }

                                if (state.saleStatus == SaleStatus.success) {
                                  if (state.itemsSale!.isEmpty) {
                                    return Column(children: [
                                      const SizedBox(height: 40),
                                      const Text(
                                              'myproperties.lbl_myproperties_msg_for_sell',
                                              style: TextStyle(fontSize: 15))
                                          .tr(),
                                      const SizedBox(height: 20),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            padding: const EdgeInsets.fromLTRB(
                                                60, 8, 60, 8),
                                            backgroundColor: primaryDark),
                                        icon: const Icon(
                                          Icons.add,
                                          color: lightColor,
                                        ),
                                        label: const Text(
                                          'home.lbl_add_property',
                                          style: TextStyle(
                                            color: lightColor,
                                          ),
                                        ).tr(),
                                        onPressed: () =>
                                            {redirectPage(context)},
                                      ),
                                    ]);
                                  }
                                  saleTempScrollFlagcontroller.text =
                                      state.pageSale.toString();
                                  return Container(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: ListView.builder(
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return index >=
                                                  state.itemsSale!.length
                                              ? const BottomLoader()
                                              : PropertyRow(
                                                  item: state.itemsSale![index],
                                                  showOnList: 'myproerties',
                                                  refreshParent: refresh,
                                                  shareFrom: widget.shareFrom,
                                                  channelName:
                                                      widget.channelName,
                                                );
                                        },
                                        itemCount: state.hasReachedMaxSale!
                                            ? state.itemsSale!.length
                                            : state.itemsSale!.length + 1,
                                        controller: _scrollControllerSale,
                                      ));
                                }
                                return Container();
                              }),
                              BlocBuilder<RentBloc, RentState>(
                                  builder: (context, state) {
                                if (state.rentStatus == RentStatus.initial) {
                                  return Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Skeleton());
                                }

                                if (state.rentStatus == RentStatus.failure) {
                                  return Center(
                                      child: const Text(
                                              'list.lbl_no_results_found')
                                          .tr());
                                }

                                if (state.rentStatus == RentStatus.success) {
                                  if (state.itemsRent!.isEmpty) {
                                    return Column(children: [
                                      const SizedBox(height: 40),
                                      const Text(
                                        'myproperties.lbl_myproperties_msg_for_rent',
                                        style: TextStyle(fontSize: 15),
                                      ).tr(),
                                      const SizedBox(height: 20),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            padding: const EdgeInsets.fromLTRB(
                                                60, 8, 60, 8),
                                            backgroundColor: primaryDark),
                                        icon: const Icon(
                                          plusIcon,
                                          color: lightColor,
                                        ),
                                        label: const Text(
                                          'home.lbl_add_property',
                                          style: TextStyle(
                                            color: lightColor,
                                          ),
                                        ).tr(),
                                        onPressed: () => {
                                          redirectPage(context),
                                        },
                                      ),
                                    ]);
                                  }
                                  rentTempScrollFlagcontroller.text =
                                      state.pageRent.toString();
                                  return Container(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: ListView.builder(
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return index >=
                                                  state.itemsRent!.length
                                              ? const BottomLoader()
                                              : PropertyRow(
                                                  item: state.itemsRent![index],
                                                  showOnList: 'myproerties',
                                                  refreshParent: refresh,
                                                  shareFrom: widget.shareFrom,
                                                );
                                        },
                                        itemCount: state.hasReachedMaxRent!
                                            ? state.itemsRent!.length
                                            : state.itemsRent!.length + 1,
                                        controller: _scrollControllerRent,
                                      ));
                                }
                                return Container();
                              }),
                            ],
                          ),
                        ),
                      )),
                )
              : const Center(child: CircularProgressIndicator())),
    );
  }

  void _onScrollSale() {
    if (_scrollControllerSale.position.extentAfter < 10) {
      if (saleTempScrollFlagcontroller.text != this.salePage) {
        context.read<SaleBloc>().add(SaleFetched());

        setState(() {
          salePage = saleTempScrollFlagcontroller.text;
        });
      }
    }
  }

  void _onScrollRent() {
    if (_scrollControllerRent.position.extentAfter < 10) {
      if (rentTempScrollFlagcontroller.text != rentPage) {
        context.read<RentBloc>().add(RentFetched());

        setState(() {
          rentPage = rentTempScrollFlagcontroller.text;
        });
      }
    }
  }
}
