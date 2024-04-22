import 'dart:convert';
import 'package:anytimeworkout/bloc/search_result/search_result_bloc.dart';
import 'package:anytimeworkout/main.dart';
import 'package:anytimeworkout/module/internet/bloc/internet_bloc.dart';
import 'package:anytimeworkout/module/internet/config.dart';
import 'package:anytimeworkout/repository/user_repository.dart';
import 'package:anytimeworkout/views/components/forms/dropdown_amenities.dart';
import 'package:anytimeworkout/views/components/forms/location_choose_button.dart';
import 'package:anytimeworkout/views/components/forms/rent_frequency_button.dart';
import 'package:anytimeworkout/views/screens/result/result_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../config/app_colors.dart';
import '../../../config/data.dart';
import '../../../config/icons.dart';
import '../../../config/styles.dart';
import '../../../repository/property_type_repository.dart';
import '../../../views/components/forms/amenities_dialog.dart';
import '../../../views/components/forms/buyrent_type_button.dart';
import '../../../views/components/forms/dropdown_custom.dart';
import '../../../views/components/forms/input_field_prefix.dart';
import '../../../views/components/forms/location_auto_complete.dart';
import '../../../views/components/forms/min_max_dialog.dart';
import '../../../views/components/forms/radio_select_button.dart';
import '../../../views/components/forms/select_box_dialog.dart';
import '../../../views/components/forms/subtype_type_button.dart';
import '../../../views/components/forms/text_icon.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class SearchScreen extends StatefulWidget {
  final Function()? refreshList;
  final bool? comeFromSearch;
  const SearchScreen({Key? key, this.refreshList, this.comeFromSearch = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController? locationController = TextEditingController();
  TextEditingController? minPriceController = TextEditingController();
  TextEditingController? maxPriceController = TextEditingController();
  TextEditingController? minPropertyAreaController = TextEditingController();
  TextEditingController? maxPropertyAreaController = TextEditingController();
  ScrollController? scrollController = ScrollController();

  final subTypeButtonStateKey = GlobalKey<SubTypeButtonState>();
  final buyrentTypeButtonStateKeyFirst = GlobalKey<BuyrentTypeButtonState>();
  final buyrentTypeButtonStateKeySecond = GlobalKey<BuyrentTypeButtonState>();
  final completionStatusKey = GlobalKey<BuyrentTypeButtonState>();
  final locationKey = GlobalKey<LocationChooseButtonState>();
  final rentKey = GlobalKey<RentFrequencyButtonState>();
  final advanceMenuKey = GlobalKey();

  final locationAutoCompleteStateKey = GlobalKey<LocationAutoCompleteState>();
  int completionStatus = 1;
  bool searchSubmit = false;
  String filterBedroom = '';
  String propertyTypeId = '0';
  String buyrentType = 'Sell';
  String propertyType = 'residential';
  String amenitiesValue = '';
  bool amenitiesChk = true;
  List subtypeItemsList = [];
  List filterAmenityItems = [];
  List defaultRec = [];
  List checkAvailability = [];
  List amenities = [];
  List amenitiesNameList = [];
  String amenitiesSelectedIds = '';
  String completionStatusValue = 'Ready';
  String yearBuiltValue = '';
  String priceMin = '';
  String priceMax = '';
  String bedroomValue = '';
  String filterBathroom = '';
  String bathValue = '';
  String cityArrayChoiceName = '0';
  String tempCityArrayIndex = '0';
  int priceType = 0;
  dynamic oldRec;
  dynamic oldRecTemp;
  String? propertyAreaUnit = '';
  int locationIdIndex = 0;
  String locID = '';
  String locTxt = '';
  String sortBy = 'newest';
  List location = [];
  List locationEng = [];
  dynamic params;
  bool isData = true;
  bool _isVisible = false;
  FocusNode locationFocus = FocusNode();
   final resultScreen = ResultScreenState();
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
        .copyWith(statusBarIconBrightness: Brightness.dark));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getAlgolia();
      _getPropertyType();
      getAlgoliaKey();
      if (widget.comeFromSearch!) {
        resetForm();
      }
    });
  }

  setBuyrentType(selVal) {
    setState(() {
      buyrentType = selVal;
      /*  if (selVal == 'Rent')
        this.completionStatus = 1;
      else
        this.completionStatus = 0; */
      completionStatus = 1;
    });
  }

  setPropertyType(selVal) async {
    await app_instance.storage.delete(key: 'itemSearch');
    subTypeButtonStateKey.currentState?.updateState(selVal);
    propertyTypeId = '0';
    setState(() {
      propertyType = selVal;
      checkAvailability = json.decode(json.encode(defaultRec));
    });
  }

  setCompletionStatus(selval) {
    setState(() {
      if (selval == 'Ready') {
        completionStatus = 1;
      } else {
        completionStatus = 0;
      }
    });
  }

  createChip(locTxt, locEng) {
    location.clear();
    locationEng.clear();
    if (locTxt != '') {
      location.add(locTxt);
      locationEng.add(locEng);
    }
  }

  setLoc(id) {
    locationKey.currentState!.updateState(id);
    setState(() {});
  }

  setLocation(locID, locTxt, algoliaLocationId, locTxtEnglish) {
    createChip(locTxt, locTxtEnglish);
    if (locTxt != '') {
      tempCityArrayIndex = algoliaLocationId.toString();
      cityArrayChoiceName = algoliaLocationId.toString();
      setState(() {
        locID = locID;
        locTxt = locTxt;
      });
    } else if (locTxt == '') {
      locationKey.currentState!.updateState(algoliaLocationId);
      location.clear();
      setState(() {});
    }
  }

  _isNumberArabic(String value) {
    value = value
        .replaceAll('\u0660', '0')
        .replaceAll('\u0661', '1')
        .replaceAll('\u0662', '2')
        .replaceAll('\u0663', '3')
        .replaceAll('\u0664', '4')
        .replaceAll('\u0665', '5')
        .replaceAll('\u0666', '6')
        .replaceAll('\u0667', '7')
        .replaceAll('\u0668', '8')
        .replaceAll('\u0669', '9');

    value = value
        .replaceAll('٠', '0')
        .replaceAll('١', '1')
        .replaceAll('٢', '2')
        .replaceAll('٣', '3')
        .replaceAll('٤', '4')
        .replaceAll('٥', '5')
        .replaceAll('٦', '6')
        .replaceAll('٧', '7')
        .replaceAll('٨', '8')
        .replaceAll('٩', '9');
    return value;
  }

  Future<dynamic> _getPropertyType() async {
    String? getpropertyAreaUnit =
        await app_instance.storage.read(key: 'propertyAreaUnit');
    final temp = await app_instance.storage.read(key: "locationIdIndex");
    if (temp != null) locationIdIndex = int.tryParse(temp)!;
    if (getpropertyAreaUnit != null) {
      propertyAreaUnit = getpropertyAreaUnit;
    }

    oldRecTemp = await app_instance.storage.read(key: 'jsonOldSearch');
    oldRec = await app_instance.storage.read(key: 'jsonLastSearch');

    if (oldRec != null) {
      dynamic result = json.decode(oldRec);

      setState(() {
        propertyTypeId = result['property_type_id'].toString();
        buyrentType = result['buyrent_type'].toString();
        propertyType = result['property_type'].toString().toLowerCase();
        completionStatus = (result['property_type_option'] == '')
            ? 1
            : (result['property_type_option'] == '1')
                ? 1
                : 0;
        yearBuiltValue = result['year_built'];
        filterBedroom = result['bedrooms'];
        filterBathroom = result['toilet'];
        minPriceController!.text = result['minprice'];
        if (result['maxprice'] == '12400000') {
          maxPriceController!.text = 'filter.lbl_any'.tr();
        } else {
          maxPriceController!.text = result['maxprice'];
        }
        maxPriceController!.text = result['maxprice'];
        minPropertyAreaController!.text = result['minarea'];
        maxPropertyAreaController!.text = result['maxarea'];
        priceType = (result['price_type'] != '')
            ? (result['price_type'] == '0')
                ? 0
                : int.parse(result['price_type'])
            : 0;
        propertyAreaUnit = result['property_area_unit'];
        locID = result['location_id_area'];
        locTxt = result['location'];
        createChip(result['location'], result['locationEnglish']);
        cityArrayChoiceName =
            (result['cityArrayIndex'] != '') ? result['cityArrayIndex'] : '0';
        tempCityArrayIndex = result['cityArrayIndex'];
        sortBy =
            result['sort_by'].runtimeType != Null ? result['sort_by'] : sortBy;
        amenitiesSelectedIds = result['amenities'];
        completionStatusValue = (completionStatus == 1) ? 'Ready' : 'Off-plan';
        //if (completionStatus == 2) completionStatusValue = '';
      });
    }

    /*  Object jsonAmenitiesData = {};
    if (amenitiesChk) {
      jsonAmenitiesData = {
        'amenitiesNameList': amenitiesNameList,
        'amenities': amenities,
        'amenitiesValue': amenitiesValue
      };
    } */

    String rec = await app_instance.propertyTypeRepository.getPropertyType();
    if (rec != null) {
      dynamic proType = jsonDecode(rec);
      setState(() {
        subtypeItemsList.add(proType['residential']);
        subtypeItemsList.add(proType['commercial']);
        filterAmenityItems.add(proType['amenities']);
        defaultRec = List.from(proType['check_availability']);
        checkAvailability = json.decode(json.encode(defaultRec));
      });
    }

    if (oldRec != null) {
      dynamic olditemSearch =
          await app_instance.storage.read(key: 'itemSearch');
      if (olditemSearch != null) {
        dynamic item = json.decode(olditemSearch);
        setPropertyTypeId(item);
      }

      dynamic oldAmenitiesSearch =
          await app_instance.storage.read(key: 'jsonAmenitiesSearch');
      if (oldAmenitiesSearch != null) {
        dynamic amt = json.decode(oldAmenitiesSearch);
        setState(() {
          amenitiesNameList = amt['amenitiesNameList'] ?? [];
          amenities = amt['amenities'] ?? [];
          amenitiesValue = amt['amenitiesValue'] ?? '';
        });
      }
    }
  }

  setPropertyTypeId(dynamic item) async {
    checkAvailability.asMap().entries.map((entry) {
      int idx = entry.key;
      checkAvailability[idx]['status'] = (item['availability']
              .toString()
              .split(",")
              .contains(entry.value['id'].toString()))
          ? true
          : false;
      checkAvailability[idx]['req'] = (item['required_availability']
              .toString()
              .split(",")
              .contains(entry.value['id'].toString()))
          ? true
          : false;
    }).toList();
    amenitiesChk = (item['amenities'] == 'yes') ? true : false;
    setState(() {
      propertyTypeId = item['id'].toString();
    });

    String itemSearch = jsonEncode(item);
    await app_instance.storage.write(key: "itemSearch", value: itemSearch);
  }

  _submitForm(BuildContext context) async {
    await app_instance.storage.write(key: 'defaultSearch', value: 'false');

    if (location.isNotEmpty && location.first != "") {
      locTxt = location.first;
    }

    String propertyTypeIdTemp = propertyTypeId;
    if (propertyTypeIdTemp == '0') propertyTypeIdTemp = '';

    String yearBuiltTemp = '';
    if (propertyTypeId == '0' || checkAvailability[4]['status']) {
      yearBuiltTemp = yearBuiltValue;
    } else {
      yearBuiltTemp = '';
    }
    if (yearBuiltTemp == null) yearBuiltTemp = '';

    String minPrice = '';
    String maxPrice = '';
    if (maxPriceController!.text == 'Any') {
      minPrice = _isNumberArabic(minPriceController!.text);
      maxPrice = 'Any';
    } else {
      minPrice = _isNumberArabic(minPriceController!.text);
      maxPrice = _isNumberArabic(maxPriceController!.text);
    }

    String minArea = '';
    String maxArea = '';
    if (maxPropertyAreaController!.text == 'Any') {
      minArea = _isNumberArabic(minPropertyAreaController!.text);
      maxArea = 'Any';
    } else {
      minArea = _isNumberArabic(minPropertyAreaController!.text);
      maxArea = _isNumberArabic(maxPropertyAreaController!.text);
    }
    dynamic bedroomsTemp = '';
    if (propertyTypeId == '0' || checkAvailability[6]['status']) {
      bedroomsTemp = filterBedroom;
    } else {
      bedroomsTemp = '';
    }
    if (bedroomsTemp == null) bedroomsTemp = '';

    String toiletTemp = '';
    if (propertyTypeId == '0' || checkAvailability[3]['status']) {
      toiletTemp = filterBathroom;
    } else {
      toiletTemp = '';
    }
    if (toiletTemp == null) toiletTemp = '';

    String amenitiesTemp = '';
    if (amenitiesChk) {
      amenitiesTemp = amenitiesSelectedIds;
    }
    if (amenitiesTemp == null) amenitiesTemp = '';

    String completionStatusTemp = '';
    if (buyrentType == 'Sell' &&
        (propertyTypeId == '0' || checkAvailability[2]['status'])) {
      completionStatusTemp = completionStatus.toString();
      //  if (completionStatusTemp == '2') completionStatusTemp = '';
    }

    if (completionStatusTemp == null) completionStatusTemp = '';
    Map<String, Object> jsonData = {
      'property_type_id': propertyTypeIdTemp,
      'buyrent_type': buyrentType,
      'property_type': propertyType,
      'property_type_option': completionStatusTemp,
      'year_built': yearBuiltTemp,
      'bedrooms': bedroomsTemp,
      'toilet': toiletTemp,
      'minprice': minPrice,
      'maxprice': maxPrice,
      'minarea': minArea,
      'maxarea': maxArea,
      'price_type': priceType.toString(),
      'property_area_unit': propertyAreaUnit!,
      'location_id_area': locID,
      'location': locTxt,
      'locationEnglish': locationEng.isNotEmpty ? locationEng.first : '',
      'amenities': amenitiesTemp,
      'sort_by': sortBy,
      'cityArrayIndex': cityArrayChoiceName,
    };
    Map<String, Object> jsonAmenitiesData = {};
    if (amenitiesChk) {
      jsonAmenitiesData = {
        'amenitiesNameList': amenitiesNameList,
        'amenities': amenities,
        'amenitiesValue': amenitiesValue
      };
    }

    String jsonAmenitiesSearch = jsonEncode(jsonAmenitiesData);
    await app_instance.storage
        .write(key: 'jsonAmenitiesSearch', value: jsonAmenitiesSearch);

    await app_instance.storage.write(key: 'sortBy', value: sortBy);

    String jsonLastSearch = jsonEncode(jsonData);
    await app_instance.storage
        .write(key: 'jsonLastSearch', value: jsonLastSearch);
    await app_instance.storage
        .write(key: 'jsonOldSearch', value: jsonLastSearch);

    if (oldRecTemp != jsonLastSearch) {
      await app_instance.storage.write(key: 'resetSearch', value: '1');
    }

    dynamic itemSearchTemp = await app_instance.storage.read(key: 'itemSearch');
    if (itemSearchTemp != null) {
      app_instance.storage.write(key: 'itemSearchTemp', value: itemSearchTemp);
    } else {
      app_instance.storage.delete(key: 'itemSearchTemp');
    }

    app_instance.storage
        .write(key: 'jsonLastSearchTemp', value: jsonLastSearch);
    app_instance.storage
        .write(key: 'jsonAmenitiesSearchTemp', value: jsonAmenitiesSearch);
    app_instance.storage.write(key: 'sortByTemp', value: sortBy);

    String? routeName = ModalRoute.of(context)!.settings.name;
    if (searchSubmit == true) {
      if (mounted) {
        Navigator.pushNamed(context, '/search_result', arguments: [2, false]);
      }
      if (widget.refreshList != null) {
        widget.refreshList!();
      }
    } else {
      if (mounted) {
        Navigator.pushNamed(context, '/search_result', arguments: [2, false]);
      }
      if (widget.refreshList != null) {
        widget.refreshList!();
      }
    }
  }

  resetForm() async {
    await app_instance.storage.delete(key: 'jsonLastSearch');
    await app_instance.storage.delete(key: 'jsonOldSearch');
    await app_instance.storage.delete(key: 'resetSearch');
    await app_instance.storage.delete(key: 'itemSearch');
    await app_instance.storage.delete(key: 'jsonAmenitiesSearch');
    await app_instance.storage.delete(key: 'sortBy');
    await app_instance.storage.delete(key: "locationIdIndex");
    await app_instance.storage.write(key: "resetSearch", value: '1');

    String? getpropertyAreaUnit =
        await app_instance.storage.read(key: 'propertyAreaUnit');

    if (getpropertyAreaUnit != null) {
      propertyAreaUnit = getpropertyAreaUnit;
    }

    setState(() {
      propertyTypeId = '0';
      buyrentType = 'Sell';
      propertyType = 'residential';
      completionStatus = 1;
      yearBuiltValue = '';
      filterBedroom = '';
      filterBathroom = '';
      minPriceController!.text = '';
      maxPriceController!.text = '';
      minPropertyAreaController!.text = '';
      maxPropertyAreaController!.text = '';
      priceType = 0;
      propertyAreaUnit = propertyAreaUnit;
      locID = '';
      locTxt = '';
      amenitiesChk = true;
      cityArrayChoiceName = '0';
      tempCityArrayIndex = '0';
      amenities = [];
      amenitiesNameList = [];
      amenitiesSelectedIds = '';
      amenitiesValue = '';
      sortBy = 'newest';

      completionStatusValue = (completionStatus == 1)
          ? 'addproperty.lbl_ready_to_move_in'
          : 'addproperty.lbl_under_construnction';
      //if (completionStatus == 2) completionStatusValue = '';
    });

    buyrentTypeButtonStateKeyFirst.currentState?.updateState('Sell');
    buyrentTypeButtonStateKeySecond.currentState?.updateState('residential');
    locationKey.currentState?.updateState('0');
    await setPropertyType('residential');
    locationAutoCompleteStateKey.currentState?.resetState();
  }

  /* getFocus() {
    if(FocusScope.of(context).hasFocus() == )
  } */

  @override
  Widget build(BuildContext context) {
    if (subtypeItemsList.isNotEmpty && !isData) {
      return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollController!.position.userScrollDirection ==
                ScrollDirection.reverse) {
              FocusScope.of(context).requestFocus(FocusNode());
              //cityArrayChoiceName = tempCityArrayIndex;
              locationAutoCompleteStateKey.currentState?.resetTextField();
              /* setState(() {});
              locationKey.currentState.updateState(cityArrayChoiceName); */
            } else if (scrollController!.position.userScrollDirection ==
                ScrollDirection.reverse) {
              FocusScope.of(context).requestFocus(FocusNode());
              //cityArrayChoiceName = tempCityArrayIndex;
              locationAutoCompleteStateKey.currentState?.resetTextField();
              /* setState(() {});
              locationKey.currentState.updateState(cityArrayChoiceName); */
            }
            return false;
          },
          child: GestureDetector(
              onTap: () {
                locationAutoCompleteStateKey.currentState?.resetTextField();
                /* cityArrayChoiceName = tempCityArrayIndex;
                setState(() {});
                locationKey.currentState.updateState(cityArrayChoiceName);
                createChip(locTxt); */
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Scaffold(
                  backgroundColor: lightColor,
                  appBar: AppBar(
                    centerTitle: true,
                    backgroundColor: lightColor,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                        statusBarColor: lightColor,
                        statusBarIconBrightness: Brightness.dark),
                    elevation: 1,
                    leading: IconButton(
                      icon: const Icon(clearIcon, color: blackColor),
                      onPressed: () => {
                        Navigator.pop(context),
                      },
                    ),
                    title: Text('filter.lbl_filter'.tr(),
                        style: const TextStyle(color: blackColor)),
                    actions: [
                      IconButton(
                          icon: const Icon(refreshIcon, color: blackColor),
                          onPressed: () {}),
                    ],
                  ),
                  body: SingleChildScrollView(
                      controller: scrollController,
                      physics: (locationFocus.hasFocus)
                          ? const NeverScrollableScrollPhysics()
                          : const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildBuyrentTypeButton(),
                              _buildSpaceV(15),
                              _buildLocationChoice(),
                              _buildSpaceV(15),
                              _buildLocationInput(),
                              _buildSpaceV(10),
                              Wrap(children: [_buildLocationBubble()]),
                              const Divider(thickness: 1.5),
                              _buildSpaceV(15),
                              _buildLabelHeader(
                                  homeIcon, 'filter.lbl_property_types'.tr()),
                              _buildSpaceV(15),
                              _buildPropertyTypeButton(),
                              _buildSpaceV(20),
                              if (propertyType == 'residential')
                                _buildLabelHeader(subTypeIcon,
                                    '${'filter.lbl_residential'.tr()} ${'filter.lbl_type'.tr()}'),
                              if (this.propertyType == 'commercial')
                                _buildLabelHeader(subTypeIcon,
                                    '${'filter.lbl_commercial'.tr()} ${'filter.lbl_type'.tr()}'),
                              _buildSpaceV(15),
                              _buildSubTypeButton(),
                              _buildSpaceV(10),
                              const Divider(thickness: 1.5),
                              _buildSpaceV(15),
                              if (buyrentType == 'Rent')
                                _buildLabelHeader(rentFrequencyIcon,
                                    'filter.lbl_rent_frequency'.tr()),
                              if (buyrentType == 'Rent') _buildSpaceV(15),
                              if (buyrentType == 'Rent')
                                _buildRentFrequencyChoice(),
                              if (this.buyrentType == 'Rent') _buildSpaceV(10),
                              if (this.buyrentType == 'Rent')
                                const Divider(thickness: 1.5),
                              if (this.buyrentType == 'Rent') _buildSpaceV(15),
                              if (this.buyrentType == 'Sell' &&
                                  (this.propertyTypeId == '0' ||
                                      this.checkAvailability[2]['status']))
                                _buildLabelHeader(activeIcon,
                                    'addproperty.lbl_property_status'.tr()),
                              if (buyrentType == 'Sell' &&
                                  (propertyTypeId == '0' ||
                                      checkAvailability[2]['status']))
                                _buildSpaceV(15),
                              if (buyrentType == 'Sell' &&
                                  (propertyTypeId == '0' ||
                                      checkAvailability[2]['status']))
                                _buildCompletionStatusButton(),
                              if (buyrentType == 'Sell' &&
                                  (propertyTypeId == '0' ||
                                      checkAvailability[2]['status']))
                                _buildSpaceV(15),
                              if (buyrentType == 'Sell' &&
                                  (propertyTypeId == '0' ||
                                      checkAvailability[2]['status']))
                                const Divider(thickness: 1.5),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: RichText(
                                    key: advanceMenuKey,
                                    text: TextSpan(
                                        text: _isVisible
                                            ? 'filter.lbl_hide'.tr()
                                            : 'filter.lbl_advanced'.tr(),
                                        style: TextStyle(
                                            color: primaryDark,
                                            fontSize: pageIconSize,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'DM Sans'),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            setState(() {
                                              _isVisible = !_isVisible;
                                            });
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 150), () {
                                              if (_isVisible) {
                                                Scrollable.ensureVisible(
                                                    advanceMenuKey
                                                        .currentContext!);
                                              }
                                              // Do something
                                            });
                                          }),
                                  )),
                              _buildSpaceV(15),
                              Visibility(
                                  visible: _isVisible,
                                  child: Column(children: [
                                    _buildLabelHeader(
                                        priceIcon, 'filter.lbl_price'.tr()),
                                    _buildSpaceV(10),
                                    _buildFilterPriceRange(),
                                    _buildSpaceV(10),
                                    const Divider(thickness: 1.5),
                                    _buildSpaceV(15),
                                    _buildLabelHeader(areaSizeIcon,
                                        'filter.lbl_property_area'.tr()),
                                    // _buildFilterPropertyAreaRange(),
                                    _buildSpaceV(10),
                                    const Divider(thickness: 1.5),

                                    if (propertyTypeId == '0' ||
                                        checkAvailability[6]['status'])
                                      _buildSpaceV(15),
                                    if (propertyTypeId == '0' ||
                                        checkAvailability[6]['status'])
                                      _buildLabelHeader(bedroomIcon,
                                          'filter.lbl_bedrooms'.tr()),
                                    if (propertyTypeId == '0' ||
                                        checkAvailability[6]['status'])
                                      _buildSpaceV(15),
                                    if (propertyTypeId == '0' ||
                                        checkAvailability[6]['status'])
                                      _buildBedroomChoice(),
                                    if (propertyTypeId == '0' ||
                                        checkAvailability[6]['status'])
                                      _buildSpaceV(10),
                                    if (propertyTypeId == '0' ||
                                        checkAvailability[6]['status'])
                                      const Divider(thickness: 1.5),
                                    if (amenitiesChk) _buildSpaceV(10),
                                    if (amenitiesChk) _buildAmenitiesChoices(),
                                    if (amenitiesChk) _buildSpaceV(10),
                                    if (amenitiesChk)
                                      const Divider(thickness: 1.5),

                                    if (propertyTypeId == '0' ||
                                        checkAvailability[3]['status'])
                                      _buildSpaceV(15),
                                    if (propertyTypeId == '0' ||
                                        checkAvailability[3]['status'])
                                      _buildLabelHeader(bathIcon,
                                          'filter.lbl_bathrooms'.tr()),
                                    if (propertyTypeId == '0' ||
                                        checkAvailability[3]['status'])
                                      _buildSpaceV(15),
                                    if (propertyTypeId == '0' ||
                                        checkAvailability[3]['status'])
                                      _buildBathroomChoice(),
                                    if (propertyTypeId == '0' ||
                                        checkAvailability[3]['status'])
                                      _buildSpaceV(10),
                                    if (propertyTypeId == '0' ||
                                        checkAvailability[3]['status'])
                                      const Divider(thickness: 1.5),

                                    /* if (this.buyrentType == 'Sell' &&
                                  (this.propertyTypeId == '0' ||
                                      this.checkAvailability[2]['status']))
                                _buildSpaceV(25), */

                                    if (propertyTypeId == '0' ||
                                        checkAvailability[4]['status'])
                                      _buildSpaceV(25),
                                    if (propertyTypeId == '0' ||
                                        checkAvailability[4]['status'])
                                      _buildYearBuilt(),
                                    _buildSpaceV(25)
                                  ]))
                            ],
                          ))),
                  bottomNavigationBar: SafeArea(
                    minimum:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                    child: SizedBox(
                      height: unitWidth * 40,
                      width: deviceWidth,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            backgroundColor: primaryDark),
                        onPressed: () {
                          if (context
                                  .read<InternetBloc>()
                                  .state
                                  .connectionType ==
                              ConnectionType.mobile) {
                            app_instance.appConfig.numberOfRecords = 100;
                          }
                          if (context
                                  .read<InternetBloc>()
                                  .state
                                  .connectionType ==
                              ConnectionType.wifi) {
                            app_instance.appConfig.numberOfRecords = 500;
                          }
                          // print('onsubmit');
                          // print(context.read<InternetBloc>().state.toString());
                          // print('onsubmit');
                          if (context
                                  .read<InternetBloc>()
                                  .state
                                  .connectionStatus !=
                              ConnectionStatus.disconnected) {
                            searchSubmit = true;
                            _submitForm(context);
                          } else {
                            Navigator.of(context).popUntil(
                                ModalRoute.withName('/search_result'));
                            if (context
                                    .read<InternetBloc>()
                                    .state
                                    .connectionStatus ==
                                ConnectionStatus.disconnected) {
                              Fluttertoast.showToast(
                                  msg: "connection.checkConnection".tr(),
                                  toastLength: Toast.LENGTH_SHORT);
                            }
                          }
                        },
                        child: Text(
                          'filter.lbl_search',
                          style: TextStyle(
                            color: lightColor,
                            fontSize: pageIconSize,
                          ),
                        ).tr(),
                      ),
                    ),
                  ))));
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: lightColor,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(
              clearIcon,
              color: blackColor,
            ),
            onPressed: () => {
              Navigator.popAndPushNamed(context, '/search_result'),
            },
          ),
          title: Text('filter.lbl_filter'.tr(),
              style: const TextStyle(color: blackColor)),
        ),
        body: Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(color: primaryDark)),
      );
    }
  }

  Widget _buildSpaceV(double size) {
    return SizedBox(height: unitWidth * size);
  }

  Widget _buildBuyrentTypeButton() {
    return Container(
      width: deviceWidth,
      alignment: Alignment.center,
      child: BuyrentTypeButton(
          key: buyrentTypeButtonStateKeyFirst,
          items: filterItems,
          stateValue: buyrentType,
          itemWidth: filterOptionTapWidth,
          itemHeight: unitWidth * 50,
          itemSpace: filterOptionTapSpace,
          titleSize: pageIconSize,
          radius: unitWidth * 5,
          selectedColor: primaryDark,
          unSelectedColor: lightColor,
          selectedBorderColor: primaryDark,
          unSelectedBorderColor: greyColor.withOpacity(0.3),
          selectedTitleColor: lightColor,
          unSelectedTitleColor: darkColor,
          isVertical: false,
          clickable: true,
          notifyParent: setBuyrentType),
    );
  }

  Widget _buildPropertyTypeButton() {
    return Container(
      width: deviceWidth,
      alignment: Alignment.center,
      child: BuyrentTypeButton(
          key: buyrentTypeButtonStateKeySecond,
          items: purposeTypeItems,
          stateValue: propertyType,
          itemHeight: unitWidth * 50,
          itemSpace: filterOptionTapSpace,
          titleSize: pageIconSize,
          radius: unitWidth * 5,
          selectedColor: primaryDark,
          unSelectedColor: lightColor,
          selectedBorderColor: primaryDark,
          unSelectedBorderColor: greyColor.withOpacity(0.3),
          selectedTitleColor: lightColor,
          unSelectedTitleColor: darkColor,
          isVertical: false,
          clickable: true,
          notifyParent: setPropertyType),
    );
  }

  Widget _buildLabelHeader(iconBtn, titleLbl) {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: TextIcon(
        title: titleLbl,
        iconData: iconBtn,
        titleColor: blackColor,
        iconColor: blackColor,
        titleSize: pageTitleSize,
        iconSize: pageIconSize,
        width: double.infinity,
        alignment: MainAxisAlignment.start,
        space: unitWidth * 10,
      ),
    );
  }

  Widget _buildCompletionStatusButton() {
    return Container(
      width: deviceWidth,
      alignment: Alignment.center,
      child: BuyrentTypeButton(
          key: completionStatusKey,
          items: completionTypeItems,
          stateValue: completionStatusValue,
          itemHeight: unitWidth * 50,
          itemSpace: filterOptionTapSpace,
          titleSize: pageIconSize,
          radius: unitWidth * 5,
          selectedColor: primaryDark,
          unSelectedColor: lightColor,
          selectedBorderColor: primaryDark,
          unSelectedBorderColor: greyColor.withOpacity(0.3),
          selectedTitleColor: lightColor,
          unSelectedTitleColor: darkColor,
          isVertical: false,
          clickable: true,
          notifyParent: setCompletionStatus),
    );
  }

  Widget _buildLocationChoice() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: unitWidth * 5),
      height: unitWidth * 30,
      alignment: Alignment.center,
      child: LocationChooseButton(
          key: locationKey,
          items: cityArrayChoice,
          stateValue: cityArrayChoiceName,
          itemHeight: unitWidth * 50,
          itemSpace: filterOptionTapSpace,
          titleSize: pageIconSize,
          indexId: locationIdIndex,
          radius: unitWidth * 5,
          selectedColor: primaryDark,
          unSelectedColor: lightColor,
          selectedBorderColor: primaryDark,
          unSelectedBorderColor: greyColor.withOpacity(0.3),
          selectedTitleColor: lightColor,
          unSelectedTitleColor: darkColor,
          isVertical: false,
          clickable: true,
          notifyParent: (location, locationId, index, locTxtEnglish) async {
            await app_instance.storage
                .write(key: "locationIdIndex", value: index.toString());
            setState(() {
              cityArrayChoiceName = locationId;
              tempCityArrayIndex = locationId;
              String changeNametoLang = location;
              if ('cityArray.ALL_CITIES'.tr() == changeNametoLang.tr()) {
                locTxt = '';
                this.location.clear();
              } else {
                locTxt = changeNametoLang.tr();
                createChip(locTxt, locTxtEnglish);
              }
            });
          }),
    );
  }

  Widget _buildLocationInput() {
    return Container(
      width: deviceWidth,
      height: unitWidth * 50,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: Center(
        child: LocationAutoComplete(
          focusNode: locationFocus,
          key: locationAutoCompleteStateKey,
          // height: unitWidth * 50,
          locationIDArea: '',
          location: '',
          params: params,
          notifyParent: setLocation,
          selectedLocation: createChip,
          locationId: '0',
          setLoc: setLoc,
          onlyCity: false,
        ),
      ),
    );
  }

  Widget _buildLocationBubble() {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
            children: location
                .map((e) => RawChip(
                      avatar: const Icon(
                        locationIcon,
                        color: lightColor,
                      ),
                      backgroundColor: primaryDark,
                      labelPadding: EdgeInsets.all(5 * unitWidth),
                      deleteIcon: const Icon(
                        deaIcon,
                        color: lightColor,
                      ),
                      onDeleted: () async {
                        location.remove(e);
                        locID = '';
                        locTxt = '';
                        await app_instance.storage
                            .delete(key: "locationIdIndex");
                        cityArrayChoiceName = '0';
                        locationKey.currentState!
                            .updateState(cityArrayChoiceName);
                        setState(() {});
                      },
                      label: Text(
                        e,
                        style: TextStyle(
                            fontSize: pageTextSize, color: lightColor),
                      ),
                    ))
                .toList()));
  }

  Widget _buildSubTypeButton() {
    return Container(
      width: deviceWidth,
      alignment: Alignment.center,
      child: SubTypeButton(
          key: subTypeButtonStateKey,
          items: subtypeItemsList,
          stateValue: propertyTypeId,
          itemWidth: unitWidth,
          itemHeight: unitWidth * 10,
          itemSpace: filterOptionTapSpace,
          titleSize: pageIconSize,
          radius: unitWidth * 5,
          selectedColor: primaryDark,
          unSelectedColor: lightColor,
          selectedBorderColor: primaryDark,
          unSelectedBorderColor: greyColor.withOpacity(0.3),
          selectedTitleColor: lightColor,
          unSelectedTitleColor: darkColor,
          isVertical: false,
          clickable: true,
          propertyType: propertyType,
          notifyParent: setPropertyTypeId),
    );
  }

  Widget _buildRentFrequencyChoice() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: unitWidth * 5),
      height: unitWidth * 30,
      alignment: Alignment.center,
      child: RentFrequencyButton(
        key: rentKey,
        items: filterRentFrequencyItems,
        stateValue: priceType,
        itemHeight: unitWidth * 30,
        itemSpace: filterOptionTapSpace,
        titleSize: pageIconSize,
        radius: unitWidth * 5,
        //indexId: this.priceType,
        selectedColor: primaryDark,
        unSelectedColor: lightColor,
        selectedBorderColor: primaryDark,
        unSelectedBorderColor: greyColor.withOpacity(0.3),
        selectedTitleColor: lightColor,
        unSelectedTitleColor: darkColor,
        clickable: true,
        isVertical: false,
        //listStyle: true,
        //translateFlag: true,
        onTap: (index) {
          setState(() {
            priceType = index;
          });
        },
      ),
    );
  }

  Widget _buildFilterPriceRange() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InputFieldPrefix(
            width: filterSimpleDropdownWidth,
            controller: minPriceController,
            borderColor: greyColor,
            radius: unitWidth * 5,
            fontSize: pageIconSize,
            fontColor: darkColor,
            hint: '0',
            hintColor: darkColor,
            hintSize: pageIconSize,
            label: '',
            labelColor: greyColor,
            labelSize: pageTextSize,
            prefixIcon: dropdownIcon,
            prefixIconSize: pageIconSize,
            prefixIconColor: darkColor,
            readOnly: true,
            onTap: () => _onTappedPriceInputField(),
            height: unitWidth * 15,
          ),
          Text(
            'filter.lbl_to'.tr(),
            style: TextStyle(
              color: darkColor,
              fontSize: pageIconSize,
            ),
          ),
          InputFieldPrefix(
            width: filterSimpleDropdownWidth,
            controller: maxPriceController,
            borderColor: greyColor,
            radius: unitWidth * 5,
            fontSize: pageIconSize,
            fontColor: darkColor,
            hint: 'filter.lbl_any'.tr(),
            hintColor: darkColor,
            hintSize: pageIconSize,
            label: '',
            labelColor: greyColor,
            labelSize: pageTextSize,
            prefixIcon: dropdownIcon,
            prefixIconSize: pageIconSize,
            prefixIconColor: darkColor,
            readOnly: true,
            onTap: () => _onTappedPriceInputField(),
            height: unitWidth * 15,
          ),
        ],
      ),
    );
  }

  void _onTappedPriceInputField() async {
    var result = await showDialog(
      context: context,
      builder: (context) {
        return MinMaxDialog(
          width: filterMinMaxSelectDialogWidth,
          height: filterMinMaxSelectDialogHeight,
          minValue: minPriceController!.text,
          maxValue: maxPriceController!.text,
          items: filterPriceItems,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9\u0660-\u0669]'))
          ],
          padding: unitWidth * 10,
          radius: unitWidth * 10,
        );
      },
    );
    if (result != null) {
      minPriceController!.text = result[0];
      maxPriceController!.text = result[1];
    }
  }

  /*  Widget _buildFilterPropertyAreaRange() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InputFieldPrefix(
            width: filterSimpleDropdownWidth,
            controller: minPropertyAreaController,
            borderColor: greyColor,
            radius: unitWidth * 5,
            fontSize: pageIconSize,
            fontColor: darkColor,
            hint: '0',
            hintColor: darkColor,
            hintSize: pageIconSize,
            label: '',
            labelColor: greyColor,
            labelSize: pageTextSize,
            prefixIcon: dropdownIcon,
            prefixIconSize: pageIconSize,
            prefixIconColor: darkColor,
            readOnly: true,
            onTap: () => _onTappedPropertyAreaInputField(),
            height: unitWidth * 15,
          ),
          Text(
            'filter.lbl_to'.tr(),
            style: TextStyle(
              color: darkColor,
              fontSize: pageIconSize,
            ),
          ),
          InputFieldPrefix(
            width: filterSimpleDropdownWidth,
            controller: maxPropertyAreaController,
            borderColor: greyColor,
            radius: unitWidth * 5,
            fontSize: pageIconSize,
            fontColor: darkColor,
            hint: 'filter.lbl_any'.tr(),
            hintColor: darkColor,
            hintSize: pageIconSize,
            label: '',
            labelColor: greyColor,
            labelSize: pageTextSize,
            prefixIcon: dropdownIcon,
            prefixIconSize: pageIconSize,
            prefixIconColor: darkColor,
            readOnly: true,
            onTap: () => _onTappedPropertyAreaInputField(),
            height: unitWidth * 15,
          ),
        ],
      ),
    );
  } */

