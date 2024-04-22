import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/views/components/property_row/price.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../bloc/current_user_bloc/current_user_bloc.dart';

// ignore: must_be_immutable
class PrivatePropertRow extends StatelessWidget {
  Map<String, dynamic>? propertyData;
  String propertyImagePath = '';
  String? userId;
  List propertyImages = [];
  PrivatePropertRow(this.propertyData, this.propertyImagePath, this.userId,
      this.propertyImages,
      {super.key});
  @override
  Widget build(BuildContext context) {
    final String gifPath = dotenv.env['GifPath'].toString();
    final String? appUserId = BlocProvider.of<CurrentUserBloc>(context)
        .state
        .currentUser
        ?.id
        .toString();

    return GestureDetector(
      onTap: () {
        showPrivatePropertyDetails(context, propertyData, gifPath);
      },
      child: Container(
        decoration: const BoxDecoration(color: primaryColor),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (propertyData!['propertyImage'].length != 0 &&
                    propertyImagePath.isNotEmpty)
                ? CachedNetworkImage(
                    imageUrl: propertyImagePath,
                    height: 200.0,
                    width: 200.0,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.network(
                          '$gifPath/assets/static/giphy.gif',
                          height: 150.0,
                          width: 150.0,
                        ),
                    errorWidget: (context, url, error) {
                      return Container();
                    })
                : Container(),
            Price(price: propertyData!['price'].toString()),
            Text(
              propertyData!['propertyTitle'].toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              strutStyle: StrutStyle(
                fontFamily: 'DM Sans',
                forceStrutHeight:
                    (context.locale.toString() == 'ar_AR') ? true : false,
              ),
              style: TextStyle(
                color: (userId == appUserId) ? lightColor : primaryColor,
                fontSize: pageTitleSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              propertyData!['propertyDescription'].toString(),
              style: TextStyle(
                  height: 2,
                  color: (userId == appUserId) ? blackColor : lightColor,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showPrivatePropertyDetails(
    BuildContext context,
    Map<String, dynamic>? propertyData,
    String gifPath,
  ) async {
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setStateSB) => SimpleDialog(
              contentPadding: const EdgeInsets.only(
                  left: 50, right: 50, top: 20, bottom: 20),
              title: const Text('Property Details'),
              children: <Widget>[
                (propertyData!['propertyImage'][0] != null)
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          for (int i = 0; i < propertyImages.length; i++) ...[
                            Hero(
                                tag: 'animate${i}',
                                transitionOnUserGestures: true,
                                child: CachedNetworkImage(
                                    imageUrl: propertyImages[i],
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Image.network(
                                          gifPath + '/assets/static/giphy.gif',
                                          height: 150.0,
                                          width: 150.0,
                                        ),
                                    errorWidget: (context, url, error) {
                                      return Container();
                                    })),
                            const SizedBox(
                              width: 10,
                            )
                          ]
                        ]),
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                Price(price: propertyData['price'].toString()),
                Text(
                  propertyData['propertyTitle'].toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  strutStyle: StrutStyle(
                    fontFamily: 'DM Sans',
                    forceStrutHeight:
                        (context.locale.toString() == 'ar_AR') ? true : false,
                  ),
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: pageTitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  propertyData['propertyDescription'].toString(),
                  style: const TextStyle(
                      height: 2, color: blackColor, fontSize: 14),
                ),
              ],
            ),
          );
        });
  }
}
