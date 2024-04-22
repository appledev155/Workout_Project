import 'dart:async';
import 'dart:convert';
import 'package:anytimeworkout/views/components/notify.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class AddNumberFormBloc extends FormBloc<String, String> {
  final phoneNumber = TextFieldBloc();

  AddNumberFormBloc() {
    phoneNumber.addAsyncValidators([_isValidPhoneNumber]);

    addFieldBlocs(
      fieldBlocs: [
        phoneNumber,
      ],
    );
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
    phoneNumber.updateValue(value);
    return value;
  }

  Future<String?> _isValidPhoneNumber(String value) async {
    final tempData = await Notify().getArguments();
    final _phoneRegex = RegExp('^[0-9\u0660-\u0669]');
    bool flag = false;
    final error =
        (value.isEmpty) ? 'register.err_phoneNumber_required'.tr() : null;

    int valuelength = value.length;
    if (value.startsWith('0') && valuelength > 5) {
      value = value.replaceFirst('0', '');
      phoneNumber.updateValue(value);
    }

    _isNumberArabic(value);

    dynamic response = (error != null)
        ? error
        : (value.replaceAll(' ', '').length > 5 &&
                tempData['MASKNUMBER'] ==
                    value.replaceAll(' ', '').substring(0, 6))
            ? null
            : (value.replaceAll(' ', '').length != 9)
                ? 'settings.valid_phone_number'.tr()
                : _phoneRegex.hasMatch(value)
                    ? null
                    : 'settings.err_phoneNumber_numeric'.tr();

    if ((value.replaceAll(' ', '').length > 5 &&
                tempData['MASKNUMBER'] ==
                    value.replaceAll(' ', '').substring(0, 6)) ==
            false &&
        response == null) {
      dynamic storedUserPhoneNumber =
          await app_instance.storage.read(key: 'UserPhoneNumbers');
      if (storedUserPhoneNumber != null) {
        dynamic phoneList = json.decode(storedUserPhoneNumber);

        await phoneList.forEach((e) {
          if (e['phoneNumber'] == value.replaceAll(' ', '')) {
            flag = true;
            response = 'settings.phone_already_verified'.tr();
          }
        });
      }
    }

    return response;
  }

  @override
  void onSubmitting() async {
    try {
      String number = _isNumberArabic(phoneNumber.value);
      final tempData = await Notify().getArguments();
      String replacedString = tempData['MASKNUMBER'];
      String stdCode = tempData['STDCODE'];
      // phone number string contain STD code
      String phoneNumberString;
      // Only having phone number without STD code
      String newPhoneNumber;
      // The loop for QA Testing start here
      if (replacedString == number.substring(0, 6)) {
        // Note: We are not validating eixisting mobile condition for QA
        final data = number.split(replacedString);
        var stdCode = data[1];
        var mobNumber = data[2];
        number = number.replaceAll(replacedString, '');
        phoneNumberString = '+$stdCode$mobNumber';
        newPhoneNumber = mobNumber;
      } else {
        // for App USER
        phoneNumberString = stdCode + number;
        phoneNumberString =
            phoneNumberString.replaceAll('${stdCode}0', stdCode);
        newPhoneNumber = number;
      }
      await app_instance.storage.write(key: 'stdCode', value: stdCode);
      await app_instance.storage
          .write(key: 'isValidNumber', value: newPhoneNumber);
      await app_instance.storage
          .write(key: 'newPhoneNumber', value: newPhoneNumber);
      await app_instance.storage
          .write(key: 'newPhoneNumberString', value: phoneNumberString);
      emitSuccess(
        successResponse: 'settings.send_sms_loading_msg',
        canSubmitAgain: true,
        isEditing: true,
      );
    } catch (e, _) {
      print(e);
      print(_);
      print("Exception");
      emitFailure(failureResponse: e.toString());
    }
  }
}
