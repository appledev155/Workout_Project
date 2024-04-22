import 'dart:async';

import 'package:nexmo_verify/basemodel.dart';
import 'package:nexmo_verify/model/nexmo_response.dart';
import 'package:nexmo_verify/networ_util.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NexmoSmsVerificationUtil {
  NexmoResponseListener? _nexmoResponseListener;

  String? apiKey;

  String? apiSecret;

  String? requestId;

  NetworkUtil _netUtil = NetworkUtil();
  final _storage = const FlutterSecureStorage();

  static NexmoSmsVerificationUtil _instance =
      NexmoSmsVerificationUtil.internal();

  NexmoSmsVerificationUtil.internal();

  factory NexmoSmsVerificationUtil() => _instance;

  initNexmo(String apiKey, String apiSecret) {
    this.apiKey = apiKey;
    this.apiSecret = apiSecret;
  }

  Future<BaseModel> sendOtp(String number, String brand, int length) {
    return _netUtil.post(
      NetworkUtil.baseURL +
          '/verify/json?api_key=$apiKey' +
          "&api_secret=$apiSecret" +
          "&code_length=$length" +
          "&number=$number" +
          "&brand=$brand" +
          "&cmd=trigger_next_event" +
          "&workflow_id=5",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    ).then((dynamic res) async {
      var response = new BaseModel.parse(res);
      response.status = 200;
      this.requestId = response.nexmoResponse!.requestId;
      await _storage.write(
          key: "nexmoRequestId",
          value: response.nexmoResponse!.requestId.toString());
      return response;
    });
  }

  Future<BaseModel> resentOtp() {
    return _netUtil.post(
      NetworkUtil.baseURL +
          '/verify/control/json?api_key=$apiKey' +
          "&api_secret=$apiSecret" +
          "&request_id=$requestId" +
          "&cmd=trigger_next_event" +
          "&workflow_id=5",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    ).then((dynamic res) {
      var response = new BaseModel.parse(res);
      response.status = 200;
      return response;
    });
  }

  Future<BaseModel> verifyOtp(String otp) {
    return _netUtil.post(
      NetworkUtil.baseURL +
          '/verify/check/json?api_key=$apiKey' +
          "&api_secret=$apiSecret" +
          "&request_id=$requestId" +
          "&code=$otp",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    ).then((dynamic res) {
      var response = new BaseModel.parse(res);
      response.status = 200;
      return response;
    });
  }

  Future<BaseModel> cancelOldRequest() {
    return _netUtil.post(
      NetworkUtil.baseURL +
          '/verify/control/json?api_key=$apiKey' +
          "&api_secret=$apiSecret" +
          "&request_id=$requestId" +
          "&cmd=cancel",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    ).then((dynamic res) {
      var response = new BaseModel.parse(res);
      response.status = 200;
      return response;
    });
  }

  void addCallback(NexmoResponseListener nexmoResponseListener) {
    _nexmoResponseListener = nexmoResponseListener;
  }
}

abstract class NexmoResponseListener {
  void nexmoSuccess(NexmoResponse nexmoResponse) {}

  void nexmoError() {}
}
