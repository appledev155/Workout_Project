import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../config/icons.dart';
import '../../../views/components/skeleton.dart';
import '../../../config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../views/components/bottom_loader.dart';
import '../../../views/components/property_row.dart';
import '../../../bloc/favorite/favorite_bloc.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  //String propertyAreaUnit = 'Sq. Ft.';
  // FavoriteBloc? _favoriteBloc;

  @override
  void initState() {
    super.initState();
    //  _favoriteBloc = BlocProvider.of<FavoriteBloc>(context);
    // checkFavorites();
  }

  // refresh() {
  //   context.read<FavoriteBloc>().add(FavoriteRefresh());
  //   context.read<FavoriteBloc>().add(FavoriteFetched());
  //   // _favoriteBloc!.add(FavoriteFetched());
  //   // _favoriteBloc!.add(FavoriteRefresh());
  //   setState(() {});
  // }

  // checkFavorites() async {
  //   dynamic favUpdated = await app_instance.storage.read(key: 'favUpdated');
  //   if (favUpdated == 'true') {
  //     //  _favoriteBloc!.add(FavoriteFetched());
  //     // _favoriteBloc!.add(FavoriteFetched());
  //     context.read<FavoriteBloc>().add(FavoriteFetched());
  //     app_instance.storage.delete(key: 'favUpdated');
  //   }
  //   await FirebaseAnalytics.instance
  //       .setCurrentScreen(screenName: 'favourites.lbl_favourites'.tr());
  // }

  // clearJsonLastSearchForLatestResult() async {
  //   await app_instance.storage.delete(key: 'jsonLastSearch');
  //   await app_instance.storage.delete(key: 'jsonOldSearch');
  //   await app_instance.storage.delete(key: 'resetSearch');
  //   await app_instance.storage.delete(key: 'itemSearch');
  //   await app_instance.storage.delete(key: 'jsonAmenitiesSearch');
  //   await app_instance.storage.delete(key: 'sortBy');
  //   await app_instance.storage.delete(key: "locationIdIndex");
  //   await app_instance.storage.write(key: "resetSearch", value: '1');
  // }

  @override
  Widget build(BuildContext context) {
    bool shouldPop = true;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/search_result', arguments: [2, true]);
        return shouldPop;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            elevation: 1,
            title: const Text(
              'favourites.lbl_favourites',
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
                    onPressed: () {
                      Navigator.pushNamed(context, '/more_drawer');
                    } /* Navigator.of(context).pop() */,
                  )
                : null,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            centerTitle: true,
            // actions: [
            //   IconButton(
            //     icon: const Icon(refreshIcon, color: blackColor),
            //     onPressed: () => refresh(),
            //   )
            // ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              child: BlocBuilder<FavoriteBloc, FavoriteState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status,
                  builder: (context, state) {
                    if (state.status == FavoriteStatus.initial) {
                      return Skeleton();
                    }

                    if (state.status == FavoriteStatus.failure) {
                      return Center(
                          child: const Text('list.lbl_matching_results').tr());
                    }

                    if (state.status == FavoriteStatus.sucess) {
                      if (state.items!.isEmpty) {
                        return SingleChildScrollView(
                            padding: const EdgeInsets.all(15),
                            child: Center(
                                child: Column(children: <Widget>[
                              const Text('favourites.lbl_favourites_msg',
                                  style: TextStyle(
                                    fontSize: 17,
                                  )).tr(),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  // primary: primaryDark,
                                  textStyle: const TextStyle(color: lightColor),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                onPressed: () => {
                                  // clearJsonLastSearchForLatestResult(),
                                  Navigator.pushNamed(context, '/search_result',
                                      arguments: [2, true])
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => const ResultScreen(),
                                  //   ),
                                  // ).then((value) => refresh())
                                },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'list.lbl_search_now_button',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ).tr(),
                                    ]),
                              ),
                            ])));
                      }

                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return index >= state.items!.length
                              ? const BottomLoader()
                              : PropertyRow(
                                  item: state.items![index],
                                  showOnList: 'favorite',
                                  // refreshParent: refresh
                                  );
                        },
                        itemCount: state.hasReachedMax!
                            ? state.items!.length
                            : state.items!.length + 1,
                      );
                    }
                    return Container();
                  }),
            ),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
