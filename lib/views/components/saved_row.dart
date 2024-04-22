import 'dart:convert';
import '../../config/icons.dart';
import '../../config/app_colors.dart';
import '../../views/components/check_login.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class SavedRow extends StatefulWidget {
  final Map<String, dynamic>? item;
  final dynamic filterRoomsOptionSize;
  final hashKey;
  final int? idx;
  final Function()? refreshParent;

  SavedRow(
      {Key? key,
      @required this.item,
      this.idx,
      this.hashKey,
      this.filterRoomsOptionSize,
      this.refreshParent})
      : super(key: key);

  @override
  _SavedRowState createState() => _SavedRowState(
      item: this.item!,
      idx: this.idx!,
      hashKey: this.hashKey,
      filterRoomsOptionSize: this.filterRoomsOptionSize);
}

class _SavedRowState extends State<SavedRow> {
  Map<String, dynamic>? item;
  dynamic filterRoomsOptionSize;
  dynamic hashKey;
  int? idx;
  bool? flag = true;
  dynamic jsonData;
  String? propertyType = '';
  String? subType = '';
  String? purpose = '';
  String? yearBuilt = '';

  String? bedrooms = '';
  String? toilet = '';

  String? location = '';

  String priceCond = '';
  String areaCond = '';

  _SavedRowState(
      {this.item, this.idx, this.hashKey, this.filterRoomsOptionSize});

