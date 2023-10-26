import 'dart:convert';
import 'dart:io';

import 'package:efood_table_booking/data/model/response/error_response.dart';
import 'package:efood_table_booking/util/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient extends GetxService {
  final String? appBaseUrl;
  final SharedPreferences sharedPreferences;
  static const String noInternetMessage =
      'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;

  String? token;
  late Map<String, String> _mainHeaders;

  ApiClient({this.appBaseUrl, required this.sharedPreferences}) {
    token = sharedPreferences.getString(AppConstants.token);
    debugPrint('Token: $token');
    updateHeader();
  }

  void updateHeader() {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'branch-id': '${sharedPreferences.getInt(AppConstants.branch)}',
      'Authorization':
          'Bearer ${sharedPreferences.getString(AppConstants.token)}'
    };
  }

  Future<Response> getData(String uri,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      debugPrint(
          '====> API Call: $uri\n header: $_mainHeaders \n Token: $token');

      http.Response response0 = await http
          .get(
            Uri.parse(appBaseUrl! + uri),
            headers: headers ?? _mainHeaders,
            
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      Response response = handleResponse(response0);
      debugPrint(
          '====> API Response: [${response.statusCode}] $uri\n${response.body}');

      return response;
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(String? uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: ${appBaseUrl! + uri!}\nToken: $token');
      debugPrint('====> API Body: $body');

      http.Response response = await http
          .post(
            Uri.parse(appBaseUrl! + uri),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartData(
      String? uri, Map<String, String> body, List<MultipartBody> multipartBody,
      {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nToken: $token');
      debugPrint('====> API Body: $body');

      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(appBaseUrl! + uri!));
      request.headers.addAll(headers ?? _mainHeaders);
      for (MultipartBody multipart in multipartBody) {
        if (kIsWeb) {
          Uint8List list = await multipart.file.readAsBytes();
          http.MultipartFile part = http.MultipartFile(
            multipart.key,
            multipart.file.readAsBytes().asStream(),
            list.length,
            filename: multipart.file.path,
          );
          request.files.add(part);
        } else {
          File file = File(multipart.file.path);
          request.files.add(http.MultipartFile(
            multipart.key,
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: file.path.split('/').last,
          ));
        }
      }
      request.fields.addAll(body);
      http.Response response =
          await http.Response.fromStream(await request.send());
      return handleResponse(response);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(String? uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nToken: $token');
      debugPrint('====> API Body: $body');

      http.Response response = await http
          .put(
            Uri.parse(appBaseUrl! + uri!),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(String? uri,
      {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nToken: $token');

      http.Response response = await http
          .delete(
            Uri.parse(appBaseUrl! + uri!),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Response handleResponse(http.Response response) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      debugPrint('handleResponse $e');
    }
    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      if (response0.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(response0.body);
        response0 = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: errorResponse.errors?[0].message);
      } else if (response0.body.toString().startsWith('{message')) {
        response0 = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: response0.body['message']);
      }
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = const Response(statusCode: 0, statusText: noInternetMessage);
    }
    return response0;
  }
}

class MultipartBody {
  String key;
  XFile file;

  MultipartBody(this.key, this.file);
}
