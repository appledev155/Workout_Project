import 'dart:convert';

import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/module/chat/bloc/chat/chat_bloc.dart';
import 'package:anytimeworkout/views/components/property_row/property_type.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../module/chat/model/chat_model.dart';
import '../../views/screens/details/details_screen.dart';
import '../../model/item_model.dart';
import '../../bloc/my_properties/add/add_form_bloc.dart';
import '../../config/app_colors.dart';
import '../../config/icons.dart';
import '../../views/screens/my_properties/add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../views/components/property_row/favorite_icon.dart';
import 'property_row/location.dart';
import 'property_row/price.dart';
import 'property_row/property_title.dart';
import 'property_row/bedrooms_toilet_area.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

List<MessageContent> selectedPropertyList = [];

class PropertyRow extends StatefulWidget {
  final ItemModel? item;
  final String? showOnList;
  final Function()? refreshParent;
  final String? shareFrom;
  final String? channelName;
  final bool? comeFromMessage;

  const PropertyRow({
    Key? key,
    @required this.item,
    this.showOnList,
    this.refreshParent,
    this.shareFrom,
    this.channelName,
    this.comeFromMessage = false,
  }) : super(key: key);

  @override
  _PropertyRowState createState() => _PropertyRowState(
        item: this.item,
        showOnList: this.showOnList,
      );
}

class _PropertyRowState extends State<PropertyRow> {
  ItemModel? item;
  String? showOnList;
  bool flag = true;
  bool isSelected = true;

  _PropertyRowState({this.item, this.showOnList});

  unfavorite() {
    setState(() {
      flag = false;
    });
  }

  setSelcted() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  resetfavorite() {
    widget.refreshParent!();
  }

