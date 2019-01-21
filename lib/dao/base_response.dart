import 'dart:convert';

import 'package:http/http.dart';

class BaseResponse<T> {
  bool success;
  String message;
  T data;

  // BaseResponse(
  //   this.success,
  //   this.message,
  //   this.data,
  // );

  BaseResponse<T> setData<T>(Response response, T data) {
    Map<String, dynamic> parsingJson = json.decode(response.body);
    var successful = parsingJson['successful'];
    var message = parsingJson['message'];
    return BaseResponse()
      ..success = successful
      ..message = message
      ..data = data;
  }
}
