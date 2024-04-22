import 'dart:convert';
import 'dart:io';
import 'package:anytimeworkout/main.dart';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/module/chat/bloc/chat/chat_bloc.dart';
import 'package:anytimeworkout/module/chat/model/chat_model.dart';
import 'package:anytimeworkout/views/components/forms/dropdown_amenities.dart';
import 'package:anytimeworkout/views/components/static_drop_down.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mime/mime.dart';
import 'package:minio/minio.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../bloc/my_properties/add/add_form_bloc.dart';
import '../../../views/components/check_internet.dart';
import '../../../views/components/forms/custom_text_button.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../config/app_colors.dart';
import '../../../views/components/forms/confirmation_dialog.dart';
import '../../../views/components/forms/select_box_dialog.dart';
import '../../../views/components/forms/round_icon_button.dart';
import '../../components/forms/text_label.dart';
import '../../../config/data.dart';
import '../../../config/icons.dart';
import '../../../config/styles.dart';
import '../../../views/components/forms/amenities_dialog.dart';
import '../../../views/components/forms/completion_status_dialog.dart';
import '../../../views/components/forms/property_area_unit_dialog.dart';
import '../../../views/components/forms/select_box_string_dialog.dart';
import '../../../views/components/forms/dropdown_custom.dart';
import '../../../views/components/forms/input_field.dart';
import '../../../views/components/forms/input_field_prefix.dart';
import '../../../views/components/forms/subtype_type_button.dart';
import '../../../views/components/forms/text_icon.dart';
import '../../../repository/property_type_repository.dart';
import '../../../views/components/check_login.dart';
import '../../../views/components/forms/text_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import '../../../views/components/center_loader.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../views/components/forms/buyrent_type_button.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../views/screens/my_properties/my_properties_screen.dart';
import 'package:minio/io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:in_app_review/in_app_review.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

final kGoogleApiKey = dotenv.env['KGOOGLEAPIKEY'];
final _s3Url = dotenv.env['S3URL'];
final _s3AccessKey = dotenv.env['S3ACCESSKEY'];
final _s3SecretKey = dotenv.env['S3SECRETKEY'];
final _region = dotenv.env['S3REGION'];
final _s3BucketUrl = dotenv.env['S3UPURL'];
final _s3Bucket = dotenv.env['S3BUCKET'];

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

enum Availability { loading, available, unavailable }

class AddScreen extends StatefulWidget {
  final String? editId, buyrentType;
  final Function()? function;
  final String? privateProperty;
  final String? channelName;
  AddScreen(
      {Key? key,
      this.editId = '',
      this.buyrentType = '',
      this.function,
      this.privateProperty,
      this.channelName = ''})
      : super(key: key);

  @override
  _AddScreenState createState() =>
      _AddScreenState(editId: editId!, buyrentType: buyrentType!);
}

class _AddScreenState extends State<AddScreen> {
  _AddScreenState({required this.editId, required this.buyrentType});
  AddFormBloc? _addFormBloc;
  bool? active = false;
  bool? adminApproved = false;
  List? amenities = [];
  bool? amenitiesChk = false;
  List? amenitiesNameList = [];
  String amenitiesSelectedIds = '';
  String amenitiesValue = '';
  List? amenityArr;
  String? areaUnit;
  String bathValue = '';
  String bedroomValue = '';
  String? buyrentType;
  List? checkAvailability = [];
  String citySearchTextFieldError = '';
  int? completionStatus;
  String completionStatusFieldError = '';
  String completionStatusValue = ''; //'addproperty.lbl_ready_to_move_in';
  List? defaultRec = [];
  String editAr = '';
  String editEn = '';
  String? editId;
  bool editPropertyFlag = false;
  bool enableSubmit = true;
  List? filterAmenityItems = [];
  List? floorPslanEditImages = [];
  String googleautosearchaddress = "";
  String googleAutosearchAddressEdit = "";
  bool isGalleryOpen = false;
  var imageFile;
  String locationAddress = "";
  String locationCity = "";
  TextEditingController locationController = TextEditingController();
  String locationCountry = "";
  String locationLatitude = "";
  String locationLongitude = "";
  String locationState = "";
  String locationZipCode = "";
  String propertyAreaFieldError = '';
  TextEditingController propertyAreaSizeController = TextEditingController();

  String propertyBathroomFieldError = '';
  String propertyBedroomFieldError = '';
  TextEditingController propertyDescController = TextEditingController();
  String propertyDescriptionFieldError = '';
  List propertyEditImages = [];
  List floorPlanEditImages = [];
  List<dynamic> propertyImages = [];
  TextEditingController propertyPriceController = TextEditingController();
  String propertyPriceFieldError = '';
  int propertyRentFrequency = 0;
  String propertyRentFrequencyValue = addRentFrequencyItems[0];
  TextEditingController propertyTitleController = TextEditingController();
  String propertyTitleFieldError = '';
  String propertyType = 'residential';
  String propertyTypeId = '0';
  String propertyTypeIdFieldError = '';
  String propertyYearsFieldError = '';
  String status = '0';
  final subTypeButtonStateKey = GlobalKey<SubTypeButtonState>();
  List subtypeItemsList = [];
  String yearBuiltValue = '';
  String? formObject = '0';
  int publishButtonCount = 0;

  ScrollController _scroll = ScrollController();

  String _address = "";

  FocusNode titleNode = FocusNode();
  FocusNode descNode = FocusNode();
  FocusNode priceNode = FocusNode();
  FocusNode areaNode = FocusNode();
  String fileName = '';
  String propertyTitleField = '';
  String propertyDescriptionField = '';
  Availability _availability = Availability.loading;
  final InAppReview inAppReview = InAppReview.instance;

