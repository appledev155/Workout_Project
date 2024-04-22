import 'dart:async';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;
import 'package:form_bloc/form_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginFormBloc extends FormBloc<String, String> {
  String? yourClientId = dotenv.env['FIREBASEFBCLIENTID'];
  String? yourRedirectUrl = dotenv.env['FIREBASEFBREDIRECTURL'];

  final email = TextFieldBloc();
  final password = TextFieldBloc();

  LoginFormBloc() {
    email.addAsyncValidators([_isValidEmail]);
    password.addAsyncValidators([_isValidPassword]);
    addFieldBlocs(
      fieldBlocs: [
        email,
        password,
      ],
    );
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
        : value.length > 5
            ? null
            : 'login.err_password_minlength'.tr();
  }

  @override
  void onSubmitting() async {
    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
        email: email.value,
        password: password.value,
      ))
          .user;
      dynamic token = await user!.getIdToken();
      await _submitLoginForm(token);
    } catch (e) {
      // emitFailure(failureResponse: e.message);
      emitFailure(failureResponse: e.toString());
      extraSuccess();
    }
  }

  Future<dynamic> _submitLoginForm(token) async {
    Object jsonData = {'email': email.value, 'token': token.toString()};
    await app_instance.userRepository.submitLoginForm(jsonData);

    emitSuccess(
        successResponse: 'success', canSubmitAgain: true, isEditing: true);
  }

  Future<dynamic> _loginWithSocial(token, email, account) async {
    try {
      Object jsonData = {
        'email': email.toString(),
        'token': token.toString(),
        'account': account.toString()
      };
      await app_instance.userRepository.loginWithSocial(jsonData);

      emitSuccess(
          successResponse: 'successfully',
          canSubmitAgain: true,
          isEditing: true);
      return true;
    } on Exception catch (_) {
      emitFailure(failureResponse: "connection.connectionInterrupted".tr());
      extraSuccess();
      return false;
    }
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      UserCredential? userCredential;

      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser != null) {
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;

          /*    final GoogleAuthCredential googleAuthCredential =
              GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ); */

          final OAuthCredential googleAuthCredential =
              GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          userCredential =
              await _auth.signInWithCredential(googleAuthCredential);
        }
      }
      if (userCredential != null) {
        final user = userCredential.user;
        dynamic token = await user!.getIdToken();
        dynamic email = user.providerData[0].email;
        return await _loginWithSocial(token, email, 'google');
      } else {
        emitFailure(failureResponse: '');
        extraSuccess();
        return false;
      }
    } catch (e) {
      print(e);
      Object errData = {
        'user_id': '0',
        'post_url': 'google_signin',
        'error_data': e.toString(),
        //  'error_data': e.message
      };
      app_instance.userRepository.addLogs(errData);
      emitFailure(failureResponse: e.toString());
      extraSuccess();
      return false;
    }
  }

  Future<dynamic> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance
        .login(loginBehavior: LoginBehavior.nativeWithFallback);

    if (result.status == LoginStatus.success) {
      try {
        final facebookAuthCred =
            FacebookAuthProvider.credential(result.accessToken!.token);

        final User? user =
            (await _auth.signInWithCredential(facebookAuthCred)).user;

        dynamic token = await user!.getIdToken();
        dynamic email = user.providerData[0].email;
        return await _loginWithSocial(token, email, 'facebook');
      } catch (e) {
        Object errData = {
          'user_id': '0',
          'post_url': 'facebok_signin',
          'error_data': e.toString()
          // 'error_data': e.message
        };
        app_instance.userRepository.addLogs(errData);
        emitFailure(failureResponse: e.toString());
        extraSuccess();
        return false;
      }
    } else {
      emitFailure(failureResponse: '');
      extraSuccess();
      return false;
    }
  }

  Future<dynamic> appleSignIn() async {
    try {
      final apple.AuthorizationResult appleResult =
          await apple.TheAppleSignIn.performRequests([
        const apple.AppleIdRequest(
            requestedScopes: [apple.Scope.email, apple.Scope.fullName])
      ]);

      if (appleResult.error != null) {
        // handle errors from Apple here
        Object errData = {
          'user_id': '0',
          'post_url': 'apple_signin',
          'error_data': appleResult.error.toString()
        };
        app_instance.userRepository.addLogs(errData);

        emitFailure(failureResponse: appleResult.error.toString());
        extraSuccess();
      }

      final AuthCredential credential = OAuthProvider('apple.com').credential(
        accessToken:
            String.fromCharCodes(appleResult.credential!.authorizationCode!),
        idToken: String.fromCharCodes(appleResult.credential!.identityToken!),
      );
      if (credential != null) {
        final User? user = (await _auth.signInWithCredential(credential)).user;
        dynamic token = await user!.getIdToken();
        dynamic email = user.providerData[0].email;
        return await _loginWithSocial(token, email, 'apple');
      } else {
        emitFailure(failureResponse: '');
        extraSuccess();
        return false;
      }
    } catch (e) {
      Object errData = {
        'user_id': '0',
        'post_url': 'apple_signin',
        'error_data': (e.runtimeType.toString() == 'NoSuchMethodError')
            ? 'The getter authorizationCode was called on null'
            : e.toString() // e.message
      };
      app_instance.userRepository.addLogs(errData);
      emitFailure(
          failureResponse: (e.runtimeType.toString() == 'NoSuchMethodError')
              ? 'The getter authorizationCode was called on null'
              : e.toString());
      extraSuccess();
      return false;
    }
  }

  void extraSuccess() {
    emitSuccess(successResponse: '', canSubmitAgain: true, isEditing: true);
  }
}
