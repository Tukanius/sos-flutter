import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sos/provider/user_provider.dart';
import 'package:sos/services/dialog.dart';
import 'http_handler.dart';
import '../main.dart';

class HttpRequest {
  static const host = 'https://ersdel.e-darkhan.mn';
  // static const host = 'http://192.168.1.17:6002';

  // static const s3host = 'http://192.168.1.17:6002/s3';

  static const s3host = 'https://ersdel.e-darkhan.mn/s3';
  static const version = '/web';

  static const uri = host;

  Dio dio = Dio();

  Future<dynamic> request(String api, String method, dynamic data,
      {bool handler = true, bool approve = false}) async {
    Response? response;
    //final String uri = '$host:$port/$version$api';
    final String uri = '$host$version$api';

    debugPrint(uri);

    debugPrint('+++++++++++++++++++++++++++++++++++++++++++++++++++');
    debugPrint('handler: ' + handler.toString());
    debugPrint('+++++++++++++++++++++++++++++++++++++++++++++++++++ ');

    try {
      Directory dir = await getTemporaryDirectory();
      CookieJar cookieJar =
          PersistCookieJar(storage: FileStorage(dir.path), ignoreExpires: true);

      dio.interceptors.add(CookieManager(cookieJar));

      var token = await UserProvider.getAccessToken();

      var deviceToken = await UserProvider.getDeviceToken();

      debugPrint(
          '++++++++++++++++++++++deviceToken+++++++++++++++++++++++++++++ ');
      debugPrint(deviceToken);
      debugPrint(
          '+++++++++++++++++++++++deviceToken++++++++++++++++++++++++++++ ');

      dio.options.headers = {
        'authorization': 'Bearer $token',
        'device-token': '$deviceToken',
        'device_type': 'MOS',
        'device_imei': 'test-imei',
        'device_info': 'iphone 13'
      };
    } catch (err) {
      debugPrint(err.toString());
    }

    if (method != 'GET') {
      debugPrint('body: $data');
    }

    try {
      switch (method) {
        case 'GET':
          {
            response = await dio.get(
              uri,
              queryParameters: data,
            );
            break;
          }
        case 'POST':
          {
            response = await dio.post(uri, data: data);
            break;
          }
        case 'PUT':
          {
            response = await dio.put(uri, data: data);
            break;
          }
        case 'DELETE':
          {
            response = await dio.delete(uri, data: data);
            break;
          }
      }

      return HttpHandler(statusCode: response?.statusCode).handle(response);
    } on DioError catch (ex) {
      // try {
      //   result = await _connectivity.checkConnectivity();
      //   if (result == ConnectivityResult.none) {
      //     MyApp.dialogService!
      //         .showInternetErrorDialog("No internet connection");
      //     return null;
      //   }
      // } on PlatformException catch (e) {
      //   debugPrint(e.toString());
      // }

      HttpHandler? error =
          HttpHandler(statusCode: ex.response?.statusCode).handle(ex.response);

      if (handler == true && error!.message != null) {
        final DialogService dialogService = locator<DialogService>();
        dialogService.showErrorDialog(error.message.toString());
      }

      throw error!;
    }
  }

  Future<dynamic> get(String url, {dynamic data, bool handler = true}) async {
    try {
      return await request(url, 'GET', data, handler: handler);
    } catch (e) {
      debugPrint("GET =>" + e.toString());
      rethrow;
    }
  }

  Future<dynamic> post(String url,
      {dynamic data, bool handler = true, bool approve = false}) async {
    try {
      return await request(
        url,
        'POST',
        data,
        handler: handler,
        approve: approve,
      );
    } catch (e) {
      debugPrint("POST =>" + e.toString());
      rethrow;
    }
  }

  Future<dynamic> put(String url, {dynamic data, bool handler = true}) async {
    try {
      return await request(url, 'PUT', data, handler: handler);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<dynamic> del(String url, {dynamic data, bool handler = true}) async {
    return await request(url, 'DELETE', data, handler: handler);
  }
}