/*   void _onTappedPropertyAreaInputField() async {
    var result = await showDialog(
      context: context,
      builder: (context) {
        return MinMaxDialog(
          width: filterMinMaxSelectDialogWidth,
          height: filterMinMaxSelectDialogHeight,
          minValue: minPropertyAreaController!.text,
          maxValue: maxPropertyAreaController!.text,
          items: filterPropertyAreaItems,
          inputFormatters: [
            FilteringTextInputFormatter.allow( RegExp('[0-9\u0660-\u0669]'))
          ],
          padding: unitWidth * 10,
          radius: unitWidth * 10,
        );
      },
    );
    if (result != null) {
      minPropertyAreaController!.text = result[0];
      maxPropertyAreaController!.text = result[1];
    }
  } */

  Widget _buildBedroomChoice() {
    return Container(
      width: deviceWidth - pageHPadding * 2,
      height: filterRentFrequencyTapWidth / 1.9,
      alignment: Alignment.center,
      child: RadioSelectButton(
        items: filterRoomItems,
        value: filterBedroom,
        itemWidth: filterRentFrequencyTapWidth / 1.9,
        itemHeight: filterRoomsOptionSize,
        itemSpace: unitWidth * 6,
        titleSize: pageIconSize,
        radius: unitWidth * 30,
        selectedColor: primaryDark,
        unSelectedColor: lightColor,
        selectedBorderColor: primaryDark,
        unSelectedBorderColor: greyColor.withOpacity(0.3),
        selectedTitleColor: lightColor,
        unSelectedTitleColor: darkColor,
        listStyle: true,
        translateFlag: false,
        onTap: (value, index) {
          if (value == filterBedroom) {
            filterBedroom = '';
          } else {
            filterBedroom = value;
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _buildAmenitiesChoices() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: DropdownAmenities(
        width: deviceWidth - pageHPadding * 2,
        height: unitWidth * 50,
        radius: unitWidth * 5,
        hPadding: unitWidth * 10,
        label: 'filter.lbl_amenities'.tr(),
        hint: 'filter.lbl_select_amenities'.tr(),
        prefixIcon: amenitiesIcon,
        value: amenitiesValue,
        labelColor: darkColor,
        hintColor: greyColor,
        prefixIconColor: darkColor,
        suffixIconColor: darkColor,
        fontColor: darkColor,
        borderColor: greyColor,
        fontSize: pageIconSize,
        iconSize: pageIconSize,
        stateValue: 1,
        onTap: () => _onTappedAmenitiesDropdown(),
      ),
    );
  }

  void _onTappedAmenitiesDropdown() async {
    var result = await showDialog(
      context: context,
      builder: (context) {
        return AmenitiesDialog(
          width: filterSingleSelectDialogWidth,
          height: filterSingleSelectDialogHeight,
          radius: unitWidth * 5,
          title: 'filter.lbl_amenities'.tr(),
          items: filterAmenityItems,
          values: amenities,
          valuesName: amenitiesNameList,
        );
      },
    );
    if (result != null) {
      setState(() {
        amenitiesValue = '';

        amenitiesSelectedIds = '';
        result[0].forEach((amenity) {
          // amenitiesSelectedIds += '$amenity' + '_';

          amenitiesSelectedIds += '$amenity' + '_';
        });

        amenitiesNameList = result[1];
        result[1].forEach((amenity) {
          var title = "DATABASE_VAR.$amenity".tr();
          amenitiesValue += '$title, ';
        });
      });
    }
  }

  Widget _buildBathroomChoice() {
    return Container(
      width: deviceWidth - pageHPadding * 2,
      height: filterRentFrequencyTapWidth / 1.9,
      alignment: Alignment.center,
      child: RadioSelectButton(
        items: filterRoomItems,
        value: filterBathroom,
        itemWidth: filterRentFrequencyTapWidth / 1.9,
        itemHeight: filterRoomsOptionSize,
        itemSpace: unitWidth * 6,
        titleSize: pageIconSize,
        radius: unitWidth * 30,
        selectedColor: primaryDark,
        unSelectedColor: lightColor,
        selectedBorderColor: primaryDark,
        unSelectedBorderColor: greyColor.withOpacity(0.3),
        selectedTitleColor: lightColor,
        unSelectedTitleColor: darkColor,
        listStyle: true,
        translateFlag: false,
        onTap: (value, index) {
          if (value == filterBathroom) {
            filterBathroom = '';
          } else {
            filterBathroom = value;
          }
          setState(() {});
        },
      ),
    );
  }

  /* Widget _buildCompletionStatus() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: DropdownCustom(
        width: deviceWidth - pageHPadding * 2,
        height: unitWidth * 50,
        radius: unitWidth * 5,
        hPadding: unitWidth * 10,
        label: 'addproperty.lbl_property_status'.tr(),
        hint: '',
        prefixIcon: completionStatusIcon,
        value: '$completionStatusValue'.tr(),
        stateValue: this.completionStatus,
        labelColor: darkColor,
        hintColor: greyColor,
        prefixIconColor: darkColor,
        suffixIconColor: darkColor,
        fontColor: darkColor,
        borderColor: darkColor,
        fontSize: pageTextSize,
        iconSize: pageSmallIconSize,
        onTap: () => _onTappedCompletionStatus(),
      ),
    );
  }

  void _onTappedCompletionStatus() async {
    var result = await showDialog(
      context: context,
      builder: (context) {
        return CompletionStatusDialog(
          width: filterSingleSelectDialogWidth,
          height: unitWidth * 303,
          value: this.completionStatusValue,
          stateValue: this.completionStatus,
          radius: unitWidth * 5,
        );
      },
    );
    if (result != null) {
      setState(() {
        this.completionStatus = result[0];
        this.completionStatusValue = result[1];
      });
    }
  } */

  Widget _buildYearBuilt() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: DropdownCustom(
        width: deviceWidth - pageHPadding * 2,
        height: unitWidth * 50,
        radius: unitWidth * 5,
        hPadding: unitWidth * 10,
        label: 'filter.lbl_year_build'.tr(),
        hint: 'filter.lbl_year_build'.tr(),
        prefixIcon: yearBuiltIcon,
        value: yearBuiltValue,
        labelColor: darkColor,
        hintColor: greyColor,
        prefixIconColor: darkColor,
        suffixIconColor: darkColor,
        fontColor: darkColor,
        borderColor: darkColor,
        fontSize: pageIconSize,
        iconSize: pageIconSize,
        onTap: () => _onTappedYearBuilt(),
        stateValue: 1,
      ),
    );
  }

  void _onTappedYearBuilt() async {
    var result = await showDialog(
      context: context,
      builder: (context) {
        return SelectBoxDialog(
          width: unitWidth * 70,
          title: 'filter.lbl_year_build'.tr(),
          value: yearBuiltValue,
          radius: unitWidth * 5,
          items: filterYearItems,
          isValueNumber: true,
        );
      },
    );
    if (result != null) {
      setState(() {
        yearBuiltValue = result;
      });
    }
  }

  // To Be Removed :
  getAlgolia() async {
    Object jsonData = {'token': ''};
    params = await app_instance.storage.read(key: 'get_algolia');
    if (params == null) {
      final result = await app_instance.userRepository.getAlgolia(jsonData);

      await app_instance.storage
          .write(key: 'get_algolia', value: jsonEncode(result));
      params = result;
      isData = false;
    } else {
      params = jsonDecode(params);
      isData = false;
    }
    setState(() {});
    await FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'filter.lbl_filter'.tr());
  }

  getAlgoliaKey() async {
    final cacheKey = await app_instance.storage.read(key: 'algolia_cache_key');
    Object jsonData = {'cache_key': cacheKey.toString()};
    final result = await app_instance.userRepository.getAlgoliaKey(jsonData);
    if (result['status'] == false) {
      await app_instance.storage.write(
          key: 'algolia_cache_key', value: result['cache_key'].toString());
      await app_instance.storage.write(key: "resetSearch", value: '1');
    }
  }
}
