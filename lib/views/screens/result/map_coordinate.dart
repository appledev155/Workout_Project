import 'dart:io';
import 'package:anytimeworkout/bloc/current_user_bloc/current_user_bloc.dart';
import 'package:anytimeworkout/bloc/map_coordinates/map_coordinates_bloc.dart';
import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/module/chat/bloc/channel/channel_bloc.dart';
import 'package:anytimeworkout/module/chat/model/chat_model.dart';
import 'package:anytimeworkout/module/chat/pages/components/user_image.dart';
import 'package:anytimeworkout/module/internet/bloc/internet_bloc.dart';
import 'package:anytimeworkout/module/internet/config.dart';
import 'package:anytimeworkout/views/screens/main_layout.dart';
import 'package:anytimeworkout/views/screens/result/new.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anytimeworkout/config.dart' as app_instance;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCoordinate extends StatelessWidget {
  const MapCoordinate({super.key});

  @override
  Widget build(BuildContext context) {
    late GoogleMapController mapController;
    bool isFullMap = false;
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
        child: BlocBuilder<MapCoordinatesBloc, MapCoordinatesState>(
          builder: (context, state) {
            return ListView.builder(
                itemCount: state.mapModelList!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(8),
                    // padding: const EdgeInsets.all(8),
                    color: backgroundColor,
                    child: ListTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              UserImage(
                                chatUser: context
                                    .read<CurrentUserBloc>()
                                    .state
                                    .chatUser,
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context
                                        .read<CurrentUserBloc>()
                                        .state
                                        .chatUser!
                                        .username,
                                    style: TextStyle(
                                        color: blackColorDark,
                                        fontSize: drawerMenuItemSize,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    state.mapModelList![index].date.toString(),
                                    style: TextStyle(
                                        fontSize: pageTextSize,
                                        fontWeight: FontWeight.w500,
                                        color: blackColorLight),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                      subtitle: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Distance",
                                style: TextStyle(
                                    color: blackColorDark,
                                    fontSize: pageIconSize,
                                    fontWeight: FontWeight.w500),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Duration",
                                    style: TextStyle(
                                        color: blackColorDark,
                                        fontSize: pageIconSize,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Distance",
                                    style: TextStyle(
                                        color: blackColorDark,
                                        fontSize: pageIconSize,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.mapModelList![index].distance.toString(),
                                style: TextStyle(
                                    color: blackColorLight,
                                    fontSize: pageTextSize,
                                    fontWeight: FontWeight.w500),
                              ),
                              Column(
                                children: [
                                  Text(
                                    state.mapModelList![index].duration
                                        .toString(),
                                    style: TextStyle(
                                        color: blackColorLight,
                                        fontSize: pageTextSize,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    state.mapModelList![index].distance
                                        .toString(),
                                    style: TextStyle(
                                        color: blackColorLight,
                                        fontSize: pageTextSize,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 250,
                                  //         width: 500,
                                  child: GoogleMap(
                                    scrollGesturesEnabled: true,
                                    gestureRecognizers: Set()
                                      ..add(Factory<PanGestureRecognizer>(
                                          () => PanGestureRecognizer())),

                                    //     <Factory<OneSequenceGestureRecognizer>>{
                                    //   new Factory<OneSequenceGestureRecognizer>(
                                    //     () => new EagerGestureRecognizer(),
                                    //   ),
                                    // },
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      mapController = controller;
                                    },
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                        state.mapModelList![index].latitude!
                                            .first,
                                        state.mapModelList![index].longitude!
                                            .first,
                                      ),
                                      zoom: 18,
                                    ),
                                    mapType: MapType.normal,
                                    polylines: <Polyline>{
                                      Polyline(
                                          width: 2,
                                          polylineId:
                                              const PolylineId('polyline_id'),
                                          color: primaryDark,
                                          points: [
                                            LatLng(
                                                state.mapModelList![index]
                                                    .latitude!.first,
                                                state.mapModelList![index]
                                                    .longitude!.first),
                                            LatLng(
                                                state.mapModelList![index]
                                                    .latitude!.last,
                                                state.mapModelList![index]
                                                    .longitude!.last),
                                          ]),
                                    },
                                  ),
                                ),
                                // const SizedBox(height: 10,),
                                // ElevatedButton(
                                //     onPressed: () {
                                //       Navigator.push(context, MaterialPageRoute(builder: ((context) => const NewList())));
                                //     }, child: const Text("On Click"))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
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
}
