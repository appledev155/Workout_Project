import 'dart:async';
import 'package:form_bloc/form_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterFormBloc extends FormBloc<String, String> {
  final name = TextFieldBloc();
  final email = TextFieldBloc();
  final password = TextFieldBloc();
  final confirmPassword = TextFieldBloc();

  RegisterFormBloc() {
    name.addAsyncValidators([_isValidName]);
    email.addAsyncValidators([_isValidEmail]);
    password.addAsyncValidators([_isValidPassword]);
    confirmPassword.addAsyncValidators([_isValidConfirmPassword]);

    addFieldBlocs(
      fieldBlocs: [
        name,
        email,
        password,
        confirmPassword,
      ],
    );
  }

  Future<String?> _isValidName(String value) async {
    final error = value.isEmpty ? 'register.err_name_required'.tr() : null;
    return error;
  }

  Future<String?> _isValidEmail(String value) async {
    final _emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );
    final error = value.isEmpty ? 'login.err_email_required'.tr() : null;
    return (error != null)
        ? error
        : _emailRegex.hasMatch(value)
            ? null
            : 'login.err_email_pattern'.tr();
  }

  Future<String?> _isValidPassword(String value) async {
    final error = value.isEmpty ? 'login.err_password_required'.tr() : null;
    return (error != null)
        ? error
        : value.length > 7
            ? null
            : 'register.err_password_minlength'.tr();
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
      final User? user = (await _auth.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      ))
          .user;

      await _auth.currentUser!.updateDisplayName(name.value);
      dynamic token = await user!.getIdToken();
      await _submitLoginForm(token);
    } catch (e) {
      emitFailure(failureResponse: e.toString());
      extraSuccess();
    }
  }

  Future<dynamic> _submitLoginForm(token) async {
    try {
      Object jsonData = {
        'displayName': name.value,
        'email': email.value,
        //'password': password.value,
        'role_id': '4',
        'propertyAreaUnit': 'Sq. Ft.',
        'phoneNumber': '',
        'token': token.toString()
      };
      final response =
          await app_instance.userRepository.submitLoginForm(jsonData);

      Object jsonEmailData = {
        'user_id': response['user']['id'].toString(),
        'db_type': 'member',
        'token': response['token'].toString()
      };
      app_instance.userRepository.appSendConfirmEmail(jsonEmailData);

      emitSuccess(
          successResponse: 'successfully',
          canSubmitAgain: true,
          isEditing: true);
    } on Exception catch (_) {
      emitFailure(failureResponse: "connection.connectionInterrupted");
      extraSuccess();
    }
  }

  void extraSuccess() {
    emitSuccess(successResponse: '', canSubmitAgain: true, isEditing: true);
  }
}
