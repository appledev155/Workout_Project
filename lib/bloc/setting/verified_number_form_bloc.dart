import 'package:anytimeworkout/model/user_model.dart';

import '../../repository/user_repository.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class VerifiedNumberFormBloc extends FormBloc<String, String> {
  final phoneID = TextFieldBloc();

  VerifiedNumberFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        phoneID,
      ],
    );
  }

  @override
  void onSubmitting() async {
    try {
      UserModel currentUser = await app_instance.utility.jwtUser();
      Map<String, Object> jsonData = {
        'user_id': currentUser.id.toString(),
        'phoneNumber': phoneID.value,
        'token': currentUser.token.toString()
      };
      dynamic res = await app_instance.userRepository.activePhone(jsonData);
      if (res) {
        emitSuccess(
            successResponse: 'settings.active_phone_success_msg',
            canSubmitAgain: true,
            isEditing: true);
      } else {
        emitFailure(failureResponse: 'connection.connectionInterrupted'.tr());
      }
    } catch (e, _) {
      print(e);
      print(_);
      emitFailure(failureResponse: e.toString());
    }
  }

  void dispose() {
    phoneID.close();
  }
}