  void initState() {
    super.initState();
    _addFormBloc = BlocProvider.of<AddFormBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (editId.toString().length > 0) {
        editPropertyFlag = true;
        CheckLogin().test(context);
        _editData();
      } else {
        _getPropertyType();
        if (buyrentType == 'Rent') completionStatus = 1;
        propertyTitleController.addListener(_chkpropertyTitle);
        propertyDescController.addListener(_chkpropertyDescription);
        propertyPriceController.addListener(_chkpropertyPrice);
        propertyAreaSizeController.addListener(_chkpropertyArea);
      }
    });
    if (areaUnit == null) {
      areaUnit = 'Sq. Ft.';
    }
    logScreenEvent();
  }

  logScreenEvent() async {
    await FirebaseAnalytics.instance.setCurrentScreen(
      screenName: (editPropertyFlag == true)
          ? 'addproperty.lbl_editproperty'.tr()
          : (buyrentType == 'Sell')
              ? '${'addproperty.lbl_addproperty'.tr()} ${'filter.lbl_for_sale'.tr()}'
              : '${'addproperty.lbl_addproperty'.tr()} ${'filter.lbl_for_rent'.tr()}',
    );
  }

  _editData() async {
    try {
      UserModel currentUser = await app_instance.utility.jwtUser();
      dynamic token = currentUser.token.toString();
      Object jsonData = {
        'id': 'm-' + editId!,
        'token': token.toString(),
      };

      final response =
          await app_instance.propertyRepository.appEditProperties(jsonData);

      setState(() {
        buyrentType = response['buyrent_type'] ?? '';
        propertyType = response['property_type'] ?? '';
        propertyTypeId = response['property_type_id'].toString();
        completionStatus = response['property_type_option'];
        completionStatusValue = (response['property_type_option'] == 1)
            ? 'addproperty.lbl_ready_to_move_in'
            : 'addproperty.lbl_under_construnction';
        if (response['property_type_option'] == -1) completionStatusValue = '';
        yearBuiltValue = response['propertyYear'].toString();
        locationAddress = (response['locationAddress'].toString() != 'null')
            ? response['locationAddress'].toString()
            : '';
        locationCity =
            (response['city'].toString() != 'null') ? response['city'] : '';

        locationState =
            (response['state'].toString() != 'null') ? response['state'] : '';
        googleautosearchaddress =
            (response['google_autosearch_address'].toString() != 'null')
                ? response['google_autosearch_address']
                : '';
        _address = (response['google_autosearch_address'].toString() != 'null')
            ? response['google_autosearch_address']
            : '';

        googleAutosearchAddressEdit =
            (response['google_autosearch_address'].toString() != 'null')
                ? response['google_autosearch_address']
                : '';

        if (context.locale.toString() == 'en_US') {
          propertyTitleController.text = response['propertyTitle'] ?? '';
          propertyDescController.text = response['propertyDesription'] ?? '';
        } else {
          propertyTitleController.text = response['propertyTitleAr'] ?? '';
          propertyDescController.text = response['propertyDesriptionAr'] ?? '';
        }

        if (response['propertyTitle'].toString().length > 0) editEn = 'Yes';
        if (response['propertyTitleAr'].toString().length > 0) editAr = 'Yes';

        propertyPriceController.text = response['propertyPrice'].toString();
        propertyAreaSizeController.text = response['propertyArea'].toString();
        areaUnit = response['propertyAreaIn'].toString();

        bedroomValue = (response['propertyBedrooms'] == null)
            ? ''
            : response['propertyBedrooms'].toString();
        bathValue = (response['propertyBathrooms'] == null)
            ? ''
            : response['propertyBathrooms'].toString();
        amenityArr = response['amenityArr'] ?? [];

        propertyRentFrequency = (response['propertyRentFrequency'] != null)
            ? int.parse(response['propertyRentFrequency'])
            : 0;
        propertyRentFrequencyValue =
            addRentFrequencyItems[propertyRentFrequency];

        if (response['admin_approved'] == 1) {
          adminApproved = true;
        }

        amenityArr!.forEach((amenity) {
          amenitiesSelectedIds += '$amenity' + '_';
        });

        //locationCountry = response['country'];
        // locationZipCode = (response['zip_code'] != '')?response['zip_code'] :'';
        // locationLatitude = response['latitude'];
        // locationLongitude = response['longitude'];
        active = (response['status'] == 1) ? true : false;
        status = active! ? '1' : '0';
      });
      await _getPropertyType();
      propertyTitleController.addListener(_chkpropertyTitle);
      propertyDescController.addListener(_chkpropertyDescription);
      propertyPriceController.addListener(_chkpropertyPrice);
      propertyAreaSizeController.addListener(_chkpropertyArea);
      setPropertyTypeId(response['get_property_type']);
      if (amenityArr!.length > 0) {
        amenitiesValue = '';
        List<int> myList = <int>[];
        amenityArr!.forEach((at) {
          myList.add(int.parse(at));
        });
        filterAmenityItems![0].forEach((amt) {
          int nu = amt['id'];
          if (myList.contains(nu)) {
            dynamic nm = amt['name'];
            amenitiesNameList!.add(nm);
            var title = "DATABASE_VAR.$nm".tr();
            amenitiesValue += '$title, ';
          }
        });
        amenities = json.decode(json.encode(amenityArr));
      }

      //Images
      propertyEditImages = response['get_prop_images'];
      floorPlanEditImages = response['get_floor_images'];
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> _getPropertyType() async {
    String? getpropertyAreaUnit =
        await app_instance.storage.read(key: 'propertyAreaUnit');
    String rec = await app_instance.propertyTypeRepository.getPropertyType();
    if (rec != null) {
      dynamic proType = jsonDecode(rec);
      setState(() {
        subtypeItemsList.add(proType['residential']);
        subtypeItemsList.add(proType['commercial']);
        filterAmenityItems!.add(proType['amenities']);
        defaultRec = List.from(proType['check_availability']);
        checkAvailability = json.decode(json.encode(defaultRec));
        if (getpropertyAreaUnit != null) {
          areaUnit = getpropertyAreaUnit;
        }
      });
    }
  }

  setBuyrentType(selVal) {
    setState(() {
      buyrentType = selVal;
      if (selVal == 'Rent' && checkAvailability![2]['status']) {
        completionStatus = 1;
      } else {
        completionStatus = 0;
        completionStatusValue = '';
      }
    });
  }

  setPropertyType(selVal) {
    subTypeButtonStateKey.currentState!.updateState(selVal);
    propertyTypeId = '0';
    setState(() {
      propertyType = selVal;
      checkAvailability = json.decode(json.encode(defaultRec));
    });
  }

  setPropertyTypeId(dynamic item) {
    checkAvailability!.asMap().entries.map((entry) {
      int idx = entry.key;
      if (item != null && item.isNotEmpty) {
        if (item["availability"] != null) {
          checkAvailability![idx]['status'] = (item['availability']
                  .toString()
                  .split(",")
                  .contains(entry.value['id'].toString()))
              ? true
              : false;
        }

        checkAvailability![idx]['req'] = (item['required_availability']
                .toString()
                .split(",")
                .contains(entry.value['id'].toString()))
            ? true
            : false;
      }
    }).toList();
    amenitiesChk = (item != null && item.isNotEmpty)
        ? (item['amenities'] == 'yes')
            ? true
            : false
        : false;
    if (buyrentType == 'Rent' && checkAvailability![2]['status']) {
      completionStatus = 1;
    } else if (!checkAvailability![2]['status'] &&
        !checkAvailability![4]['status']) {
      completionStatus = 0;
      completionStatusValue = '';
    }

    setState(() {
      propertyTypeId =
          (item != null && item.isNotEmpty) ? item['id'].toString() : '';
      propertyTypeIdFieldError = '';
    });
  }

  _locationList(Prediction p) async {
    var address = p.description;
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(p.placeId!);
    double lat = detail.result.geometry!.location.lat;
    double lng = detail.result.geometry!.location.lng;
    locationAddress = ((detail.result.formattedAddress.toString() != 'null')
        ? detail.result.formattedAddress
        : '')!;
    List<Placemark> newPlace = await placemarkFromCoordinates(lat, lng);
    Placemark placeMark = newPlace[0];
    locationCity = ((placeMark.administrativeArea.toString() != 'null')
        ? placeMark.administrativeArea
        : '')!;
    locationState = ((placeMark.subLocality.toString() != 'null')
        ? placeMark.subLocality
        : '')!;
    if (locationState == '')
      locationState = ((placeMark.locality.toString() != 'null')
          ? placeMark.locality
          : '')!;
    locationCountry = ((placeMark.isoCountryCode.toString() != 'null')
        ? placeMark.isoCountryCode
        : '')!;
    googleautosearchaddress = ((address.toString() != 'null') ? address : '')!;
    locationZipCode = ((placeMark.postalCode.toString() != 'null')
        ? placeMark.postalCode
        : '')!;
    locationLatitude = (lat.toString() != 'null') ? lat.toString() : '';
    locationLongitude = (lng.toString() != 'null') ? lng.toString() : '';
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      var address = p.description;

      setState(() {
        _address = address!;
        citySearchTextFieldError = '';
      });
      _locationList(p);
    }
  }

  _submitForm(BuildContext context, amenityArr) {
    _addFormBloc!.localeLangField.updateValue(context.locale.toString());
    _addFormBloc!.buyrentTypeField.updateValue(buyrentType!.trim());
    // _addFormBloc!.propertyTypeField.updateValue(this.propertyType);
    _addFormBloc!.propertyTypeIdField.updateValue(propertyTypeId.trim());
    String priceTypeField = propertyRentFrequency.toString();
    _addFormBloc!.priceTypeField.updateValue('$priceTypeField'.trim());
    String completionStatusField =
        (completionStatus == null) ? '' : completionStatus.toString();
    _addFormBloc!.completionStatusField
        .updateValue('$completionStatusField'.trim());
    _addFormBloc!.propertyYearsField.updateValue(yearBuiltValue.trim());
    String citySearchTextField = locationController.text;
    _addFormBloc!.citySearchTextField.updateValue(citySearchTextField.trim());

    propertyTitleField = propertyTitleController.text;
    _addFormBloc!.propertyTitleField.updateValue(propertyTitleField.trim());

    propertyDescriptionField = propertyDescController.text;
    _addFormBloc!.propertyDescriptionField
        .updateValue(propertyDescriptionField.trim());

    String propertyPriceField = propertyPriceController.text;
    _addFormBloc!.propertyPriceField.updateValue(propertyPriceField.trim());

    String propertyAreaField = propertyAreaSizeController.text;
    _addFormBloc!.propertyAreaField.updateValue(propertyAreaField.trim());

    _addFormBloc!.areaUnitField.updateValue(areaUnit!.trim());

    if (checkAvailability![6]['status']) {
      _addFormBloc!.propertBedroomField.updateValue(bedroomValue.trim());
    } else {
      _addFormBloc!.propertBedroomField.updateValue('');
    }

    if (checkAvailability![3]['status']) {
      _addFormBloc!.propertyBathroomField.updateValue(bathValue.trim());
    } else {
      _addFormBloc!.propertyBathroomField.updateValue('');
    }

    _addFormBloc!.propertyAmenitiesField
        .updateValue(amenitiesSelectedIds.trim());

    _addFormBloc!.addressField.updateValue(locationAddress.trim());
    _addFormBloc!.cityField.updateValue(locationCity.trim());
    _addFormBloc!.stateField.updateValue(locationState.trim());
    _addFormBloc!.countryField.updateValue(locationCountry.trim());
    _addFormBloc!.googleAutosearchAddressField
        .updateValue(googleautosearchaddress.trim());
    _addFormBloc!.zipCodeField.updateValue(locationZipCode.trim());
    _addFormBloc!.lalatitudeField.updateValue(locationLatitude.trim());
    _addFormBloc!.longitudeField.updateValue(locationLongitude.trim());

    if (propertyImages.length > 0) {
      _addFormBloc!.imagePresentField.updateValue('yes');
    } else {
      _addFormBloc!.imagePresentField.updateValue('no');
    }

    String propID = '';
    if (editPropertyFlag == true) propID = editId.toString();
    _addFormBloc!.propIDField.updateValue(propID);

    String adminApprovedStatus = '0';
    if (adminApproved!) adminApprovedStatus = '1';

    _addFormBloc!.adminApprovedField.updateValue(adminApprovedStatus);

    _addFormBloc!.editEnField.updateValue(editEn);
    _addFormBloc!.editArField.updateValue(editAr);

    _addFormBloc!.googleAutosearchAddressEditField
        .updateValue(googleAutosearchAddressEdit);

    status = (active!) ? '1' : '0';
    _addFormBloc!.statusField.updateValue(status);
    _addFormBloc!.privateProperty.updateValue(widget.privateProperty!);
    _addFormBloc!.selectedCity.updateValue(formObject.toString());
    _addFormBloc!.submit();
  }

  _uploadImage(
      BuildContext context, String insertId, String? privateProperty) async {
    if (buyrentType == 'Rent') {
      await app_instance.storage.write(key: "buyRentType", value: '1');
    } else {
      await app_instance.storage.write(key: "buyRentType", value: '0');
    }

    if (propertyImages.length > 0) {
      if (widget.privateProperty == "1") {
        await _uploadImageTrac(context, insertId);
      } else {
        _uploadImageTrac(context, insertId);
      }
    }
    if (widget.privateProperty == "1") {
      String? propertyID = await app_instance.storage.read(key: "propertyId");
      String? purpose = await app_instance.storage.read(key: 'PropertyPurpose');
      await getPropertyDetails(propertyID, context, purpose);
    }

    await app_instance.storage.write(key: "myPropUpdated", value: 'true');

    setState(() {
      enableSubmit = false;
    });
    CenterLoader.hide(context);
    _addFormBloc!.clear();
    Fluttertoast.showToast(
        backgroundColor: primaryDark,
        msg: 'addproperty.lbl_property_submit_successfully'.tr(),
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
        textColor: lightColor);

    if (editPropertyFlag == false) {
      if (privateProperty == "1") {
        final chatState = context.read<ChatBloc>().state;
        context.read<ChatBloc>().add(const ChatMessageUpdated(""));
        context.read<ChatBloc>().add(
            ChatMessageSent(selectedPropertyList[0], chatState.currentChannel));

        Navigator.of(context).popUntil(ModalRoute.withName('/chatScreen'));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyPropertiesScreen(),
                // builder: (context) => context.read<SaleBloc>()..add(SaleFetched());,
                settings: const RouteSettings(name: 'my_properties')));
      }
      selectedPropertyList.clear();
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyPropertiesScreen(),
              settings: const RouteSettings(name: 'my_properties')));
    }
  }

  _uploadImageTrac(BuildContext context, String insertId) async {
    if (propertyImages.length > 0) {
      String orderId = '0';
      if (propertyImages.length > 0) {
        await uploadPropertyImages(insertId, orderId);
      }

      await _addFormBloc!.isdirectDeploy(insertId);

      streamController.add(2);
      await app_instance.storage.delete(key: 'imgUpload');
    }
  }

  uploadPropertyImages(String insertId, String orderId) async {
    try {
      final minio = Minio(
          endPoint: _s3BucketUrl!,
          accessKey: _s3AccessKey!,
          secretKey: _s3SecretKey!,
          region: _region);
      final d = await getTemporaryDirectory();
      for (dynamic i in propertyImages) {
        //dynamic byteData = File(i.path).readAsBytesSync();
        /* dynamic byteData = await i.file
          ..readAsBytesSync();
        final imageData = await FlutterImageCompress.compressWithList(
            byteData.buffer.asUint8List());

        var random = new Random();
        var fileNameTemp = 'Img' + random.nextInt(1000).toString() + '.jpg';

        MultipartFile multipartFile = MultipartFile.fromBytes(
          imageData,
          filename: fileNameTemp, //i.name,
          //  contentType: MediaType("image", "jpg"),
        );

        orderId = (int.parse(orderId) + 1).toStringAsFixed(0);
        var formData = FormData();
        formData.files.add(MapEntry("property_files", multipartFile));
        formData.fields.add(MapEntry("insert_id", insertId));
        formData.fields.add(MapEntry("order_id", orderId));

        Dio dio = new Dio();

        final uriPathProp =
            Uri.https(_host, '$_contextRoot' + 'add_property_images')
                .toString();
        (number == 0)
            ? await dio.post(uriPathProp, data: formData)
            : dio.post(uriPathProp, data: formData);
        number++; */

        fileName = '$insertId' +
            '_' +
            '$orderId' +
            '_' +
            '${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}' +
            '.webp';

        try {
          dynamic data;
          if (Platform.isAndroid) {
            data = await i;
          } else {
            data = await i.file;
          }

          final imageData = await FlutterImageCompress.compressAndGetFile(
              data!.path, '${d.path}/file2.webp',
              minHeight: 4000,
              minWidth: 3000,
              quality: 100,
              format: CompressFormat.webp);
          final contentTypeThumb = lookupMimeType(imageData!.path);
          final imagePath = imageData.path;
          await minio.fPutObject(
              _s3Bucket!,
              'assets/properties_member/$insertId/property/$fileName',
              imageData.path, {
            'content-type': '$contentTypeThumb',
            'x-amz-acl': 'public-read'
          });
          Object jsonData = {
            'isdirectS3': '1',
            'insert_id': '$insertId',
            'image_name': fileName,
            'order_id': '$orderId',
            'image_type': 'property'
          };
          await app_instance.propertyRepository.addPropertyImages(jsonData);
        } on Exception catch (e) {
          print(e.toString());
        }
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  deleteImage(
      String id, String type, String propertyId, String imageName) async {
    try {
      UserModel currentUser = await app_instance.utility.jwtUser();
      dynamic token = currentUser.token.toString();
      Object jsonData = {
        'id': id,
        'property_id': propertyId,
        'image_name': imageName,
        'type': type,
        'isflutter': 'yes',
        'token': token.toString(),
      };
      await app_instance.propertyRepository.appDeletePropertyImages(jsonData);

      Object jsonadirectDeployData = {
        'type': 'step3',
        'id': id,
        'token': token.toString()
      };
      await app_instance.propertyRepository.directDeploy(jsonadirectDeployData);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  _getError(BuildContext context) async {
    var val;
    dynamic result;
    val = propertyTypeId;
    bool flag = true;

    if (checkAvailability![2]['status'] == false) {
      setState(() {
        completionStatus = null;
      });
    }

    result = await _addFormBloc!.isValidpropertyTypeIdField(val);
    if (result == null)
      result = '';
    else {
      flag = false;
      _scroll.animateTo(_scroll.position.minScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    }
    propertyTypeIdFieldError = result.toString();

    if (checkAvailability![2]['req']) {
      val = completionStatus;
      if (val == null) val = '';
      result = await _addFormBloc!
          .isValidcompletionStatusField(val.toString().trim());
      if (result == null)
        result = '';
      else {
        flag = false;
        _scroll.animateTo(_scroll.position.minScrollExtent,
            duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      }
      completionStatusFieldError = result.toString();
    }

    if (completionStatus == 1 && checkAvailability![4]['req']) {
      val = yearBuiltValue;
      result = await _addFormBloc!.isValidpropertyYearsField(val.trim());
      if (result == null)
        result = '';
      else {
        _scroll.animateTo(_scroll.position.minScrollExtent,
            duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      }
      propertyYearsFieldError = result.toString();
    }

    val = locationController.text;
    result = await _addFormBloc!.isValidpcitySearchTextField(val.trim());
    if (result == null)
      result = '';
    else {
      flag = false;
      _scroll.animateTo(_scroll.position.minScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    }
    citySearchTextFieldError = result.toString();

    val = propertyTitleController.text;
    result = await _addFormBloc!.isValidpropertyTitleField(val.trim());
    if (result == null)
      result = '';
    else {
      flag = false;
      FocusScope.of(context).requestFocus(titleNode);
    }
    propertyTitleFieldError = result.toString();

    if (checkAvailability![5]['req']) {
      val = propertyDescController.text;
      result = await _addFormBloc!.isValidpropertyDescriptionField(val.trim());
      if (result == null)
        result = '';
      else {
        flag = false;
        FocusScope.of(context).requestFocus(descNode);
      }

      propertyDescriptionFieldError = result.toString();
    }
    if (checkAvailability![0]['req']) {
      val = propertyPriceController.text;
      result = await _addFormBloc!.isValidpropertyPriceField(val.trim());
      if (result == null)
        result = '';
      else {
        flag = false;
        FocusScope.of(context).requestFocus(priceNode);
      }
      propertyPriceFieldError = result.toString();
    }

    if (checkAvailability![1]['req']) {
      val = propertyAreaSizeController.text;
      result = await _addFormBloc!.isValidpropertyAreaField(val.trim());
      if (result == null)
        result = '';
      else {
        flag = false;
        FocusScope.of(context).requestFocus(areaNode);
      }
      propertyAreaFieldError = result.toString();
    }

    if (checkAvailability![6]['req']) {
      val = bedroomValue;
      if (val == null) val = '';
      result = await _addFormBloc!.isValidpropertBedroomField(val.trim());
      if (result == null)
        result = '';
      else
        flag = false;
      propertyBedroomFieldError = result.toString();
    }

    if (checkAvailability![3]['req']) {
      val = bathValue;
      if (val == null) val = '';
      result = await _addFormBloc!.isValidpropertyBathroomField(val.trim());
      if (result == null)
        result = '';
      else
        flag = false;
      propertyBathroomFieldError = result.toString();
    }

    if (editPropertyFlag != true && formObject.toString() == '0') {
      flag = false;
    }

    if (flag) {
      _submitForm(context, amenityArr);
    } else {
      Fluttertoast.showToast(
          backgroundColor: blackColor,
          msg: 'addproperty.lbl_some_mendatoty'.tr(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5);
    }

    setState(() {});
  }

  _chkpropertyTitle() {
    var value = propertyTitleController.text.trim();
    propertyTitleFieldError = (value.isEmpty)
        ? 'addproperty.lbl_please_enter_property_title'.tr()
        : '';
    if ((value.isEmpty) || value.length == 1) setState(() {});
  }

  _chkpropertyDescription() {
    if (checkAvailability![5]['req']) {
      var value = propertyDescController.text.trim();
      propertyDescriptionFieldError = (value.isEmpty)
          ? 'addproperty.lbl_please_enter_property_description'.tr()
          : '';
      if ((value.isEmpty) || value.length == 1) setState(() {});
    }
  }

  _chkpropertyPrice() {
    var baseOffset = propertyPriceController.value.selection.baseOffset;
    var extentOffset = propertyPriceController.value.selection.extentOffset;

    if (baseOffset == extentOffset) {
      propertyPriceController.value = propertyPriceController.value.copyWith(
        text: propertyPriceController.text
            .replaceAll('\u0660', '0')
            .replaceAll('\u0661', '1')
            .replaceAll('\u0662', '2')
            .replaceAll('\u0663', '3')
            .replaceAll('\u0664', '4')
            .replaceAll('\u0665', '5')
            .replaceAll('\u0666', '6')
            .replaceAll('\u0667', '7')
            .replaceAll('\u0668', '8')
            .replaceAll('\u0669', '9'),
        selection: TextSelection(
            baseOffset: propertyPriceController.text.length,
            extentOffset: propertyPriceController.text.length),
        composing: TextRange.empty,
      );
    }

    var value = propertyPriceController.text.trim();

    if (checkAvailability![0]['req']) {
      propertyPriceFieldError =
          (value.isEmpty) ? 'addproperty.lbl_please_enter_price'.tr() : '';
      if ((value.isEmpty) || value.length == 1) setState(() {});
    }
  }

  _chkpropertyArea() {
    var baseOffset = propertyAreaSizeController.value.selection.baseOffset;
    var extentOffset = propertyAreaSizeController.value.selection.extentOffset;
    if (baseOffset == extentOffset) {
      propertyAreaSizeController.value =
          propertyAreaSizeController.value.copyWith(
        text: propertyAreaSizeController.text
            .replaceAll('\u0660', '0')
            .replaceAll('\u0661', '1')
            .replaceAll('\u0662', '2')
            .replaceAll('\u0663', '3')
            .replaceAll('\u0664', '4')
            .replaceAll('\u0665', '5')
            .replaceAll('\u0666', '6')
            .replaceAll('\u0667', '7')
            .replaceAll('\u0668', '8')
            .replaceAll('\u0669', '9'),
        selection: TextSelection(
            baseOffset: propertyAreaSizeController.text.length,
            extentOffset: propertyAreaSizeController.text.length),
        composing: TextRange.empty,
      );
    }
    var value = propertyAreaSizeController.text.trim();
    if (checkAvailability![1]['req']) {
      propertyAreaFieldError =
          (value.isEmpty) ? 'addproperty.lbl_please_enter_area_size'.tr() : '';
      if ((value.isEmpty) || value.length == 1) setState(() {});
    }
    if (value.isNotEmpty) {
      int cnt = '.'.allMatches(value).length;
      if (cnt > 1) {
        propertyAreaFieldError = 'addproperty.lbl_invalid_input'.tr();
        propertyAreaSizeController.text = value.substring(0, value.length - 1);
        setState(() {});
      }
    }
  }

  Widget _buildActiveStatusSwitchButton() {
    return Container(
      width: deviceWidth,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomTextButton(
            title: active!
                ? 'addproperty.lbl_active'.tr()
                : 'addproperty.lbl_inactive'.tr(),
            titleSize: pageTextSize,
            titleColor: lightColor,
            buttonColor: active! ? activeColor : favoriteColor,
            borderColor: lightColor.withOpacity(0),
            onPressed: () => null,
            radius: unitWidth * 4,
          ),
          _buildSpaceV(10),
          Switch(
            value: active!,
            activeColor: activeColor,
            onChanged: (value) {
              setState(() {
                active = value;
              });
            },
          )
        ],
      ),
    );
  }

  Widget _buildSpaceV(int size) {
    return SizedBox(height: unitWidth * size);
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

  Widget _buildErrorText(errorLbl) {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: TextLabel(
        title: errorLbl,
        padding: 0,
        titleColor: favoriteColor,
        titleSize: pageSubtitleSize,
        width: double.infinity,
        alignment: MainAxisAlignment.start,
      ),
    );
  }

  Widget _buildBuyrentTypeButton() {
    return Container(
      width: deviceWidth,
      alignment: Alignment.center,
      child: BuyrentTypeButton(
          items: filterTypeItems,
          stateValue: buyrentType,
          itemWidth: filterOptionTapWidth,
          itemHeight: unitWidth * 50,
          itemSpace: filterOptionTapSpace,
          titleSize: pageTextSize,
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
          items: purposeTypeItems,
          stateValue: propertyType,
          //itemWidth: filterOptionTapWidth,
          itemHeight: unitWidth * 50,
          itemSpace: filterOptionTapSpace,
          titleSize: pageTextSize,
          radius: unitWidth * 5,
          selectedColor:
              (adminApproved!) ? greyColor.withOpacity(0.3) : primaryDark,
          unSelectedColor: lightColor,
          selectedBorderColor:
              (adminApproved!) ? greyColor.withOpacity(0.3) : primaryColorDark,
          unSelectedBorderColor: greyColor.withOpacity(0.3),
          selectedTitleColor: lightColor,
          unSelectedTitleColor: darkColor,
          isVertical: false,
          clickable: (adminApproved!) ? false : true,
          notifyParent: setPropertyType),
    );
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
          titleSize: pageTextSize,
          radius: unitWidth * 5,
          selectedColor:
              (adminApproved!) ? greyColor.withOpacity(0.3) : primaryDark,
          unSelectedColor: lightColor,
          selectedBorderColor:
              (adminApproved!) ? greyColor.withOpacity(0.3) : primaryDark,
          unSelectedBorderColor: greyColor.withOpacity(0.3),
          selectedTitleColor: lightColor,
          unSelectedTitleColor: darkColor,
          isVertical: false,
          clickable: (adminApproved!) ? false : true,
          propertyType: propertyType,
          notifyParent: setPropertyTypeId),
    );
  }

  Widget _buildPropertyRentFrequencyButton() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: DropdownCustom(
        width: deviceWidth - pageHPadding * 2,
        height: unitWidth * 50,
        radius: unitWidth * 5,
        hPadding: unitWidth * 10,
        label: 'filter.lbl_rent_frequency'.tr(),
        hint: '',
        value: '$propertyRentFrequencyValue',
        stateValue: propertyRentFrequency,
        labelColor: darkColor,
        hintColor: greyColor,
        prefixIconColor: darkColor,
        suffixIconColor: darkColor,
        fontColor: darkColor,
        borderColor: greyColor,
        fontSize: pageIconSize,
        iconSize: pageSmallIconSize,
        onTap: () => _onTappedRentFrequencySelectView(),
      ),
    );
  }

  void _onTappedRentFrequencySelectView() async {
    var result = await showDialog(
      context: context,
      builder: (context) {
        return SelectBoxStringDialog(
          width: unitWidth * 70,
          height: unitWidth * 320,
          title: 'filter.lbl_rent_frequency'.tr(),
          value: propertyRentFrequencyValue,
          stateValue: propertyRentFrequency,
          radius: unitWidth * 5,
          items: addRentFrequencyItems,
        );
      },
    );
    if (result != null) {
      setState(() {
        propertyRentFrequency = result[0];
        propertyRentFrequencyValue = result[1];
      });
    }
  }

  Widget _buildCompletionStatus() {
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
          stateValue: completionStatus,
          labelColor: (adminApproved!) ? greyColor.withOpacity(0.6) : darkColor,
          hintColor: greyColor,
          prefixIconColor:
              (adminApproved!) ? greyColor.withOpacity(0.6) : darkColor,
          suffixIconColor:
              (adminApproved!) ? greyColor.withOpacity(0.6) : darkColor,
          fontColor: (adminApproved!) ? greyColor.withOpacity(0.6) : darkColor,
          borderColor: (completionStatusFieldError == '')
              ? (adminApproved!)
                  ? greyColor.withOpacity(0.6)
                  : darkColor
              : favoriteColor,
          fontSize: pageIconSize,
          iconSize: pageIconSize,
          onTap: () {
            if (!adminApproved!) _onTappedCompletionStatus();
          }),
    );
  }

  Widget _buildSelectCity() {
    return DropDownStatic(
      city: selectOneCity,
      deviceWidth: deviceWidth,
      label: '',
      showLabel: false,
      showIcon: true,
      pageHPadding: pageHPadding,
      selectedDropDownValue: formObject,
      unitWidth: unitWidth,
      onChanged: (value) {
        setState(
          () {
            formObject = value;
          },
        );
      },
    );
  }

  void _onTappedCompletionStatus() async {
    var result = await showDialog(
      context: context,
      builder: (context) {
        return CompletionStatusDialog(
          width: unitWidth * 70,
          height: unitWidth * 303,
          value: completionStatusValue,
          stateValue: completionStatus,
          radius: unitWidth * 5,
        );
      },
    );
    if (result != null) {
      setState(() {
        completionStatus = result[0];
        completionStatusValue = result[1];
        if (result[0] != null) completionStatusFieldError = '';
      });
    }
  }

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
        labelColor: (adminApproved!) ? greyColor.withOpacity(0.6) : darkColor,
        hintColor: greyColor,
        prefixIconColor:
            (adminApproved!) ? greyColor.withOpacity(0.6) : darkColor,
        suffixIconColor:
            (adminApproved!) ? greyColor.withOpacity(0.6) : darkColor,
        fontColor: (adminApproved!) ? greyColor.withOpacity(0.6) : darkColor,
        borderColor: (propertyYearsFieldError == '')
            ? (adminApproved!)
                ? greyColor.withOpacity(0.6)
                : darkColor
            : favoriteColor,
        fontSize: pageIconSize,
        iconSize: pageIconSize,
        onTap: () {
          if (!adminApproved!) _onTappedYearBuilt();
        },
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
        if (result != '') propertyYearsFieldError = '';
      });
    }
  }

  Widget _buildLocationInput() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: Center(
        child: InputFieldPrefix(
          height: unitWidth * 15,
          width: filterLocationInputWidth,
          controller: locationController..text = _address,
          readOnly: true,
          borderColor: (citySearchTextFieldError == '')
              ? (adminApproved!)
                  ? greyColor.withOpacity(0.6)
                  : darkColor
              : favoriteColor,
          radius: unitWidth * 5,
          fontSize: pageIconSize,
          fontColor: (adminApproved!) ? greyColor.withOpacity(0.6) : darkColor,
          hint: 'propertyDetails.lbl_property_location'.tr(),
          hintColor: greyColor,
          hintSize: pageIconSize,
          label: '',
          labelColor: greyColor,
          labelSize: pageTextSize,
          prefixIcon: locationIcon,
          prefixIconSize: pageIconSize,
          prefixIconColor: darkColor,
          onTap: () async {
            // show input autocomplete with selected mode
            // then get the Prediction selected

            if (!adminApproved!) {
              Prediction? p = await PlacesAutocomplete.show(
                  types: [],
                  strictbounds: false,
                  context: context,
                  apiKey: kGoogleApiKey!,
                  mode: Mode.overlay,
                  components: [Component(Component.country, "ae")]);
              displayPrediction(p!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildPropertyTitleEditView() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      // ignore: missing_required_param
      child: InputField(
        focusNode: titleNode,
        height: unitWidth * 15,
        width: double.infinity,
        controller: propertyTitleController,
        borderColor: (propertyTitleFieldError == '')
            ? (adminApproved!)
                ? greyColor.withOpacity(0.6)
                : darkColor
            : favoriteColor,
        radius: unitWidth * 5,
        fontSize: pageIconSize,
        fontColor: (adminApproved!) ? greyColor.withOpacity(0.6) : blackColor,
        hint: 'filter.lbl_property_title'.tr(),
        hintColor: darkColor.withOpacity(0.8),
        hintSize: pageIconSize,
        label: '',
        labelColor: (adminApproved!) ? greyColor.withOpacity(0.6) : darkColor,
        labelSize: pageTextSize,
        readOnly: (adminApproved!) ? true : false,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp('[#_/=@,*;:]')),
        ],
      ),
    );
  }

  Widget _buildPropertyDescEditView() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      // ignore: missing_required_param
      child: InputField(
        focusNode: descNode,
        height: unitWidth * 15,
        width: double.infinity,
        keyboardType: TextInputType.multiline,
        controller: propertyDescController,
        borderColor: (propertyDescriptionFieldError == '')
            ? (adminApproved!)
                ? greyColor.withOpacity(0.6)
                : darkColor
            : favoriteColor,
        radius: unitWidth * 5,
        fontSize: pageIconSize,
        fontColor: (adminApproved!) ? greyColor.withOpacity(0.6) : blackColor,
        hint: 'filter.lbl_property_description'.tr(),
        hintColor: darkColor.withOpacity(0.8),
        hintSize: pageIconSize,
        label: '',
        labelColor: (adminApproved!) ? greyColor.withOpacity(0.6) : darkColor,
        labelSize: pageTextSize,
        maxLines: null,
        textInputAction: TextInputAction.newline,
        readOnly: (adminApproved!) ? true : false,
      ),
    );
  }

  Widget _buildPropertyPriceEditView() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: InputFieldPrefix(
        focusNode: priceNode,
        height: unitWidth * 15,
        width: double.infinity,
        controller: propertyPriceController,
        borderColor:
            (propertyPriceFieldError == '') ? darkColor : favoriteColor,
        radius: unitWidth * 5,
        fontSize: pageIconSize,
        fontColor: blackColor,
        hint: 'addproperty.lbl_price'.tr(),
        hintColor: darkColor.withOpacity(0.8),
        hintSize: pageIconSize,
        label: '',
        labelColor: darkColor,
        labelSize: pageTextSize,
        prefixIcon: priceIcon,
        prefixIconSize: pageSmallIconSize,
        prefixIconColor: greyColor,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[\u0660-\u06690-9]'))
        ],
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        suffixText: 'currency.AED'.tr(),
      ),
    );
  }

  Widget _buildPropertyAreaSizeEditView() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: (deviceWidth - pageHPadding * 2) / 2.1,
            child: InputFieldPrefix(
              focusNode: areaNode,
              height: unitWidth * 16,
              width: double.infinity,
              controller: propertyAreaSizeController,
              borderColor:
                  (propertyAreaFieldError == '') ? darkColor : favoriteColor,
              radius: unitWidth * 5,
              fontSize: pageIconSize,
              fontColor: blackColor,
              hint: 'location.lbl_area'.tr(),
              hintColor: darkColor.withOpacity(0.8),
              hintSize: pageIconSize,
              label: '',
              labelColor: darkColor,
              labelSize: pageTextSize,
              prefixIcon: areaSizeIcon,
              prefixIconSize: pageSmallIconSize,
              prefixIconColor: greyColor,
              keyboardType: TextInputType.number,
              onChanged: (value) {
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

                propertyAreaSizeController.text = value;
                propertyAreaSizeController.selection = TextSelection.collapsed(
                    offset: propertyAreaSizeController.text.length);
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[\u0660-\u06690-9]'))
              ],
              textInputAction: TextInputAction.done,
            ),
          ),
          const Spacer(),
          DropdownCustom(
            width: (deviceWidth - pageHPadding * 2) / 2.2,
            height: unitWidth * 52,
            radius: unitWidth * 5,
            hPadding: unitWidth * 10,
            label: areaUnit == 'Sq. Ft.'
                ? 'addproperty.lbl_sqft'.tr()
                : 'addproperty.lbl_sqm'.tr(),
            hint: '',
            value: '',
            labelColor: darkColor,
            hintColor: greyColor,
            suffixIconColor: darkColor,
            fontColor: darkColor,
            borderColor: greyColor,
            fontSize: pageTextSize,
            iconSize: pageSmallIconSize,
            onTap: () {
              FocusScope.of(context).unfocus();
              _onTappedPropertyAreaUnitSelect();
            },
          ),
        ],
      ),
    );
  }

  void _onTappedPropertyAreaUnitSelect() async {
    var result = await showDialog(
      context: context,
      builder: (context) {
        return PropertyAreaUnitDialog(
          width: unitWidth * 70,
          height: unitWidth * 210,
          radius: unitWidth * 5,
          unitWidth: unitWidth,
          value: areaUnit!,
        );
      },
    );
    if (result != null) {
      setState(() {
        areaUnit = result;
      });
    }
  }

  Widget _buildRoomsSelectView() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          (checkAvailability![6]['status'])
              ? DropdownCustom(
                  width: (deviceWidth - pageHPadding * 2) / 2.1,
                  height: unitWidth * 50,
                  radius: unitWidth * 5,
                  hPadding: unitWidth * 10,
                  label: 'addproperty.lbl_bedroom'.tr(),
                  hint: '',
                  value: bedroomValue,
                  stateValue: 1,
                  labelColor: darkColor,
                  hintColor: greyColor,
                  prefixIconColor: darkColor,
                  suffixIconColor: darkColor,
                  fontColor: darkColor,
                  borderColor: (propertyBedroomFieldError == '')
                      ? darkColor
                      : favoriteColor,
                  fontSize: pageTextSize,
                  iconSize: pageSmallIconSize,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _onTappedBedroomSelectView();
                  },
                )
              : Container(
                  width: (deviceWidth - pageHPadding * 2) / 2.1,
                ),
          const Spacer(),
          (checkAvailability![3]['status'])
              ? DropdownCustom(
                  width: (deviceWidth - pageHPadding * 2) / 2.2,
                  height: unitWidth * 50,
                  radius: unitWidth * 5,
                  hPadding: unitWidth * 10,
                  label: 'addproperty.lbl_bathroom'.tr(),
                  hint: '',
                  value: bathValue,
                  stateValue: 1,
                  labelColor: darkColor,
                  hintColor: greyColor,
                  prefixIconColor: darkColor,
                  suffixIconColor: darkColor,
                  fontColor: darkColor,
                  borderColor: (propertyBathroomFieldError == '')
                      ? darkColor
                      : favoriteColor,
                  fontSize: pageTextSize,
                  iconSize: pageSmallIconSize,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _onTappedBathSelectView();
                  },
                )
              : Container(
                  width: (deviceWidth - pageHPadding * 2) / 2.2,
                ),
        ],
      ),
    );
  }

  void _onTappedBedroomSelectView() async {
    var result = await showDialog(
      context: context,
      builder: (context) {
        return SelectBoxDialog(
          width: unitWidth * 70,
          title: 'addproperty.lbl_bathroom'.tr(),
          value: bedroomValue,
          radius: unitWidth * 5,
          items: filterRoomItems,
          isValueNumber: true,
        );
      },
    );
    if (result != null) {
      setState(() {
        bedroomValue = result;
        if (bedroomValue != null) propertyBedroomFieldError = '';
      });
    }
  }

  void _onTappedBathSelectView() async {
    var result = await showDialog(
      context: context,
      builder: (context) {
        return SelectBoxDialog(
          width: unitWidth * 70,
          title: 'addproperty.lbl_bathroom'.tr(),
          value: bathValue,
          radius: unitWidth * 5,
          items: filterRoomItems,
          isValueNumber: true,
        );
      },
    );
    if (result != null) {
      setState(() {
        bathValue = result;
        if (bathValue != null) propertyBathroomFieldError = '';
      });
    }
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
        fontSize: pageTextSize,
        iconSize: pageSmallIconSize,
        stateValue: 1,
        onTap: () {
          FocusScope.of(context).unfocus();
          _onTappedAmenitiesDropdown();
        },
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
      amenitiesValue = '';

      amenitiesSelectedIds = '';
      result[0].forEach((amenity) {
        amenitiesSelectedIds += '$amenity' + '_';
      });

      amenitiesNameList = result[1];
      app_instance.storage
          .write(key: "amenitiesArray", value: amenitiesNameList.toString());
      result[1].forEach((amenity) {
        var title = "DATABASE_VAR.$amenity".tr();
        amenitiesValue += '$title, ';
      });
      setState(() {});
    }
  }

  Widget _buildPickPropertyImagesButton() {
    return ((propertyImages.length + propertyEditImages.length) > 7)
        ? const SizedBox.shrink()
        : Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: TextIconButton(
              title: 'addproperty.lbl_pick_images'.tr(),
              iconData: plusIcon,
              titleSize: pageTextSize,
              iconSize: pageIconSize,
              titleColor: primaryDark,
              iconColor: primaryDark,
              buttonColor: lightColor,
              borderColor: primaryDark,
              radius: unitWidth * 5,
              itemSpace: unitWidth * 4,
              onPressed: () {
                _onPickPropertyImage();
              },
            ),
          );
  }

  // for pick multiple property images
  void _onPickPropertyImage() async {
    List<dynamic>? selectedImages = [];
    if (Platform.isAndroid) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'HEIC'],
        allowMultiple: true,
      );

      if (result != null) {
        for (var i = 0; i < result.paths.length; i++) {
          if (i < 8) {
            selectedImages.add(File(result.paths[i]!));
          }
        }
        // selectedImages = result.paths.map((path) => File(path!)).toList();
      }
    } else {
      selectedImages = await AssetPicker.pickAssets(context,
          pickerConfig: AssetPickerConfig(
            maxAssets: 8 - propertyImages.length,
            requestType: RequestType.image,
          ));
    }
    if (selectedImages != null) {
      propertyImages.addAll(selectedImages);
      setState(() {});
    }
  }

  checkImageCount(length) {
    if (length < 9) {
      isGalleryOpen = false;
    } else {
      Fluttertoast.showToast(
          backgroundColor: blackColor,
          msg: 'Maximum 8 images are allowed!',
          toastLength: Toast.LENGTH_LONG);
      isGalleryOpen = true;
    }
    setState(() {});
  }

  Widget _buildPropertyImagesHintView() {
    return ((propertyImages.length + propertyEditImages.length) > 0)
        ? const SizedBox.shrink()
        : Container(
            width: deviceWidth,
            padding: EdgeInsets.symmetric(horizontal: pageHPadding),
            alignment: Alignment.center,
            child: Text(
              'addproperty.lbl_select_property_images',
              style: TextStyle(
                color: darkColor,
                fontSize: pageTextSize,
              ),
            ).tr(),
          );
  }

  // Edit Image Preview
  Widget _buildSEditPropertyImagesPreview() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: Wrap(
        children: propertyEditImages.map((imageAsset) {
          return Container(
            width: unitWidth * 120,
            height: unitWidth * 120,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Image.network(
                      _s3Url! +
                          '/fit-in/400x0/assets/properties_member/' +
                          imageAsset['path'],
                      width: double.parse((unitWidth * 110).toStringAsFixed(0)),
                      height:
                          double.parse((unitWidth * 110).toStringAsFixed(0)),
                      fit: BoxFit.cover),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: RoundIconButton(
                    radius: 30,
                    color: lightColor,
                    iconData: clearIcon,
                    iconSize: pageSmallIconSize,
                    iconColor: favoriteColor,
                    width: unitWidth * 22,
                    height: unitWidth * 22,
                    onTap: () async {
                      var response = await showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmationDialog(
                            width: unitWidth * 260,
                            height: unitWidth * 140,
                            pageTextSize: pageTextSize,
                            pageTitleSize: pageTitleSize,
                            unitWidth: unitWidth,
                            title: 'ANYTIME WORKOUT',
                            bodyText:
                                'addproperty.lbl_are_you_sure_remove_image'
                                    .tr(),
                          );
                        },
                      );
                      if (response != null) {
                        if (!mounted) return;
                        deleteImage(
                          imageAsset['id'].toString(),
                          imageAsset['type'].toString(),
                          imageAsset['property_id'].toString(),
                          imageAsset['image'].toString(),
                        );
                        setState(() {
                          propertyEditImages.remove(imageAsset);
                        });
                        checkImageCount(
                            propertyEditImages.length + propertyImages.length);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // Image preview when picked image
  Widget _buildPickedPropertyImagesPreview() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: Wrap(
        children: propertyImages.map((imageAsset) {
          return Container(
            width: unitWidth * 120,
            height: unitWidth * 120,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: (Platform.isAndroid)
                      ? Image.file(
                          File(imageAsset.path),
                          width: int.parse((unitWidth * 110).toStringAsFixed(0))
                              .toDouble(),
                          height:
                              int.parse((unitWidth * 110).toStringAsFixed(0))
                                  .toDouble(),
                        )
                      : Image(
                          image: AssetEntityImageProvider(imageAsset,
                              isOriginal: false),
                          width: int.parse((unitWidth * 110).toStringAsFixed(0))
                              .toDouble(),
                          height:
                              int.parse((unitWidth * 110).toStringAsFixed(0))
                                  .toDouble(),
                        ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: RoundIconButton(
                    radius: 30,
                    color: lightColor,
                    iconData: clearIcon,
                    iconSize: pageSmallIconSize,
                    iconColor: favoriteColor,
                    width: unitWidth * 22,
                    height: unitWidth * 22,
                    onTap: () async {
                      var response = await showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmationDialog(
                            width: unitWidth * 260,
                            height: unitWidth * 140,
                            pageTextSize: pageTextSize,
                            pageTitleSize: pageTitleSize,
                            unitWidth: unitWidth,
                            title: 'ANYTIME WORKOUT',
                            bodyText:
                                'addproperty.lbl_are_you_sure_remove_image'
                                    .tr(),
                          );
                        },
                      );
                      if (response != null) {
                        if (!mounted) return;
                        setState(() {
                          propertyImages.remove(imageAsset);
                        });
                        checkImageCount(
                            propertyImages.length + propertyImages.length);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /* Widget _buildPickFloorPlanImagesButton() {
    return ((floorPlanImages.length + floorPlanEditImages.length) > 3)
        ? SizedBox.shrink()
        : Container(
            width: deviceWidth,
            padding: EdgeInsets.only(
              left: pageHPadding,
              right: unitWidth * 220,
            ),
            child: TextIconButton(
              title: 'addproperty.lbl_pick_images'.tr(),
              iconData: plusIcon,
              titleSize: pageTextSize,
              iconSize: pageIconSize,
              iconColor: primaryColor,
              buttonColor: lightColor,
              borderColor: primaryColor,
              radius: unitWidth * 5,
              itemSpace: unitWidth * 4,
              onPressed: () => _onPickFloorPlanImage(),
            ),
          );
  } */

  /* void _onPickFloorPlanImage() async {
    /* var result = await showDialog(
      context: context,
      builder: (context) {
        return PickImageDialog(
          title: 'addproperty.lbl_floorplan_images'.tr(),
          pageTextSize: pageTitleSize,
          pageSmallTextSize: pageTitleSize,
          unitWidth: unitWidth,
          unitHeight: unitHeight,
          deviceHeight: deviceHeight,
        );
      },
    );
    if (result != null) { */
    List<Asset> images = List<Asset>();
    try {
      images = await MultiImagePicker.pickImages(
        maxImages: 4 - floorPlanEditImages.length,
        enableCamera: true,
        selectedAssets: floorPlanImages,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#0091EA",
          statusBarColor: "#0091EA",
          actionBarTitle: 'addproperty.lbl_floorplan_images'.tr(),
          allViewTitle: "All Photos",
          useDetailsView: true,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }
    if (!mounted) return;
    if (images.isEmpty) return;
    setState(() {
      floorPlanImages = images;
    });
    //  }
  } */

  /*  Widget _buildFloorPlanImagesHintView() {
    return ((floorPlanImages.length + floorPlanEditImages.length) > 0)
        ? SizedBox.shrink()
        : Container(
            width: deviceWidth,
            padding: EdgeInsets.symmetric(horizontal: pageHPadding),
            alignment: Alignment.center,
            child: Text(
              'addproperty.lbl_select_floorplan_images',
              style: TextStyle(
                color: darkColor,
                fontSize: pageTextSize,
              ),
            ).tr(),
          );
  } */

  /* Widget _buildPickedEditFloorPlanImagesPreview() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: Wrap(
        children: floorPlanEditImages.map((imageAsset) {
          return Container(
            width: unitWidth * 126,
            height: unitWidth * 126,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Image.network(
                      _s3Url +
                          '/fit-in/400x0/assets/properties_member/' +
                          imageAsset['path'],
                      width: double.parse(
                          (unitWidth * 110).toStringAsFixed(0)),
                      height: double.parse(
                          (unitWidth * 110).toStringAsFixed(0)),
                      fit: BoxFit.cover),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: RoundIconButton(
                    radius: 30,
                    color: lightColor,
                    iconData: clearIcon,
                    iconSize: pageSmallIconSize,
                    iconColor: favoriteColor,
                    width: unitWidth * 22,
                    height: unitWidth * 22,
                    onTap: () async {
                      var response = await showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmationDialog(
                            width: unitWidth * 260,
                            height: unitWidth * 140,
                            pageTextSize: pageTextSize,
                            pageTitleSize: pageTitleSize,
                            unitWidth: unitWidth,
                            title: 'ANYTIME WORKOUT',
                            bodyText:
                                'addproperty.lbl_are_you_sure_remove_image'
                                    .tr(),
                          );
                        },
                      );
                      if (response != null) {
                        if (!mounted) return;
                        this.deleteImage(
                            imageAsset['id'].toString(),
                            imageAsset['property_id'].toString(),
                            imageAsset['image'].toString(),
                            imageAsset['type'].toString());
                        setState(() {
                          floorPlanEditImages.remove(imageAsset);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  } 
  
    Widget _buildPickedFloorPlanImagesPreview() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: Wrap(
        children: floorPlanImages.map((imageAsset) {
          return Container(
            width: unitWidth * 126,
            height: unitWidth * 126,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: AssetThumb(
                    asset: imageAsset,
                    width:
                        int.parse((unitWidth * 110).toStringAsFixed(0)),
                    height:
                        int.parse((unitWidth * 110).toStringAsFixed(0)),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: RoundIconButton(
                    radius: 30,
                    color: lightColor,
                    iconData: clearIcon,
                    iconSize: pageSmallIconSize,
                    iconColor: favoriteColor,
                    width: unitWidth * 22,
                    height: unitWidth * 22,
                    onTap: () async {
                      var response = await showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmationDialog(
                            width: unitWidth * 260,
                            height: unitWidth * 140,
                            pageTextSize: pageTextSize,
                            pageTitleSize: pageTitleSize,
                            unitWidth: unitWidth,
                            title: 'ANYTIME WORKOUT',
                            bodyText:
                                'addproperty.lbl_are_you_sure_remove_image'
                                    .tr(),
                          );
                        },
                      );
                      if (response != null) {
                        if (!mounted) return;
                        setState(() {
                          floorPlanImages.remove(imageAsset);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  } */

  noNetWork() {
    Fluttertoast.showToast(
        backgroundColor: primaryDark,
        msg: "connection.checkConnection".tr(),
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 3);
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    if (connectionStatus == ConnectivityStatus.Offline) noNetWork();
    if (subtypeItemsList.length > 0) {
      // ignore: close_sinks

      return Scaffold(
          backgroundColor: lightColor,
          appBar: AppBar(
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: lightColor,
            elevation: 1,
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
                    onPressed: () =>
                        Navigator.pushNamed(context, '/more_drawer'),
                  )
                : null,
            iconTheme: const IconThemeData(color: blackColor),
            title: (editPropertyFlag == true)
                ? const Text('addproperty.lbl_editproperty',
                        style: TextStyle(color: blackColor))
                    .tr()
                : (buyrentType == 'Sell')
                    ? Text(
                        'addproperty.lbl_addproperty'.tr() +
                            ' ' +
                            'filter.lbl_for_sale'.tr(),
                        style: const TextStyle(color: blackColor))
                    : Text(
                        'addproperty.lbl_addproperty'.tr() +
                            ' ' +
                            'filter.lbl_for_rent'.tr(),
                        style: const TextStyle(color: blackColor)),
          ),
          body: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus!.unfocus();
              },
              child: Container(
                  child: FormBlocListener<AddFormBloc, String, String>(
                      onSubmitting: (context, state) {
                        CenterLoader.show(context);
                      },
                      onSuccess: (context, state) async {
                        dynamic successResponse =
                            jsonDecode(state.successResponse.toString());

                        await app_instance.storage
                            .write(key: 'defaultSearch', value: 'false');

                        if (successResponse.containsKey('userPropertyCount') &&
                            successResponse['userPropertyCount'] != null &&
                            (successResponse['userPropertyCount'] % 10 == 0 ||
                                successResponse['userPropertyCount'] == 1)) {
                          if (await inAppReview.isAvailable()) {
                            inAppReview.requestReview();
                          }
                        }

                        if (mounted) {
                          await _uploadImage(
                              context,
                              successResponse['insertId'].toString(),
                              widget.privateProperty);
                        }

/* 
                        selectedPropertyList.add(ChatCard(
                          cardType: "propertyDetail",
                          timeStamp: DateTime.now().toString(),
                          data: "item!.toString()",
                        )); */
                      },
                      onFailure: (context, state) {
                        CenterLoader.hide(context);
                        Fluttertoast.showToast(
                            backgroundColor: primaryDark,
                            msg: state.failureResponse!,
                            toastLength: Toast.LENGTH_LONG,
                            timeInSecForIosWeb: 5);
                      },
                      onSubmissionFailed: (context, state) async {
                        _getError(context);
                      },
                      child: SingleChildScrollView(
                        controller: _scroll,
                        physics: const ClampingScrollPhysics(),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10, left: 7, right: 7),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (editPropertyFlag)
                                _buildActiveStatusSwitchButton(),
                              if (editPropertyFlag) _buildSpaceV(20),
                              if (editPropertyFlag) _buildBuyrentTypeButton(),
                              if (editPropertyFlag) _buildSpaceV(20),
                              _buildLabelHeader(
                                  homeIcon, 'filter.lbl_property_types'.tr()),
                              _buildSpaceV(10),
                              _buildPropertyTypeButton(),
                              _buildSpaceV(20),
                              if (propertyType == 'residential')
                                _buildLabelHeader(
                                    subTypeIcon,
                                    'filter.lbl_residential'.tr() +
                                        ' ' +
                                        'filter.lbl_type'.tr()),
                              if (propertyType == 'commercial')
                                _buildLabelHeader(
                                    subTypeIcon,
                                    'filter.lbl_commercial'.tr() +
                                        ' ' +
                                        'filter.lbl_type'.tr()),
                              _buildSpaceV(10),
                              _buildSubTypeButton(),
                              if (propertyTypeIdFieldError != '')
                                _buildErrorText(propertyTypeIdFieldError),
                              if (buyrentType == 'Rent') _buildSpaceV(10),
                              if (buyrentType == 'Rent')
                                _buildPropertyRentFrequencyButton(),
                              if (buyrentType == 'Sell' &&
                                  checkAvailability![2]['status'])
                                _buildSpaceV(10),
                              if (buyrentType == 'Sell' &&
                                  checkAvailability![2]['status'])
                                _buildCompletionStatus(),
                              if (editPropertyFlag != true) ...[
                                _buildSelectCity(),
                                if (formObject.toString() == "0" &&
                                    publishButtonCount != 0)
                                  _buildErrorText(
                                      "addproperty.err_please_select_city".tr())
                              ],
                              if (completionStatus == 1) ...[
                                _buildSpaceV(10),
                              ],
                              if (checkAvailability![2]['status'] &&
                                  completionStatus != 1 &&
                                  completionStatusFieldError != '')
                                _buildErrorText(completionStatusFieldError),
                              if (completionStatus == 1 &&
                                  checkAvailability![4]['status']) ...[
                                _buildSpaceV(10),
                                _buildYearBuilt(),
                              ],
                              if (completionStatus == 1 &&
                                  checkAvailability![4]['status'] &&
                                  propertyYearsFieldError != '')
                                _buildErrorText(propertyYearsFieldError),
                              if (completionStatus == 1 &&
                                  checkAvailability![4]['status'])
                                _buildSpaceV(10),
                              _buildLocationInput(),
                              if (citySearchTextFieldError != '')
                                _buildErrorText(citySearchTextFieldError),
                              _buildSpaceV(20),
                              _buildLabelHeader(chartIcon,
                                  'filter.lbl_property_details'.tr()),
                              _buildSpaceV(10),
                              _buildPropertyTitleEditView(),
                              if (propertyTitleFieldError != '')
                                _buildErrorText(propertyTitleFieldError),
                              _buildSpaceV(20),
                              if (checkAvailability![5]['status'])
                                _buildPropertyDescEditView(),
                              if (checkAvailability![5]['status'] &&
                                  propertyDescriptionFieldError != '')
                                _buildErrorText(propertyDescriptionFieldError),
                              if (checkAvailability![0]['status'])
                                _buildPropertyPriceEditView(),
                              if (checkAvailability![0]['status'] &&
                                  propertyPriceFieldError != '')
                                _buildErrorText(propertyPriceFieldError),
                              if (checkAvailability![1]['status'])
                                _buildPropertyAreaSizeEditView(),
                              if (checkAvailability![1]['status'] &&
                                  propertyAreaFieldError != '')
                                _buildErrorText(propertyAreaFieldError),
                              _buildSpaceV(10),
                              _buildRoomsSelectView(),
                              Container(
                                width: deviceWidth,
                                padding: EdgeInsets.symmetric(
                                    horizontal: pageHPadding),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: (deviceWidth - pageHPadding * 2) /
                                          2.1,
                                      height: (checkAvailability![6]
                                                  ['status'] &&
                                              propertyBedroomFieldError != '')
                                          ? unitWidth * 35
                                          : 0.1,
                                      child: (checkAvailability![6]['status'] &&
                                              propertyBedroomFieldError != '')
                                          ? _buildErrorText(
                                              propertyBedroomFieldError)
                                          : const Text(''),
                                    ),
                                    //Spacer(),
                                    Container(
                                      width: (deviceWidth - pageHPadding * 2) /
                                          2.2,
                                      height: (checkAvailability![3]
                                                  ['status'] &&
                                              propertyBathroomFieldError != '')
                                          ? unitWidth * 35
                                          : 0.1,
                                      child: (checkAvailability![3]['status'] &&
                                              propertyBathroomFieldError != '')
                                          ? _buildErrorText(
                                              propertyBathroomFieldError)
                                          : const Text(''),
                                    ),
                                  ],
                                ),
                              ),
                              _buildSpaceV(20),
                              if (amenitiesChk!) _buildAmenitiesChoices(),
                              if (amenitiesChk!) _buildSpaceV(30),
                              _buildLabelHeader(galleryIcon,
                                  'addproperty.lbl_property_images'.tr()),
                              _buildSpaceV(10),
                              _buildPickPropertyImagesButton(),
                              _buildSpaceV(10),
                              (propertyImages.length == 0)
                                  ? _buildPropertyImagesHintView()
                                  : Container(),
                              _buildSEditPropertyImagesPreview(),
                              _buildPickedPropertyImagesPreview(),
                              _buildSpaceV(30),
                              /*  _buildLabelHeader(galleryIcon,
                                  'addproperty.lbl_floorplan_images'.tr()),
                              _buildSpaceV(10),
                              _buildPickFloorPlanImagesButton(),
                              _buildSpaceV(10),
                              _buildFloorPlanImagesHintView(),
                              _buildPickedEditFloorPlanImagesPreview(),
                              _buildPickedFloorPlanImagesPreview(),
                              _buildSpaceV(30),*/
                              /* TextFieldBlocBuilder(
                    textFieldBloc: _addFormBloc.nameField,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'contactus.lbl_contactus_name'.tr(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ), */
                            ],
                          ),
                        ),
                      )))),
          bottomNavigationBar: SafeArea(
              minimum: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: Container(
                  height: 40 * unitWidth,
                  width: deviceWidth,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor:
                            (enableSubmit) ? primaryDark : greyColor),
                    onPressed: (!isGalleryOpen)
                        ? () {
                            if (enableSubmit) {
                              publishButtonCount = publishButtonCount + 1;
                              _getError(context);
                            }
                          }
                        : null,
                    child: Text(
                      (editPropertyFlag)
                          ? 'addproperty.lbl_update'
                          : 'addproperty.lbl_publish',
                      style: TextStyle(
                        color: lightColor,
                        fontSize: pageIconSize,
                      ),
                    ).tr(),
                  ))));
    } else {
      return Scaffold(
        backgroundColor: lightColor,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: blackColor),
          elevation: 1,
          backgroundColor: lightColor,
          title: (editPropertyFlag)
              ? const Text('addproperty.lbl_editproperty',
                      style: TextStyle(color: blackColor))
                  .tr()
              : const Text('addproperty.lbl_addproperty',
                      style: TextStyle(color: blackColor))
                  .tr(),
        ),
        body: Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator()),
      );
    }
  }

  getPropertyDetails(id, BuildContext context, String? purpose) async {
    String? userKey = await app_instance.storage.read(key: 'userKey');
    UserModel currentUser = await app_instance.utility.jwtUser();
    dynamic token = currentUser.token.toString();
    Map<String, Object> searchCond = {
      'buyrent_type': purpose!,
      'user_id': userKey!,
    };

    Map<String, Object> jsonData = {
      'page': '1',
      'app_version': '1',
      'token': token.toString(),
      'search_cond': json.encode(searchCond),
    };
    final result =
        await app_instance.itemApiProvider.mypropertiesList(jsonData);

    dynamic itemModel;
    for (int i = 0; i < result.length; i++) {
      if (result[i].id.toString() == id.toString()) {
        itemModel = result[i];
      }
    }

    selectedPropertyList.add(MessageContent(
        cardType: "propertyDetail",
        timeStamp: app_instance.utility.getUnixTimeStampInPubNubPrecision(),
        data: itemModel));
  }
}
