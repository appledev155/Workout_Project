import 'dart:async';
import 'dart:convert';

import 'package:nexmo_verify/app_exception.dart';
import 'package:http/http.dart' as http;

class NetworkUtil {
  static final baseURL = "https://api.nexmo.com";

  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url,
      {required Map<String, String> headers, encoding}) {
    return http
        .get(
      Uri.parse(url),
      headers: headers,
    )
        .then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
      print("API Response from GET: " + res);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new AppException(res, statusCode);
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url,
      {required Map<String, String> headers, body, encoding}) {
    return http
        .post(Uri.parse(url), body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
      print("API Response from POST: " + res);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new AppException(res, statusCode);
      }
      return _decoder.convert(res);
    });
  }
}
