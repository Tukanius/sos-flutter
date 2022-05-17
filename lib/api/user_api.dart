import 'dart:async';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user.dart';
import '../utils/http_request.dart';

class UserApi extends HttpRequest {
  Future<String?> uploadAvatar(XFile file) async {
    String fileName = file.path.split('/').last;

    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    var res = await post('/user/avatar', data: formData);
    return User.fromJson(res).avatar;
  }

  Future<User> changePassword(User user) async {
    var data = await post('/user/password', data: user.toJson());
    User res = User.fromJson(data);
    return res;
  }
}
