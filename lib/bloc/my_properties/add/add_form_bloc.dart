import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:anytimeworkout/main.dart';
import 'package:anytimeworkout/model/user_model.dart';
import '../../../module/chat/model/chat_model.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

List<MessageContent> selectedPropertyList = [];

class AddFormBloc extends FormBloc<String, String> {
  final nameField = TextFieldBloc();
  final privateProperty = TextFieldBloc();
  final selectedCity = TextFieldBloc();
  final buyrentTypeField = TextFieldBloc();
  final propertyTypeField = TextFieldBloc();
  final propertyTypeIdField = TextFieldBloc();
  final priceTypeField = TextFieldBloc();
  final completionStatusField = TextFieldBloc();
  final propertyYearsField = TextFieldBloc();
  final citySearchTextField = TextFieldBloc();
  final propertyTitleField = TextFieldBloc();
  final propertyDescriptionField = TextFieldBloc();
  final propertyPriceField = TextFieldBloc();
  final propertyAreaField = TextFieldBloc();
  final areaUnitField = TextFieldBloc();
  final propertBedroomField = TextFieldBloc();
  final propertyBathroomField = TextFieldBloc();
  final propertyAmenitiesField = TextFieldBloc();
  final addressField = TextFieldBloc();
  final cityField = TextFieldBloc();
  final stateField = TextFieldBloc();
  final countryField = TextFieldBloc();
  final googleAutosearchAddressField = TextFieldBloc();
  final zipCodeField = TextFieldBloc();
  final lalatitudeField = TextFieldBloc();
  final longitudeField = TextFieldBloc();

  final localeLangField = TextFieldBloc();
  final imagePresentField = TextFieldBloc();

  final propIDField = TextFieldBloc();
  final adminApprovedField = TextFieldBloc();
  final googleAutosearchAddressEditField = TextFieldBloc();
  final editEnField = TextFieldBloc();
  final editArField = TextFieldBloc();
  final statusField = TextFieldBloc();

  AddFormBloc() {
    /*  propertyTypeIdField.addAsyncValidators([isValidpropertyTypeIdField]);
    completionStatusField.addAsyncValidators([isValidcompletionStatusField]);
    propertyYearsField.addAsyncValidators([isValidpropertyYearsField]);
   citySearchTextField.addAsyncValidators([isValidpcitySearchTextField]);

  */

    addFieldBlocs(
      fieldBlocs: [
        nameField,
        buyrentTypeField,
        propertyTypeField,
        propertyTypeIdField,
        priceTypeField,
        completionStatusField,
        propertyYearsField,
        citySearchTextField,
        propertyTitleField,
        propertyDescriptionField,
        propertyPriceField,
        propertyAreaField,
        areaUnitField,
        propertBedroomField,
        propertyBathroomField,
        propertyAmenitiesField,
        addressField,
        cityField,
        stateField,
        countryField,
        googleAutosearchAddressField,
        zipCodeField,
        lalatitudeField,
        longitudeField,
        localeLangField,
        imagePresentField,
        propIDField,
        adminApprovedField,
        editEnField,
        editArField,
        googleAutosearchAddressEditField,
        statusField
      ],
    );
  }

  Future<String?> isValidpropertyTypeIdField(String? value) async {
    return (value == '0' || value!.isEmpty)
        ? 'addproperty.lbl_please_select_property_type'.tr()
        : null;
  }

  Future<String?> isValidcompletionStatusField(String? value) async {
    return (value!.isEmpty)
        ? 'addproperty.lbl_select_property_status'.tr()
        : null;
  }

  Future<String?> isValidpropertyYearsField(String? value) async {
    return (value!.isEmpty)
        ? 'addproperty.lbl_select_property_years'.tr()
        : null;
  }

  Future<String?> isValidpcitySearchTextField(String? value) async {
    return (value!.isEmpty) ? 'addproperty.lbl_select_location'.tr() : null;
  }

