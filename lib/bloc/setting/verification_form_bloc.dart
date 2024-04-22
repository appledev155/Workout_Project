// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';

import 'package:anytimeworkout/views/components/notify.dart';
import 'package:nexmo_verify/basemodel.dart';
import 'package:nexmo_verify/nexmo_sms_verify.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class VerificationScreenBloc extends FormBloc<String, dynamic> {
  final optField = TextFieldBloc();
  TwilioPhoneVerify? _twilioPhoneVerify;
  final NexmoSmsVerificationUtil _nexmoSmsVerificationUtil =
      NexmoSmsVerificationUtil();
  // ignore: close_sinks
  final streamController = StreamController();
  VerificationScreenBloc() {
    addFieldBlocs(
      fieldBlocs: [
        optField,
      ],
    );
  }

  @override
  void onSubmitting() async {
    final tempData = await Notify().getArguments();
    try {
      dynamic phoneNumberString =
          await app_instance.storage.read(key: 'newPhoneNumberString');
      dynamic tryOtpCount = await app_instance.storage.read(key: "tryOtpCount");
      dynamic phoneNumber =
          await app_instance.storage.read(key: 'newPhoneNumber');
      // send 1st and 2nd message from Twillio and 3rd message from Vonage(Nexmo)
      if (optField.value == '2') {
        if (int.parse(tryOtpCount) < 2) {
          sendMessageViaTwillio(
              tempData, phoneNumberString, phoneNumber, tryOtpCount);
        } else {
          sendMessageViaNexmo(tempData, phoneNumberString, phoneNumber);
        }
      }
    } catch (e, _) {
      print(e);
      print(_);
      print("Exception");
      emitFailure(failureResponse: e.toString());
    }
  }

  // Function for send message via Twillio. first and second message
  sendMessageViaTwillio(dynamic tempData, dynamic phoneNumberString,
      dynamic phoneNumber, dynamic tryOtpCount) async {
    print('************sending SMS via Twillio **********');
    _twilioPhoneVerify = TwilioPhoneVerify(
        accountSid: tempData['TML_ACCOUNT_SID'], // replace with Account SID
        authToken: tempData['TWILIO_AUTH_TOKEN'], // replace with Auth Token
        serviceSid: tempData['TWILIO_SID'] // replace with Service SID
        );
    dynamic twillioResponse =
        await _twilioPhoneVerify!.sendSmsCode(phoneNumberString);

    dynamic twillioResponseJson = {
      "statusCode": twillioResponse.statusCode.toString(),
      "successful": twillioResponse.successful.toString(),
    };

    await app_instance.storage.write(
        key: "twillioResponseJsonData", value: twillioResponseJson.toString());

    await app_instance.storage
        .write(key: 'tempPhoneNumber', value: phoneNumberString);
    await app_instance.storage.write(key: 'newPhoneNumber', value: phoneNumber);
    await app_instance.storage.write(key: 'authyId', value: '132');
    emitSuccess(successResponse: '2', canSubmitAgain: true, isEditing: true);
  }

  // Function for send message via Nexmo. third message
  sendMessageViaNexmo(
      dynamic tempData, dynamic phoneNumberString, dynamic phoneNumber) async {
    print('************sending SMS via Nexmo **********');
    late int status;
    dynamic errorText;
    _nexmoSmsVerificationUtil.initNexmo(
        tempData['VONAGE_API_KEY'], tempData['VONAGE_API_SECRET']);
    await _nexmoSmsVerificationUtil
        .sendOtp(phoneNumberString, "ANYTIME WORKOUT", 4)
        .then((dynamic res) {
      status = int.tryParse((res as BaseModel).nexmoResponse!.status!)!;
      errorText = ((res).nexmoResponse!.errorText);
    });
    if (status == 0) {
      await app_instance.storage.delete(key: 'authyId');
      await app_instance.storage
          .write(key: 'tempPhoneNumber', value: phoneNumberString);
      await app_instance.storage
          .write(key: 'newPhoneNumber', value: phoneNumber);

      emitSuccess(successResponse: '2', canSubmitAgain: true, isEditing: true);
    } else {
      emitFailure(failureResponse: errorText);
    }
  }

  void dispose() {
    optField.close();
  }
}
