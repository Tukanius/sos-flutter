import 'package:sos/models/about.dart';

import '../models/general.dart';
import '../utils/http_request.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class GeneralApi extends HttpRequest {
  Future<General> init(bool handler) async {
    var res = await get('/general/init', handler: handler);
    return General.fromJson(res as Map<String, dynamic>);
  }

  Future<String?> upload(XFile file) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });
    var res = await post('/general/upload/image', data: formData);

    return General.fromJson(res).url;
  }

  Future<About> getAbout() async {
    var res = await get('/about');
    return About.fromJson(res as Map<String, dynamic>);
  }
}