  @override
  void initState() {
    super.initState();

    dynamic jsonData = json.decode(item!['jsonLastSearch']);
    dynamic subTypeData =
        (item!['itemSearch'] != null && item!['itemSearch'].isNotEmpty)
            ? json.decode(item!['itemSearch'])
            : '';
    subType = (subTypeData != '') ? subTypeData['name'] : '';

    setState(() {
      propertyType = (jsonData['property_type'].toString() == 'residential')
          ? 'filter.lbl_residential'.tr()
          : 'filter.lbl_commercial'.tr();

      purpose = (jsonData['buyrent_type'].toString() == 'Sell')
          ? 'filter.lbl_buy'.tr()
          : 'filter.lbl_rent'.tr();
      subType = (subType != '') ? 'DATABASE_VAR.$subType'.tr() : '';
      yearBuilt = jsonData['year_built'].toString();
      bedrooms = jsonData['bedrooms'].toString();
      toilet = jsonData['toilet'].toString();
      location = jsonData['location'].toString();

      priceCond = (jsonData['minprice'].toString() != '')
          ? jsonData['minprice'].toString()
          : '';
      priceCond += (jsonData['maxprice'].toString() != '')
          ? (jsonData['maxprice'].toString() == 'Any')
              ? ' - ' + 'filter.lbl_any'.tr()
              : ' - ' + jsonData['maxprice'].toString()
          : '';
      areaCond = (jsonData['minarea'].toString() != '')
          ? jsonData['minarea'].toString()
          : '';
      areaCond += (jsonData['maxarea'].toString() != '')
          ? (jsonData['maxarea'].toString() == 'Any')
              ? ' - ' + 'filter.lbl_any'.tr()
              : ' - ' + jsonData['maxarea'].toString()
          : '';
    });
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  resetsaved() {
    setState(() {
      widget.refreshParent!();
    });
  }

  removedSaved() async {
    String? rec = await app_instance.storage.read(key: 'searchIds');
    if (rec != null) {
      var tagsJson = jsonDecode(rec)['data'];
      if (tagsJson.length == 1) {
        //editflag = 2;
        CheckLogin().updateSavedLists(2);
      }
      {
        List? searchIdsList =
            tagsJson != null ? List.from(tagsJson.reversed) : null;
        searchIdsList!.removeAt(idx!);
        searchIdsList.reversed;
        Map<String, dynamic> myObject = {'data': searchIdsList};

        await app_instance.storage
            .write(key: "searchIds", value: jsonEncode(myObject));
        String? recSearch =
            await app_instance.storage.read(key: 'searchSavedLists');
        if (recSearch != null) {
          var tagsJson = jsonDecode(recSearch)['data'];
          List<Object> itemsJson = [];
          itemsJson = tagsJson != null ? List.from(tagsJson.reversed) : [];
          itemsJson.removeAt(idx!);
          itemsJson.reversed;
          Map<String, dynamic> myObjectList = {'data': itemsJson};
          await app_instance.storage
              .write(key: "searchSavedLists", value: jsonEncode(myObjectList));
        }
        CheckLogin().updateSavedLists(1);
      }
    }

    setState(() {
      flag = false;
    });
  }

  searchListPage() async {
    String jsonLastSearch = item!['jsonLastSearch'] ?? '';
    String msIdx = item!['msIdx'] ?? '';
    String itemSearch = item!['itemSearch'] ?? '';
    String jsonAmenitiesSearch = item!['jsonAmenitiesSearch'] ?? '';
    String sortBy = item!['sortBy'] ?? '';
    String resetSearch = item!['resetSearch'] ?? '';

    await app_instance.storage
        .write(key: "jsonLastSearch", value: jsonLastSearch);
    await app_instance.storage.write(key: "msIdx", value: msIdx);
    if (itemSearch != null) {
      await app_instance.storage.write(key: "itemSearch", value: itemSearch);
    }

    if (jsonAmenitiesSearch != null) {
      await app_instance.storage
          .write(key: "jsonAmenitiesSearch", value: jsonAmenitiesSearch);
    }

    await app_instance.storage.write(key: "sortBy", value: sortBy);
    if (resetSearch != null) {
      await app_instance.storage.write(key: "resetSearch", value: resetSearch);
    }
    if (mounted) {
      app_instance.storage.write(key: "defaultSearch", value: "false");
      Navigator.pushReplacementNamed(context, '/search_result',
          arguments: [2, false]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!flag!) {
      return Container();
    } else {
      return GestureDetector(
        onTap: () {
          searchListPage();
        },
        child: Card(
            elevation: 0,
            // margin: EdgeInsets.all(5),
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (location != '') ...[
                                        Text(location!,
                                                style: const TextStyle(
                                                    color: darkColor,
                                                    fontWeight:
                                                        FontWeight.w500))
                                            .tr(),
                                        const SizedBox(height: 8)
                                      ],
                                      Text(propertyType!,
                                          style: const TextStyle(
                                              color: darkColor,
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 8),
                                      if (toilet != '')
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                              text:
                                                  'savedSearches.lbl_saved_baths'
                                                      .tr(),
                                              style: const TextStyle(
                                                  fontFamily: 'DM Sans',
                                                  color: greyColor)),
                                          const TextSpan(
                                              text: ': ',
                                              style:
                                                  TextStyle(color: greyColor)),
                                          TextSpan(
                                              text: toilet,
                                              style: const TextStyle(
                                                  fontFamily: 'DM Sans',
                                                  color: darkColor,
                                                  fontWeight: FontWeight.w500))
                                        ])),
                                      if (toilet != '')
                                        const SizedBox(height: 8),
                                      if (areaCond != '')
                                        RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text:
                                                      'savedSearches.lbl_saved_area'
                                                          .tr(),
                                                  style: const TextStyle(
                                                      fontFamily: 'DM Sans',
                                                      color: greyColor)),
                                              const TextSpan(
                                                  text: ': ',
                                                  style: TextStyle(
                                                      color: greyColor)),
                                              TextSpan(
                                                  text: areaCond,
                                                  style: const TextStyle(
                                                      fontFamily: 'DM Sans',
                                                      color: darkColor,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ])),
                                    ]),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text:
                                                'savedSearches.lbl_saved_purpose'
                                                    .tr(),
                                            style: const TextStyle(
                                                fontFamily: 'DM Sans',
                                                color: greyColor)),
                                        const TextSpan(
                                            text: ': ',
                                            style: TextStyle(color: greyColor)),
                                        TextSpan(
                                            text: purpose,
                                            style: const TextStyle(
                                                fontFamily: 'DM Sans',
                                                color: darkColor,
                                                fontWeight: FontWeight.w500))
                                      ])),
                                      const SizedBox(height: 8),
                                      if (subType != '')
                                        Text(subType!,
                                            style: const TextStyle(
                                                color: greyColor)),
                                      if (subType != '')
                                        const SizedBox(height: 8),
                                      if (bedrooms != '')
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                              text:
                                                  'savedSearches.lbl_saved_beds'
                                                      .tr(),
                                              style: const TextStyle(
                                                  fontFamily: 'DM Sans',
                                                  color: greyColor)),
                                          const TextSpan(
                                              text: ': ',
                                              style:
                                                  TextStyle(color: greyColor)),
                                          TextSpan(
                                              text: bedrooms,
                                              style: const TextStyle(
                                                  fontFamily: 'DM Sans',
                                                  color: darkColor,
                                                  fontWeight: FontWeight.w500))
                                        ])),
                                      if (bedrooms != '')
                                        const SizedBox(height: 8),
                                      if (yearBuilt != '')
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                              text:
                                                  'savedSearches.lbl_saved_year'
                                                      .tr(),
                                              style: const TextStyle(
                                                  fontFamily: 'DM Sans',
                                                  color: greyColor)),
                                          const TextSpan(
                                              text: ': ',
                                              style:
                                                  TextStyle(color: greyColor)),
                                          const TextSpan(
                                              text: '0',
                                              style: TextStyle(
                                                  fontFamily: 'DM Sans',
                                                  color: darkColor,
                                                  fontWeight: FontWeight.w500))
                                        ])),
                                    ])
                              ]),
                          if (priceCond != '') ...[
                            const SizedBox(height: 8),
                            RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          'savedSearches.lbl_saved_price'.tr(),
                                      style: const TextStyle(
                                          fontFamily: 'DM Sans',
                                          color: greyColor)),
                                  const TextSpan(
                                      text: ': ',
                                      style: TextStyle(color: greyColor)),
                                  TextSpan(
                                      text: priceCond,
                                      style: const TextStyle(
                                          fontFamily: 'DM Sans',
                                          color: darkColor,
                                          fontWeight: FontWeight.w500))
                                ])),
                          ]
                        ])),
                    Column(children: [
                      SizedBox(
                          width: 40,
                          child: IconButton(
                              icon: const Icon(
                                trashIcon,
                                color: favoriteColor,
                              ),
                              onPressed: () {
                                removedSaved();
                                setState(() {});
                              }))
                    ]),
                  ],
                ))),
      );
    }
  }
}
