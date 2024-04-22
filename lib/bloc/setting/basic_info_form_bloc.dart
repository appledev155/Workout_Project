import 'dart:async';
import 'dart:convert';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mime/mime.dart';
import 'package:minio/minio.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:minio/io.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

// TODD: check the local storage token if firebase token expired
final FirebaseAuth _auth = FirebaseAuth.instance;

class BasicInfoFormBloc extends FormBloc<String, String> {
  final name = TextFieldBloc();
  final email = TextFieldBloc();
  final imageUrl = TextFieldBloc();
  final uploadImageUrl = TextFieldBloc();
  final _s3Url = dotenv.env['S3URL'];
  final _s3AccessKey = dotenv.env['S3ACCESSKEY'];
  final _s3SecretKey = dotenv.env['S3SECRETKEY'];
  final _region = dotenv.env['S3REGION'];
  final _s3BucketUrl = dotenv.env['S3UPURL'];
  final _s3Bucket = dotenv.env['S3BUCKET'];

  final propertyAreaUnit = SelectFieldBloc(
    items: ['addproperty.lbl_sqft', 'addproperty.lbl_sqm'],
  );

  getProfile() async {
    UserModel getCurrentUser = await app_instance.utility.jwtUser();
    if (getCurrentUser != UserModel.empty) {
      imageUrl.updateValue(getCurrentUser.profileImage.toString());
    }
    name.updateValue(
        getCurrentUser.name != null ? getCurrentUser.name.toString() : '');
    email.updateValue(
        getCurrentUser.email != null ? getCurrentUser.email.toString() : '');
    final result = await app_instance.storage.read(key: 'JWTUser');
    dynamic rec = json.decode(result.toString());
    propertyAreaUnit.updateValue(rec['property_area_unit'] == 'Sq. Ft.'
        ? 'addproperty.lbl_sqft'
        : 'addproperty.lbl_sqm');
    return;
  }

  BasicInfoFormBloc() {
    getProfile();

    name.addAsyncValidators([_isValidName]);
    addFieldBlocs(
      fieldBlocs: [
        name,
        email,
        propertyAreaUnit,
      ],
    );
  }

  Future<String?> _isValidName(String value) async {
    final error = value.isEmpty ? 'register.err_name_required'.tr() : null;
    return error;
  }

  @override
  void onSubmitting() async {
    try {
      String? propUnit = propertyAreaUnit.value == 'addproperty.lbl_sqft'
          ? 'Sq. Ft.'
          : 'Sq. M.';
      await _auth.currentUser?.updateDisplayName(name.value);
      await app_instance.utility.updateJwtUser(
          {"displayName": name.value, "propertyAreaUnit": propUnit});
      await app_instance.storage
          .write(key: "propertyAreaUnit", value: propUnit);
      _submitSettingForm();
    } catch (e) {
      emitFailure(failureResponse: e.toString());
      extraSuccess();
    }
  }

  dynamic _submitSettingForm() async {
    dynamic firebaseToken = await _auth.currentUser!.getIdToken();
    try {
      String propUnit = propertyAreaUnit.value == 'addproperty.lbl_sqft'
          ? 'Sq. Ft.'
          : 'Sq. M.';
      Object jsonData = {
        'displayName': name.value,
        'email': email.value,
        'property_area_unit': propUnit,
        'token': firebaseToken.toString()
      };

      // update jwt current user
      Map<String, dynamic> userDataForUpdate = {
        "displayName": name.value,
        "email": email.value,
        "property_area_unit": propUnit
      };
      await app_instance.utility.updateJwtUser(userDataForUpdate);

      await app_instance.userRepository.submitSettingForm(jsonData);

      emitSuccess(
          successResponse: 'settings.success_msg',
          canSubmitAgain: true,
          isEditing: true);
    } on Exception catch (e) {
      print(e);
      emitFailure(failureResponse: e.toString());
      extraSuccess();
    }
  }

  dynamic uploadProfile() async {
    try {
      String imgUrl = '';
      dynamic firebaseToken = await _auth.currentUser!.getIdToken();
      if (uploadImageUrl.value.isNotEmpty) {
        final minio = Minio(
            endPoint: _s3BucketUrl!,
            accessKey: _s3AccessKey!,
            secretKey: _s3SecretKey!,
            region: _region);
        final d = await getTemporaryDirectory();
        UserModel currentUser = await app_instance.utility.jwtUser();
        dynamic userId = currentUser.id.toString();

        String fileName =
            'IMG_${userId}_${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}.webp';
        final imageData = await FlutterImageCompress.compressAndGetFile(
            uploadImageUrl.value, '${d.path}/file2.webp',
            minHeight: 4000,
            minWidth: 3000,
            quality: 100,
            format: CompressFormat.webp);
        final contentTypeThumb = lookupMimeType(imageData!.path);

        minio.fPutObject(
            _s3Bucket!,
            'assets/profile_images/$userId/$fileName',
            imageData.path,
            {'content-type': '$contentTypeThumb', 'x-amz-acl': 'public-read'});
        imgUrl =
            '${_s3Url!}/fit-in/400x0/assets/profile_images/$userId/$fileName';

        // update jwt current user
        Map<String, dynamic> userDataForUpdate = {
          "photo_url": imgUrl.toString(),
        };
        await app_instance.utility.updateJwtUser(userDataForUpdate);
        // await app_instance.storage.write(key: 'image_url', value: imgUrl);
      }
      String propUnit = propertyAreaUnit.value == 'addproperty.lbl_sqft'
          ? 'Sq. Ft.'
          : 'Sq. M.';
      Object jsonData = {
        'displayName': name.value,
        'email': email.value,
        'property_area_unit': propUnit,
        'photo_url': imgUrl,
        'token': firebaseToken.toString()
      };

      await app_instance.userRepository.submitSettingForm(jsonData);
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  void sendEmail() async {
    UserModel getLoggedInUser = await app_instance.utility.jwtUser();
    try {
      Map<String, Object> jsonEmailData = {
        'user_id': getLoggedInUser.id.toString(),
        'db_type': 'member',
        'token': getLoggedInUser.token.toString()
      };
      dynamic res =
          await app_instance.userRepository.appSendConfirmEmail(jsonEmailData);
      if (res != null && res != false) {
        if (res['message'] == 'Email send successfully') {
          emitSuccess(
              successResponse: 'settings.verification_email_send_successfully',
              canSubmitAgain: true,
              isEditing: true);
        } else {
          emitFailure(
              failureResponse: 'settings.verification_email_not_send'.tr());
          extraSuccess();
        }
      } else {
        emitFailure(failureResponse: 'connection.connectionInterrupted'.tr());
        extraSuccess();
      }
    } on Exception catch (_) {
      emitFailure(failureResponse: 'settings.verification_email_not_send'.tr());
      extraSuccess();
    }
  }

  void extraSuccess() {
    emitSuccess(successResponse: '', canSubmitAgain: true, isEditing: true);
  }
}