  Future<String?> isValidpropertyTitleField(String? value) async {
    return (value!.isEmpty)
        ? 'addproperty.lbl_please_enter_property_title'.tr()
        : null;
  }

  Future<String?> isValidpropertyDescriptionField(String? value) async {
    return (value!.isEmpty)
        ? 'addproperty.lbl_please_enter_property_description'.tr()
        : null;
  }

  Future<String?> isValidpropertyPriceField(String? value) async {
    return (value!.isEmpty) ? 'addproperty.lbl_please_enter_price'.tr() : null;
  }

  Future<String?> isValidpropertyAreaField(String? value) async {
    return (value!.isEmpty)
        ? 'addproperty.lbl_please_enter_area_size'.tr()
        : null;
  }

  Future<String?> isValidpropertBedroomField(String? value) async {
    return (value == '0' || value!.isEmpty)
        ? 'addproperty.lbl_please_select_bedroom'.tr()
        : null;
  }

  Future<String?> isValidpropertyBathroomField(String? value) async {
    return (value == '0' || value!.isEmpty)
        ? 'addproperty.lbl_please_select_bathroom'.tr()
        : null;
  }

  @override
  void onSubmitting() async {
    try {
      UserModel currentUser = await app_instance.utility.jwtUser();
      String? userId = currentUser.id.toString();
      dynamic token = currentUser.token;
      /* 
          formData['id'])
       */

      String propertyPrice =
          double.parse(propertyPriceField.value).toStringAsFixed(0);
      String propertyArea =
          double.parse(propertyAreaField.value).toStringAsFixed(0);

      Map<String, Object> jsonCommonData = {
        'property_type_id': propertyTypeIdField.value,
        'purpose': buyrentTypeField.value,
        'agency_id': '0',
        'price_type': priceTypeField.value,
        'price': propertyPrice,
        'property_area': propertyArea,
        'property_area_unit': areaUnitField.value,
        'property_status': completionStatusField.value,
        'build_year': propertyYearsField.value,
        'bedrooms': propertBedroomField.value,
        'toilet': propertyBathroomField.value,
        'status': statusField.value,
      };

      Map<String, Object> jsonLocationData = {
        'google_autosearch_address': googleAutosearchAddressField.value,
        'address': addressField.value,
        'city': cityField.value,
        'state': stateField.value,
        'country': countryField.value,
        'address2': '',
        'latitude': lalatitudeField.value,
        'longitude': longitudeField.value,
        'zip_code': zipCodeField.value,
      };

      Map<String, Object> jsonNameData = {};
      if (localeLangField.value == 'ar_AR') {
        jsonNameData = {
          'name_arebic': propertyTitleField.value,
          'editAr': editArField.value
        };
      } else {
        jsonNameData = {
          'name_english': propertyTitleField.value,
          'editEn': editEnField.value
        };
      }

      Map<String, Object> jsonDescData = {};
      if (localeLangField.value == 'ar_AR') {
        jsonDescData = {'description_arebic': propertyDescriptionField.value};
      } else {
        jsonDescData = {'description_english': propertyDescriptionField.value};
      }

      Map<String, Object> jsonaddPropertyData = {};
      if (propIDField.value != '') {
        jsonaddPropertyData = {
          ...jsonCommonData,
          ...jsonNameData,
          ...jsonLocationData,
          'user_id': userId,
          'token': token.toString(),
          'id': propIDField.value,
          'admin_approved': adminApprovedField.value,
          'googleAutosearchAddressEditField':
              googleAutosearchAddressEditField.value,
          'platform': Platform.isAndroid ? 'Android' : 'iOS',
          'private_property': privateProperty.value
        };
      } else {
        jsonaddPropertyData = {
          ...jsonCommonData,
          ...jsonNameData,
          ...jsonLocationData,
          'user_id': userId.toString(),
          'token': token.toString(),
          'admin_approved': adminApprovedField.value,
          'googleAutosearchAddressEditField':
              googleAutosearchAddressEditField.value,
          'platform': Platform.isAndroid ? 'Android' : 'iOS',
          'private_property': privateProperty.value,
          'userSelectedCity': selectedCity.value,
        };
      }
      final response = await app_instance.propertyRepository
          .addProperty(jsonaddPropertyData);
      Map<String, dynamic> propertyResponse = {};
      try {
        final dataResponse = response;

        propertyResponse = dataResponse['property_data'];
        app_instance.storage
            .write(key: "propertyId", value: propertyResponse['id'].toString());
        app_instance.storage.write(
            key: "PropertyPurpose",
            value: propertyResponse['purpose'].toString());
      } catch (e, _) {
        print(e);
        print(_);
        print("Exception");
      }

      // String property_key = response['property_key'].toString();
      String insertId = response['insert_id'].toString();
      if (insertId != null) {
        Object jsonaddPropertyLocDescData = {
          ...jsonNameData,
          ...jsonDescData,
          'amenityArr': propertyAmenitiesField.value,
          'chk_loc': '1',
          'user_id': userId,
          'id': insertId,
          'token': token.toString(),
          'admin_approved': adminApprovedField.value,
          'googleAutosearchAddressEditField':
              googleAutosearchAddressEditField.value,
        };

        await app_instance.propertyRepository
            .addPropertyLocDesc(jsonaddPropertyLocDescData);

        Object jsonaddPropLocSetData = {
          ...jsonLocationData,
          'user_id': userId,
          'id': insertId,
          'token': token.toString(),
          'admin_approved': adminApprovedField.value,
          'googleAutosearchAddressEditField':
              googleAutosearchAddressEditField.value,
        };

        await app_instance.propertyRepository
            .addPropLocSet(jsonaddPropLocSetData);

        if (imagePresentField.value == 'yes') {
          await app_instance.storage.write(key: "imgUpload", value: 'YES');
        }
        Object jsonadirectDeployData = {
          'type': 'step3',
          'id': insertId,
          'token': token.toString()
        };
        await app_instance.propertyRepository
            .directDeploy(jsonadirectDeployData);

        Map<String, dynamic> successResponseString = {
          'insertId': insertId,
          'userPropertyCount':
              (environment == "staging") ? 10 : response['userPropertyCount']
        };

        emitSuccess(
            successResponse: jsonEncode(successResponseString),
            canSubmitAgain: true,
            isEditing: true);
      } else {
        emitFailure(failureResponse: "connection.connectionInterrupted".tr());
      }
    } on Exception catch (_) {
      emitFailure(failureResponse: "connection.connectionInterrupted".tr());
    }
  }

  Future<String> isdirectDeploy(String insertId) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    Object jsonadirectDeployData = {
      'type': 'step3',
      'id': insertId,
      'token': currentUser.token.toString()
    };
    await app_instance.propertyRepository.directDeploy(jsonadirectDeployData);
    return '1';
  }

  void dispose() {
    nameField.close();
    buyrentTypeField.close();
    propertyTypeField.close();
    propertyTypeIdField.close();
    priceTypeField.close();
    completionStatusField.close();
    propertyYearsField.close();
    citySearchTextField.close();
    propertyTitleField.close();
    propertyDescriptionField.close();
    propertyPriceField.close();
    propertyAreaField.close();
    areaUnitField.close();
    propertBedroomField.close();
    propertyBathroomField.close();
    propertyAmenitiesField.close();
    addressField.close();
    cityField.close();
    stateField.close();
    countryField.close();
    googleAutosearchAddressField.close();
    zipCodeField.close();
    lalatitudeField.close();
    longitudeField.close();

    localeLangField.close();
    imagePresentField.close();

    propIDField.close();
    adminApprovedField.close();
    googleAutosearchAddressEditField.close();
    editEnField.close();
    editArField.close();
    statusField.close();
  }
}
