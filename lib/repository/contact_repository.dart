import 'dart:async';
import 'repository.dart';

class ContactRepository extends Repository {
  Future<dynamic> sendContact(jsonData) async {
    final resultData =
        await requestPOST(path: 'app_send_contact_email', parameters: jsonData);
    return resultData;
  }

  Future<dynamic> checkVersion(jsonData) async {
    final resultData =
        await requestPOST(path: 'checkVersion', parameters: jsonData);
    return resultData;
  }
}
