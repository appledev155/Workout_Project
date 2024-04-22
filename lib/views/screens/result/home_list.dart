import 'dart:io';

import 'package:anytimeworkout/bloc/display_list_bloc/display_list_bloc.dart';
import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/module/chat/bloc/channel/channel_bloc.dart';
import 'package:anytimeworkout/views/screens/main_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:anytimeworkout/module/internet/internet.dart';
import 'package:anytimeworkout/config.dart' as app_instance;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    late GoogleMapController mapController;

    String id;
    context.read<DisplayListBloc>().add(const FetchIsarData());
    return WillPopScope(
      onWillPop: () async {
        showExitConfirmation(context);
        return false;
      },
      child: MainLayout(
        color: true,
        ctx: 0,
        status: 1,
        appBarTitle: 'list.lbl_latest'.tr(),
        appBarAction: [
          _filterButton(),
        ],
        child: BlocBuilder<DisplayListBloc, DisplayListState>(
          builder: (context, state) {
            return ListView.builder(
                // reverse: true,
                itemCount: state.listpostmodel!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(7),
                    decoration: const BoxDecoration(color: greyColor),
                    child: ListTile(
                      title: Text(
                        state.listpostmodel![index].name.toString(),
                        style: TextStyle(
                            color: blackColorDark,
                            fontWeight: FontWeight.w500,
                            fontSize: pageIconSize),
                      ),
                      subtitle: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date: ${state.listpostmodel![index].date.toString()}",
                              style: TextStyle(
                                  color: blackColorDark,
                                  fontWeight: FontWeight.w400,
                                  fontSize: pageIconSize),
                            ),
                            Text(
                              "Duration: ${state.listpostmodel![index].duration.toString()}",
                              style: TextStyle(
                                  color: blackColorDark,
                                  fontWeight: FontWeight.w400,
                                  fontSize: pageIconSize),
                            ),
                            Text(
                              "Distance: ${state.listpostmodel![index].distance.toString()}",
                              style: TextStyle(
                                  color: blackColorDark,
                                  fontWeight: FontWeight.w400,
                                  fontSize: pageIconSize),
                            ),
                            Text(
                              "longitude: ${state.listpostmodel![index].latitude.toString()}",
                              style: TextStyle(
                                  color: blackColorDark,
                                  fontWeight: FontWeight.w400,
                                  fontSize: pageIconSize),
                            ),
                            Text(
                              "Latitude: ${state.listpostmodel![index].latitude.toString()}",
                              style: TextStyle(
                                  color: blackColorDark,
                                  fontWeight: FontWeight.w400,
                                  fontSize: pageIconSize),
                            ),
                            Center(
                                child: Card(
                              shadowColor: blackColor,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 200,
                                    child: GoogleMap(
                                      // scrollGesturesEnabled:,
                                      initialCameraPosition:
                                           CameraPosition(
                                        target: LatLng(state.listpostmodel![index].latitude!.toDouble(), state.listpostmodel![index].latitude!.toDouble()),
                                        zoom: 10,
                                      ),
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        mapController = controller;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            context.read<DisplayListBloc>().add(DeleteListpage(
                                id: state.listpostmodel![index].id.toString()));
                          },
                          icon: const Icon(delete)),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  _filterButton() {
    return SizedBox(
      child: IconButton(
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.only(right: 20),
        icon: const Icon(
          filterIcon,
          size: 40,
          color: blackColor,
        ),
        onPressed: () {},
      ),
    );
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
}
