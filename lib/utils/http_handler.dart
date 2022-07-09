// import 'package:tw_app/screens/forgot/forgot_page.dart';

import 'package:flutter/cupertino.dart';

class HttpHandler {
  int? statusCode;
  String? message;
  String? code;

  HttpHandler({this.statusCode, this.message, this.code});

  parseMessage(dynamic data) {
    String? message;

    // debugPrint("% % % % % % % % % % % % % % % % % % % % % % % % % % % % %");
    // debugPrint(data.runtimeType == Map<String, dynamic>().runtimeType);
    // debugPrint("% % % % % % % % % % % % % % % % % % % % % % % % % % % % %");

    if (data.runtimeType == <String, dynamic>{}.runtimeType) {
      Map<String, dynamic> json = data as Map<String, dynamic>;

      message = json['message'] as String?;
    } else {
      message = data as String;
    }

    return message;
  }

  handle(response) {
    debugPrint(
        '+++++++++++++++++++++++++API HANDLER++++++++++++++++++++++++++');
    debugPrint('HttpHandler: ' +
        response.toString() +
        ", " +
        statusCode.toString() +
        ' dataType:${response?.data?.runtimeType.toString()}');
    debugPrint(
        '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');

    dynamic data = <String, dynamic>{};

    if (response?.data?.runtimeType.toString() != "".runtimeType.toString()) {
      data = response.data;
    }

    switch (statusCode) {
      case 200:
      case 304:
        return data;
      // case 401:
      //   locator<DialogService>().showErrorDialogListener("Нэвтэрнэ үү");
      //   break;
      default:
        HttpHandler error = HttpHandler(
            statusCode: statusCode,
            code: data['code'] as String?,
            message: data['message'] as String?);

        return error;
    }
  }
}
