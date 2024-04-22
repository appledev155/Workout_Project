import 'package:anytimeworkout/config/styles.dart';
import '../../../config/app_colors.dart';
import '../../../config/icons.dart';
import '../../../main.dart';
import '../../../views/components/check_login.dart';
import 'package:flutter/material.dart';
import '../../../model/item_model.dart';
import 'dart:convert';
import 'package:anytimeworkout/config.dart' as app_instance;

class FavoriteIcon extends StatefulWidget {
  //final List amenities;
  final ItemModel? item;
  final String? showOnList;
  final Function()? notifyParent;
  final Function()? notifyFavorite;

  const FavoriteIcon(
      {Key? key,
      this.item,
      this.showOnList,
      required this.notifyParent,
      required this.notifyFavorite})
      : super(key: key);
  @override
  _FavoriteIconState createState() =>
      _FavoriteIconState(item: this.item!, showOnList: this.showOnList!);
}

class _FavoriteIconState extends State<FavoriteIcon> {
  bool? isFavorite = false;
  List<String>? myList = <String>[];
  int? idx = 0;
  ItemModel? item;
  String? showOnList;

  _FavoriteIconState({this.item, this.showOnList});

  @override
  void initState() {
    super.initState();
    streamController.stream.asBroadcastStream().listen((event) {
      if (event == 1) getData();
    });
    getData();
  }

  Future<bool> getData() async {
    String? rec = await app_instance.storage.read(key: 'favIds');
    if (rec != null) {
      var tagsJson = jsonDecode(rec)['data'];
      List<String>? myList = tagsJson != null ? List.from(tagsJson) : null;
      if (myList!.contains(item!.propertyKey)) {
        idx = myList.indexOf(item!.propertyKey!);
        if (mounted) {
          setState(() {
            this.isFavorite = true;
            this.myList = myList;
            this.idx = idx;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            this.isFavorite = false;
            this.myList = myList;
          });
        }
      }
    }
    return isFavorite!;
  }

  Future<bool> toggleState() async {
    await getData();
    dynamic editflag = 0;
    if (this.isFavorite == false) {
      if (this.myList!.length > 0) {
        editflag = 1;
      }
      this.myList!.add(item!.propertyKey!);
    } else {
      this.myList!.removeAt(this.idx!);
      if (this.myList!.length == 0) {
        editflag = 2;
      }
    }
    Map<String, dynamic> myObject = {'data': this.myList};
    await app_instance.storage
        .write(key: "favIds", value: jsonEncode(myObject));
    setState(() {
      this.isFavorite = (this.isFavorite!) ? false : true;
    });

    if (this.showOnList == 'favorite') {
      if (!this.isFavorite!) {
        if (this.myList!.length == 0) {
          widget.notifyFavorite!();
        } else {
          widget.notifyParent!();
        }
      }
    }

    if (this.showOnList == 'detail') streamController.add(1);
    CheckLogin().updateFavirates(editflag);

    await app_instance.storage.write(key: "favUpdated", value: 'true');

    return isFavorite!;
  }
/* 
  storeItem(flag) async {
    String rec = await app_instance.storage.read(key: 'favLists');
    List<Object> items = [];
    dynamic editflag = 0;
    if (rec != null) {
      var tagsJson = jsonDecode(rec);
      items = tagsJson != null ? List.from(tagsJson) : [];
      if (items.length > 0) {
        editflag = 1;
      }
    }
    if (flag) {
      items.removeAt(this.idx);
      if (items.length == 0) {
        editflag = 2;
      }
    } else {
      items.add(item.toJson());
    }
    await app_instance.storage.write(key: "favLists", value: jsonEncode(items));

    if (this.showOnList == 'favorite') {
      if (flag) {
        if (items.length == 0) {
          widget.notifyFavorite();
        } else
          widget.notifyParent();
      }
      //api call
    }
    CheckLogin().updateFavirates(editflag);
  } */

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(pageHPadding / 2),
      icon: Icon(
        favIcon,
        size: (showOnList == 'detail') ? null : 18,
        color: this.isFavorite! ? favoriteColor : greyColor,
      ),
      onPressed: () {
        toggleState();
      },
    );
  }
}
