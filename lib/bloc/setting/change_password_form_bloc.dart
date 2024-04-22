import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ChangePasswordFormBloc extends FormBloc<String, String> {
  final currentPassword = TextFieldBloc();
  final password = TextFieldBloc();
  final confirmPassword = TextFieldBloc();

  ChangePasswordFormBloc() {
    currentPassword.addAsyncValidators([_isValidCurrentPassword]);
    password.addAsyncValidators([_isValidPassword]);
    confirmPassword.addAsyncValidators([_isValidConfirmPassword]);
    addFieldBlocs(
      fieldBlocs: [
        currentPassword,
        password,
        confirmPassword,
      ],
    );
  }

  Future<String?> _isValidCurrentPassword(String value) async {
    final error = value.isEmpty ? 'login.err_password_required'.tr() : null;
    return (error != null)
        ? error
        : value.length > 5
            ? null
            : 'login.err_existing_password_minlength'.tr();
  }

  Future<String?> _isValidPassword(String value) async {
    final error = value.isEmpty ? 'login.err_password_required'.tr() : null;
    return (error != null)
        ? error
        : value.length > 7
            ? null
            : 'login.err_password_minlength'.tr();
  }

  Future<String?> _isValidConfirmPassword(String value) async {
    final error =
        value.isEmpty ? 'register.err_confirm_password_required'.tr() : null;
    return (error != null)
        ? error
        : value.length > 7
            ? (value != password.value)
                ? 'register.err_password_mismatch'.tr()
                : null
            : 'register.err_confirm_password_minlength'.tr();
  }

  @override
  void onSubmitting() async {
    try {
      final credential = EmailAuthProvider.credential(
          email: _auth.currentUser!.email!, password: currentPassword.value);
      await _auth.currentUser!
          .reauthenticateWithCredential(credential)
          .then((value) async {
        await _auth.currentUser!.updatePassword(password.value);
      });
      emitSuccess(
          successResponse: 'settings.success_msg_password',
          canSubmitAgain: true,
          isEditing: true);
    } catch (e, trace) {
      print(e);
      print(trace);
      emitFailure(failureResponse: e.toString());
    }
  }
}
