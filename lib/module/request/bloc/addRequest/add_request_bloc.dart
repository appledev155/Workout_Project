import 'dart:async';
import 'package:anytimeworkout/isar/request/request_isar.dart';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/module/utility.dart';
import 'package:anytimeworkout/repository/user_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:anytimeworkout/isar/request/request_row.dart' as request_store;
import 'package:anytimeworkout/config.dart' as app_instance;

class AddRequestBloc extends FormBloc<String, String> {
  final description = TextFieldBloc();
  final mobile = TextFieldBloc();
  final budget = TextFieldBloc();
  final contactType = TextFieldBloc();
  final localeLangField = TextFieldBloc();
  request_store.RequestRow requestStore = request_store.RequestRow();

  AddRequestBloc() {
    addFieldBlocs(
      fieldBlocs: [
        description,
        mobile,
        budget,
        // location,
        contactType,
        localeLangField
      ],
    );
  }

  Future<String?> isValidDescriptionField(String value) async {
    return (value == '0' || value.isEmpty)
        ? 'request.lbl_desc_required'.tr()
        : null;
  }

  Future<String?> isValidLocationDropdownField(String? value) async {
    return (value! == 'request.lbl_select_city')
        ? 'request.lbl_city_required'.tr()
        : null;
  }

  @override
  void onSubmitting() async {
    try {
      UserModel currentUser = await app_instance.utility.jwtUser();
      String? userId = currentUser.id.toString();
      String? selctedContactWay =
          await app_instance.storage.read(key: 'selectedContactWay');
      String? activeSts =
          await app_instance.storage.read(key: 'requestActivateStatus');
      int? activateStatus = int.parse(activeSts.toString());
      String? selcted =
          selctedContactWay.toString().replaceAll('[', '').replaceAll(']', '');

      Map<String, Object> requestInfo;

      dynamic selctedLocation =
          await app_instance.storage.read(key: 'SelectLocation');
      String createdTimeToken =
          app_instance.utility.getUnixTimeStampInPubNubPrecision();
      String requestId = "$userId$createdTimeToken";
      requestInfo = {
        'token': currentUser.token.toString(),
        'description_ar':
            (localeLangField.value == 'ar_AR') ? description.value : '',
        'description_en':
            (localeLangField.value == 'en_US') ? description.value : '',
        'phone': mobile.value,
        'budget': budget.value,
        'location': selctedLocation!,
        'contact_type': selcted,
        'createdTimetoken': createdTimeToken,
        'amount': '0',
        'user_id': (userId != null) ? userId.toString() : '',
        'name': '',
        'stripeCustomerId': '0',
        'paymentIntentId': '0',
        'status': activateStatus.toString()
      };

      try {
        int requestStatus = int.parse(requestInfo['status'].toString());
        RequestIsar saveRequest = RequestIsar();
        saveRequest.id = requestId;
        saveRequest.serverId = '0';
        saveRequest.descriptionAr = requestInfo['description_ar'].toString();
        saveRequest.descriptionEn = requestInfo['description_en'].toString();
        saveRequest.location = requestInfo['location'].toString();
        saveRequest.budget = requestInfo['budget'].toString();
        saveRequest.phone = requestInfo['phone'].toString();
        saveRequest.status = requestStatus;
        saveRequest.createdAt = int.parse(createdTimeToken);
        saveRequest.updatedAt = int.parse(createdTimeToken);
        await requestStore.saveRequest(saveRequest);

        if (requestStatus == 1) {
          await requestStore.updateStatus(int.parse(createdTimeToken));
        }

        emitSuccess(
            successResponse: "success", canSubmitAgain: true, isEditing: true);
        await app_instance.storage.delete(key: 'requestID');
        app_instance.userRepository.requestPropAdd(requestInfo); // called API
      } catch (e, _) {
        print(e);
        print(_);
      }
    } on Exception catch (e, _) {
      print(e);
      print(_);
      emitFailure(failureResponse: "connection.connectionInterrupted".tr());
    }
  }

  // void dispose() {
  //   description.close();
  //   mobile.close();
  //   budget.close();
  //   //  location.close();
  //   contactType.close();
  // }
}
