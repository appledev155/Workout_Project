import 'dart:async';
import 'package:form_bloc/form_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ForgotFormBloc extends FormBloc<String, String> {
  final email = TextFieldBloc();
  ForgotFormBloc() {
    email.addAsyncValidators([_isValidEmail]);
    addFieldBlocs(
      fieldBlocs: [
        email,
      ],
    );
  }

  Future<String?> _isValidEmail(String? value) async {
    final _emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );
    final error = value!.isEmpty ? 'login.err_email_required'.tr() : null;
    return (error != null)
        ? error
        : _emailRegex.hasMatch(value)
            ? null
            : 'login.err_email_pattern'.tr();
  }

  @override
  void onSubmitting() async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.value,
      );
      emitSuccess(
          successResponse: 'Submitted', canSubmitAgain: true, isEditing: true);
    } catch (e) {
      emitFailure(failureResponse: e.toString());
      //emitFailure(failureResponse: e.message);
    }
  }
}
