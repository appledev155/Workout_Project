import 'dart:async';
import 'package:form_bloc/form_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class ContactFormBloc extends FormBloc<String, String> {
  final nameField = TextFieldBloc();
  final emailField = TextFieldBloc();

  final phoneField = TextFieldBloc();

  final messageField = TextFieldBloc();

  ContactFormBloc() {
    nameField.addAsyncValidators([_isValidName]);
    emailField.addAsyncValidators([_isValidEmail]);
    messageField.addAsyncValidators([_isValidMessage]);
    phoneField.addAsyncValidators([_isValidPhone]);
    addFieldBlocs(
      fieldBlocs: [
        nameField,
        emailField,
        phoneField,
        messageField,
      ],
    );
  }

  Future<String?> _isValidName(String? value) async {
    return value!.isEmpty ? 'register.err_name_required'.tr() : null;
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

    phoneField.updateValue(value);
    return value;
  }

  Future<String?> _isValidPhone(String? value) async {
    return (value!.length < 10)
        ? 'register.err_phoneNumber_required'.tr()
        : null;
  }

  Future<String?> _isValidMessage(String? value) async {
    return value!.isEmpty ? 'register.err_formTextarea_required'.tr() : null;
  }

  @override
  void onSubmitting() async {
    String _number = _isNumberArabic(phoneField.value);
    try {
      Object jsonData = {
        'name': nameField.value,
        'email': emailField.value,
        'phone': _number,
        'description': 'Test From Flutter', //messageField.value,
        'contact_flag': '1'
      };

      await app_instance.contactRepository.sendContact(jsonData);
      await Future<void>.delayed(const Duration(seconds: 1));
      emitSuccess(
          successResponse: 'Submitted', canSubmitAgain: true, isEditing: true);
    } on Exception catch (_) {
      emitFailure(failureResponse: "connection.connectionInterrupted".tr());
    }
  }
}
