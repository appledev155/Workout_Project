import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import '../../../views/components/notify.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

part 'add_form_event.dart';
part 'add_form_state.dart';

class AddFormBlocNew extends Bloc<AddFormEvent, AddFormState> {
  AddFormBlocNew() : super(const AddFormState()) {
    on<PhoneNumberChanged>(_onPhoneNumberChanged);
    on<Submit>(_onSubmit);
  }

  Future<void> _onPhoneNumberChanged(
      PhoneNumberChanged event, Emitter<AddFormState> emit) async {
    emit(state.copyWith(phoneNumber: event.phoneNumber));
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
    emit(state.copyWith(phoneNumber: value));
    //   phoneNumber.updateValue(value);
    return value;
  }

  Future<void> _onSubmit(Submit event, Emitter<AddFormState> emit) async {
    try {
      String number =
          _isNumberArabic(/* phoneNumber.value */ state.phoneNumber!);
      final tempData = await Notify().getArguments();
      String replacedString = tempData['MASKNUMBER'];
      String stdCode = tempData['STDCODE'];
      // phone number string contain STD code
      String phoneNumberString;
      // Only having phone number without STD code
      String newPhoneNumber;
      // The loop for QA Testing start here
      if (replacedString == number.substring(0, 6) ||
          replacedString == number.substring(3, 9)) {
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
      await app_instance.storage
          .write(key: 'onlyPhoneNumber', value: newPhoneNumber);
      app_instance.userRepository.storePhoneNumberInDb(newPhoneNumber);
      app_instance.appConfig.setHomeScreenRoute = true;
      return emit(state.copyWith(
          status: Status.success,
          message: 'settings.send_sms_loading_msg'.tr(),
          phoneNumber: ''));
      /*   emitSuccess(
        successResponse: 'settings.send_sms_loading_msg',
        canSubmitAgain: true,
        isEditing: true,
      ); */
    } catch (e, _) {
      print(e);
      print(_);
      print("Exception");
      emit(state.copyWith(status: Status.failure, message: e.toString()));
      /*   emitFailure(failureResponse: e.toString()); */
    }
  }
}