  @override
  Widget build(BuildContext context) {
    final String gifPath = dotenv.env['GifPath'].toString();
    String? rec, lblunitsqft, lblunitsqm;

    rec = ((item!.nameArabic != null || item!.nameEnglish != null)
        ? (context.locale.toString() == 'ar_AR')
            ? ((item!.nameArabic != null)
                ? item!.nameArabic
                : item!.nameEnglish)
            : ((item!.nameEnglish != null)
                ? item!.nameEnglish
                : item!.nameArabic)
        : '')!;
    if (!flag) {
      return Container();
    } else {
      return GestureDetector(
          onTap: () {
            Future.delayed(Duration.zero, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                            item: item!,
                            function: (widget.refreshParent != null)
                                ? widget.refreshParent!
                                : () {},
                          )));
            });
          },
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: greyColor.withOpacity(0.4),
                  blurRadius: 0.5,
                  spreadRadius: 0.1,
                  offset: const Offset(0, 0.1))
            ], color: lightColor, borderRadius: BorderRadius.circular(5)),
            margin: const EdgeInsets.fromLTRB(1.5, 4, 1.5, 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Column(
                children: [
                  if (widget.comeFromMessage == true)
                    Hero(
                        tag: 'animate${item!.id}',
                        transitionOnUserGestures: true,
                        child: CachedNetworkImage(
                            imageUrl: item!.propertyImage!,
                            height: 150.0,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.network(
                                  '$gifPath/assets/static/giphy.gif',
                                  height: 150.0,
                                  width: 150.0,
                                ),
                            errorWidget: (context, url, error) {
                              print(error);
                              return Container();
                            })),
                  Row(
                    children: <Widget>[
                      (item!.rowImage != null && item!.rowImage != "")
                          ? Hero(
                              tag: 'animate${item!.id}',
                              transitionOnUserGestures: true,
                              child: CachedNetworkImage(
                                  imageUrl: item!.propertyImage!,
                                  height: 150.0,
                                  width: 150.0,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Image.network(
                                        '$gifPath/assets/static/giphy.gif',
                                        height: 150.0,
                                        width: 150.0,
                                      ),
                                  errorWidget: (context, url, error) {
                                    print(error);
                                    return Container();
                                  }))
                          : Container(),
                      if (item!.propertyImage == null)
                        const SizedBox(width: 10),
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            (item!.propertyImage != null ||
                                    item!.propertyImage != "")
                                ? Price(price: item!.price)
                                : Price(price: ""),
                            const SizedBox(height: 2),
                            Row(children: [
                              if (item!.isAgent == 1 && item!.agencyId != 0)
                                const Icon(verifyIcon),
                              Expanded(
                                  child: PropertyTitle(
                                      propertyTitle:
                                          (item!.nameEnglish == 'null')
                                              ? "_"
                                              : item!.nameEnglish,
                                      propertyTitleAr:
                                          (item!.nameArabic == 'null')
                                              ? "_"
                                              : item!.nameArabic,
                                      item: item)),
                            ]),
                            const SizedBox(height: 2),
                            PropertyType(propertyTypeConst: item!.type),
                            const SizedBox(height: 2),
                            Location(
                                location: item!.location ?? "",
                                locationAr: item!.locationAr ?? ""),
                            const SizedBox(height: 2),
                            BedroomsToiletArea(
                                bedrooms: item!.bedrooms ?? 0,
                                toilet: item!.toilet ?? 0,
                                areaSqft: item!.areaSqft ?? "",
                                areaSqm: item!.areaSqm ?? "",
                                areaSqyd: item!.areaSqyd ?? ""),
                          ],
                        ),
                      )),
                      Container(
                          height: 150,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (showOnList != 'myproerties') ...[
                                  FavoriteIcon(
                                    item: item,
                                    showOnList:
                                        (showOnList != null) ? showOnList : '',
                                    notifyParent: unfavorite,
                                    notifyFavorite: resetfavorite,
                                  ),
                                  SizedBox(
                                    height: 30 * unitHeight,
                                  )
                                ],
                                if (this.showOnList == 'myproerties') ...[
                                  IconButton(
                                    padding: EdgeInsets.all(pageHPadding / 2),
                                    icon: const Icon(
                                      editIcon,
                                      size: 18,
                                      color: greyColor,
                                    ),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider<AddFormBloc>(
                                          create: (context) => AddFormBloc(),
                                          child: AddScreen(
                                            editId: item!.id.toString(),
                                            buyrentType: '',
                                            function: widget.refreshParent!,
                                            privateProperty: "0",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30 * unitHeight,
                                  )
                                ],
                                if (this.showOnList == 'myproerties' &&
                                    item!.status == 0) ...[
                                  const Icon(
                                    deaIcon,
                                    size: 18,
                                    color: favoriteColor,
                                  ),
                                  SizedBox(
                                    height: 30 * unitHeight,
                                  )
                                ],
                                if (showOnList == 'myproerties' &&
                                    item!.status == 1) ...[
                                  const Icon(
                                    activeIcon,
                                    size: 18,
                                    color: activeColor,
                                  ),
                                  SizedBox(
                                    height: 30 * unitHeight,
                                  )
                                ],
                              ]))
                    ],
                  ),
                  (widget.shareFrom == "1")
                      ? GestureDetector(
                          onTap: () {
                            setSelcted();

                            String propertyName = '';
                            if (item!.nameEnglish != null) {
                              propertyName = item!.nameEnglish!;
                            }

                            if (selectedPropertyList.length > 0) {
                              selectedPropertyList.removeWhere((element) {
                                Map<String, dynamic> selectedData =
                                    jsonDecode(element.data.toString());
                                return selectedData['id'].toString() ==
                                    item!.id.toString();
                              });
                              context
                                  .read<ChatBloc>()
                                  .add(const ChatMessageUpdated(""));
                            }
                            selectedPropertyList.add(MessageContent(
                              cardType: "propertyDetail",
                              timeStamp: app_instance.utility
                                  .getUnixTimeStampInPubNubPrecision(),
                              data: item!.toString(),
                            ));
                            context.read<ChatBloc>().add(ChatMessageUpdated(
                                item!.nameEnglish!.toString()));
                          },
                          child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              alignment: Alignment.center,
                              color: (isSelected) ? greyColor : primaryColor,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                    (isSelected) ? "Select" : "Selected",
                                    style: const TextStyle(color: lightColor)),
                              )),
                        )
                      : Container()
                ],
              ),
            ),
          ));
    }
  }
}
