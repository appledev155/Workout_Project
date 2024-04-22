import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import "dart:developer";
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class Repository {
  final _host = dotenv.env['HOST'];
  final _contextRoot = dotenv.env['CONTEXTROOT'];
  Map<String, String> get _headers => {'Accept': 'application/json'};

  Uri getURL(String contextPath, Map<String, dynamic>? queryParameters) {
    Uri uri;
    if (dotenv.env['HTTP_PROTOCOL'] == "HTTPS") {
      uri = Uri.https(_host!, contextPath, queryParameters);
    } else {
      uri = Uri.http(_host!, contextPath, queryParameters);
    }
    return uri;
  }

  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  // Account Upgrade Api
  Future<dynamic> accountUpgrade(jsonData) async {
    final resultData = await requestPOST(
        path: 'upgrade_account_request', parameters: jsonData);
    return resultData;
  }

  Future<dynamic> checkAccountVerification(jsonData) async {
    final result =
        await requestGET(path: 'check_upgrade_request', parameters: jsonData);
    return result;
  }

  Future<dynamic> checkAccountApproveRequest(
      userID, Map<String, Object> jsonData) async {
    final result = await requestGET(
        path: 'is_approve_request/$userID', parameters: jsonData);
    return result;
  }

  Future<Map<String, dynamic>> requestGETList(
      {String? path, Map<String, Object>? parameters}) async {
    bool? chk = parameters!.containsKey("token") &&
        parameters['token'].toString().length > 10;
    var headersData = _headers;
    dynamic res = parameters;
    if (chk) {
      headersData['x-access-token'] = 'Bearer ${parameters['token']}';
    }

    final uri = getURL('$_contextRoot$path', res);
    final results = await http.get(uri, headers: headersData);
    if (results.body.isNotEmpty) {
      var jsonObject = json.decode(results.body) as Map<String, dynamic>;

      return jsonObject;
    } else {
      return {};
    }
  }

  Future<List> requestLocationGET(
      {@required String? path, Map<String, Object>? parameters}) async {
    var headersData = _headers;

    final uri = getURL('$_contextRoot$path', parameters);
    String url = uri.toString();
    String url1 = url.replaceAll('+%E2%80%8E', '%20');

    final results = await http
        .get(Uri.parse(url1), headers: headersData)
        .timeout(const Duration(seconds: 10));

    if (results.body.isNotEmpty) {
      final jsonObject = json.decode(results.body);
      return jsonObject;
    } else {
      return [];
    }
  }

  Future<List> locationPost(dynamic loc, String locationId,
      {@required String? path, Map<String, Object>? parameters}) async {
    var headersData = _headers;
    var params = "query=${parameters!['keyword']}&offset=0&length=10";
    if (locationId != '0') {
      params =
          "$params&numericFilters=(parent_id=$locationId,id=$locationId,confirm_status=1)";
    } else {
      params = "$params&numericFilters=(confirm_status=1)";
    }

    Object jsonData = {
      "requests": [
        {"indexName": parameters['indexName'], "params": params}
      ]
    };
    final results = await http
        .post(Uri.parse(loc), headers: headersData, body: jsonEncode(jsonData))
        .timeout(const Duration(seconds: 10));
    if (results.body.isNotEmpty) {
      final jsonObject = json.decode(results.body);
      return jsonObject['results'][0]['hits'];
    } else {
      return [];
    }
  }

  Future<Map> requestPOST(
      {required String? path, Map<String, Object>? parameters}) async {
    try {
      bool chk = parameters!.containsKey("token") &&
          parameters['token'].toString().length > 10;
      var headersData = _headers;
      if (chk) {
        headersData['Authorization'] = 'Bearer ${parameters['token']}';
      }

      parameters.remove('token');
      dynamic postData = parameters;

      final uri = getURL('$_contextRoot$path', {});
      // if (kDebugMode) {
      //   print('Post $uri Header $headersData  Params $postData');
      // }

      final results = await http
          .post(uri, headers: headersData, body: postData)
          .timeout(const Duration(seconds: 100));

      if (results.body.isNotEmpty) {
        final jsonObject = json.decode(results.body);
        return jsonObject;
      } else {
        return {};
      }
    } catch (e, _) {
      print('POST Api Error  $e - $_contextRoot$path');
      print(_);
    }
    return {};
  }

  Future<dynamic> requestGET(
      {required String? path, Map<String, Object>? parameters}) async {
    bool token = parameters!.containsKey("token") &&
        parameters['token'].toString().length > 10;
    var headersData = _headers;
    if (token) {
      headersData['Authorization'] = 'Bearer ${parameters['token']}';
    }

    parameters.remove('token');
    dynamic getData = parameters;

    final uri = getURL('$_contextRoot$path', getData);
    // if (kDebugMode) {
    //   print('GET $uri Header $headersData  Params $getData');
    // }

    try {
      final results = await http
          .get(uri, headers: headersData)
          .timeout(Duration(seconds: app_instance.appConfig.algoliaTimeOut));
      if (results.body.isNotEmpty) {
        final jsonObject = json.decode(results.body);
        return jsonObject;
      } else {
        return {};
      }
    } catch (e, _) {
      print('GET Api Error  $e - $_contextRoot$path');
      print(_);
    }
    return {};
  }

  Future<List> searchAlgoliaPost(dynamic loc, String? indexName,
      {Map<String, Object>? parameters,
      bool isSearchAgentListing = false}) async {
    dynamic data = parameters!['search_cond'].toString();

    dynamic searchCond = json.decode(data);

    var headersData = _headers;

    var page = int.parse(parameters['page'].toString()) - 1;
    dynamic maxprice = searchCond['maxprice'] ?? '';
    if (maxprice == 'Any' || maxprice == null) maxprice = '';

    dynamic maxarea = searchCond['maxarea'] ?? '';
    if (maxarea == 'Any' || maxarea == null) maxarea = '';

    dynamic minprice = searchCond['minprice'] ?? '';
    if (minprice == 'Any' || minprice == null) minprice = '';

    dynamic minarea = searchCond['minarea'] ?? '';
    if (minarea == 'Any' || minarea == null) minarea = '';

    dynamic propertyStatus = searchCond['property_type_option'] ?? "";
    dynamic buyrentType = searchCond['buyrent_type'] ?? '';

    var params;

    if (isSearchAgentListing == true) {
      params =
          'numericFilters=status=1,is_static_page=1,agency_id!=0,is_agent!=0';
    } else {
      params = 'numericFilters=status=1,is_static_page=1';
    }

    if (searchCond['property_type_id'].toString() != '') {
      params = "$params,property_type_id=${searchCond['property_type_id']}";
    }
    if (searchCond['property_type'] != '') {
      dynamic propertyType =
          (searchCond['property_type'] == 'residential') ? 1 : 2;
      params = "$params,property_type=$propertyType";
    }

    if (propertyStatus != '') {
      propertyStatus = int.parse(propertyStatus);
      if (buyrentType == 'Sell') {
        int num = 0;
        if (propertyStatus != 0) {
          num = 1;
          params = "$params,property_status!=0";
        } else {
          if (propertyStatus == 0) {
            params = "$params,property_status=$num";
          }
        }
      }
    }

    if (minprice != '' && maxprice != '') {
      minprice = int.parse(minprice) - 1;
      maxprice = int.parse(maxprice) + 1;
      if (minprice > -2 && maxprice > -1) {
        params = "$params,price>$minprice,price<$maxprice";
      }
    } else if (minprice == '' && maxprice != '') {
      maxprice = int.parse(maxprice) + 1;
      if (maxprice > -1) {
        params = "$params,price<$maxprice";
      }
    } else if (minprice != '' && maxprice == '') {
      minprice = int.parse(minprice) - 1;
      if (minprice > -2) {
        params = "$params,price>$minprice";
      }
    }

    var propertyAreaSearch = 'property_area_sqft';
    switch (searchCond['property_area_unit']) {
      case 'Sq. Ft.':
        {
          propertyAreaSearch = 'property_area_sqft';
          break;
        }
      case 'Sq. M.':
        {
          propertyAreaSearch = 'property_area_sqm';
          break;
        }
      case 'Sq. Yd.':
        {
          propertyAreaSearch = 'property_area_sqyd';
          break;
        }
    }

    if (minarea != '' && maxarea != '') {
      minarea = int.parse(minarea) - 1;
      maxarea = int.parse(maxarea) + 1;
      if (minarea > -2 && maxarea > -1) {
        params =
            "$params,$propertyAreaSearch>$minarea,$propertyAreaSearch<$maxarea";
      }
    } else if (minarea == '' && maxarea != '') {
      maxarea = int.parse(maxarea) + 1;
      if (maxarea > -1) {
        params = "$params,$propertyAreaSearch<$maxarea";
      }
    } else if (minarea != '' && maxarea == '') {
      minarea = int.parse(minarea) - 1;
      if (minarea > -2) {
        params = "$params,$propertyAreaSearch>$minarea";
      }
    }

    dynamic bedrooms = searchCond['bedrooms'].toString().replaceAll("+", "");
    if (bedrooms != '') {
      bedrooms = int.parse(bedrooms);
      params = "$params,(bedrooms=-1,bedrooms=$bedrooms)";
    }
    dynamic toilet = searchCond['toilet'].toString().replaceAll("+", "");
    if (toilet != '') {
      toilet = int.parse(toilet);
      params = "$params,(toilet=-1,toilet=$toilet)";
    }
    dynamic buildYear = searchCond['year_built'];
    if (buildYear != '') {
      buildYear = int.parse(buildYear);
      params = "$params,(build_year=-1,build_year=$buildYear)";
    }

    dynamic priceType = searchCond['price_type'];
    if (priceType != '' && buyrentType == 'Rent') {
      priceType = int.parse(priceType);
      if (priceType > 0) {
        params = "$params,(price_type=0,price_type=$priceType)";
      }
    }

    var amenities = searchCond['amenities'];
    if (amenities != '') {
      String userInput = amenities.toString();
      userInput = userInput.substring(0, userInput.length - 1);
      dynamic amenityString =
          'amenitiesArg:\'${userInput.replaceAll('_', '\' OR amenitiesArg:\'')}\'';
      //userInput.split("_");
      if (amenityString != '') params = "$params&filters=$amenityString";
    }
    int pagePerCount =
        int.parse(app_instance.appConfig.numberOfRecords.toString());

    // int.parse(dotenv.env['HITPERPAGECOUNT'].toString());
    params =
        "$params&facetFilters=purpose:$buyrentType&page=$page&hitsPerPage=$pagePerCount&query=${searchCond['locationEnglish']}";

    //"sort_by":"newest" sort_by: priceLH  sort_by: priceHL
    if (searchCond['sort_by'] == 'priceLH') {
      indexName = 'dev_property_price_asc';
    }
    if (searchCond['sort_by'] == 'priceHL') {
      indexName = 'dev_property_price_desc';
    }

    Object jsonData = {
      "requests": [
        {"indexName": indexName, "params": params}
      ]
    };

    // print("*****search");
    // print(loc.toString());
    // print(jsonData.toString());
    // print("*****search");

    final results = await http
        .post(Uri.parse(loc), headers: headersData, body: jsonEncode(jsonData))
        .timeout(Duration(seconds: app_instance.appConfig.algoliaTimeOut));
    if (results.body.isNotEmpty) {
      final jsonObject = json.decode(results.body);

      return jsonObject['results'];
    } else {
      return [];
    }
  }
}
