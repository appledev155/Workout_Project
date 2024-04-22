// ignore_for_file: unrelated_type_equality_checks

import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/views/components/notify.dart';
import 'package:nexmo_verify/basemodel.dart';
import 'package:nexmo_verify/nexmo_sms_verify.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class OtpFormBloc extends FormBloc<String, String> {
  final otpCode = TextFieldBloc();
  TwilioPhoneVerify? _twilioPhoneVerify;
  NexmoSmsVerificationUtil nexmoSmsVerificationUtil =
      NexmoSmsVerificationUtil();

  OtpFormBloc() {
    addFieldBlocs(
      fieldBlocs: [otpCode],
    );
  }

  Future<String?> _isValidOtpCode(String value) async {
    final phoneRegex = RegExp(r'^[0-9]+$');
    final error =
        (value == null) ? 'settings.err_confirmationCode_required'.tr() : null;
    return (error != null)
        ? error
        : phoneRegex.hasMatch(value)
            ? null
            : 'settings.err_confirmationCode_pattern'.tr();
  }

  void cancelVerificationProcess() async {
    int? status;
    dynamic errorText;
    final tempData = await Notify().getArguments();
    final authyId = await app_instance.storage.read(key: 'authyId');
    nexmoSmsVerificationUtil.initNexmo(
        tempData['VONAGE_API_KEY'], tempData['VONAGE_API_SECRET']);

    await nexmoSmsVerificationUtil.cancelOldRequest().then((dynamic res) {
      status = int.tryParse((res as BaseModel).nexmoResponse!.status!);
      errorText = ((res).nexmoResponse!.errorText);
    });
  }

  void resend() async {
    int? status;
    dynamic errorText;
    final tempData = await Notify().getArguments();
    await app_instance.storage.delete(key: "tryOtpCount");

    nexmoSmsVerificationUtil.initNexmo(
        tempData['VONAGE_API_KEY'], tempData['VONAGE_API_SECRET']);

    await nexmoSmsVerificationUtil.resentOtp().then((dynamic res) {
      status = int.tryParse((res as BaseModel).nexmoResponse!.status!);
      errorText = ((res).nexmoResponse!.errorText);
    });
    if (status == 0) {
      emitSuccess(
          successResponse: 'settings.send_sms_loading_msg',
          canSubmitAgain: true,
          isEditing: true);
    } else {
      emitFailure(failureResponse: errorText);
      extraSuccess();
    }
  }

  @override
  void onSubmitting() async {
    print("onSubmitting verify SMS code");
    final tempData = await Notify().getArguments();
    _twilioPhoneVerify = TwilioPhoneVerify(
        accountSid: tempData['TML_ACCOUNT_SID'], // replace with Account SID
        authToken: tempData['TWILIO_AUTH_TOKEN'], // replace with Auth Token
        serviceSid: tempData['TWILIO_SID'] // replace with Service SID
        );

    // If Authy has value user want to receive the SMS
    final authyId = await app_instance.storage.read(key: 'authyId');
    nexmoSmsVerificationUtil.initNexmo(
        tempData['VONAGE_API_KEY'], tempData['VONAGE_API_SECRET']);
    try {
      final error = await _isValidOtpCode(otpCode.value);
      if (error == null) {
        await app_instance.storage.write(key: 'isNewNumber', value: 'true');
        dynamic phoneNumberString =
            await app_instance.storage.read(key: 'tempPhoneNumber');
        dynamic phoneNumber =
            await app_instance.storage.read(key: 'newPhoneNumber');
        UserModel currentUser = await app_instance.utility.jwtUser();
        String? userId = currentUser.id.toString();

        // If AuthyId not null we are processing via twillio.
        if (authyId != null) {
          // 1st we are sending SMS via Twilio
          TwilioResponse twillioResponse = await _twilioPhoneVerify!
              .verifySmsCode(phone: phoneNumberString, code: otpCode.value);
          if (twillioResponse.successful!) {
            print("****** Process via twilio");
            if (twillioResponse.verification!.status ==
                VerificationStatus.approved) {
              print("****** Approval via twilio");
              Map<String, Object> jsonData = {
                'phoneNumberString': phoneNumberString.toString(),
                'phoneNumber': phoneNumber.toString(),
                'user_id': userId,
                'token': currentUser.token.toString()
              };
              dynamic res = await app_instance.userRepository.updatePhnNumberStatus(
                  jsonData); //This API used for the update phone number status as Verified.
              if (res['status'] == 'success') {
                final data = await Notify().checkAllNumber();
                if (data) {
                  emitSuccess(
                    successResponse: 'settings.phone_success_msg',
                    canSubmitAgain: true,
                    isEditing: true,
                  );
                }
              }
            } else {
              print("****** Invalid failed Twilio");
              emitFailure(failureResponse: 'Invalid OTP');
              extraSuccess();
            }
          } else {
            print("****** Twilio Servie falied");
            emitFailure(failureResponse: twillioResponse.errorMessage);
            extraSuccess();
          }
        } else {
          int? status;
          var errorText;
          await nexmoSmsVerificationUtil
              .verifyOtp(otpCode.value)
              .then((dynamic res) {
            status = int.tryParse((res as BaseModel).nexmoResponse!.status!);
            errorText = (res).nexmoResponse!.errorText;
          });
          if (status == 0) {
            Map<String, Object> jsonData = {
              'phoneNumberString': phoneNumberString.toString(),
              'phoneNumber': phoneNumber.toString(),
              'user_id': userId,
              'token': currentUser.token.toString()
            };
            dynamic res = await app_instance.userRepository.updatePhnNumberStatus(
                jsonData); //This API used for the update phone number status as Verified.
            if (res['status'] == 'success') {
              final data = await Notify().checkAllNumber();
              if (data) {
                emitSuccess(
                    successResponse: 'settings.phone_success_msg',
                    canSubmitAgain: true,
                    isEditing: true);
              }
            } else {
              emitFailure(failureResponse: error.toString());
              extraSuccess();
            }
          } else {
            emitFailure(failureResponse: errorText);
            extraSuccess();
          }
        }
      } else {
        emitFailure(failureResponse: error.toString());
        extraSuccess();
      }
    } catch (e, _) {
      print(e);
      print(_);
      print("Exception");
      emitFailure(failureResponse: e.toString());
      extraSuccess();
    }
  }

  void extraSuccess() {
    emitSuccess(successResponse: '', canSubmitAgain: true, isEditing: true);
  }

  void dispose(e) {
    otpCode.close();
  }
}
