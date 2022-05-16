import '../models/user.dart';
import '../utils/http_request.dart';

class AuthApi extends HttpRequest {
  Future<User> login(User user) async {
    var res = await post('/auth/login', data: user.toJson(), handler: true);
    return User.fromJson(res as Map<String, dynamic>);
  }

  Future<User> me(bool handler) async {
    var res = await get('/auth/me', handler: handler);
    return User.fromJson(res as Map<String, dynamic>);
  }

  Future<User> register(User user) async {
    var res = await post('/auth/register', data: user.toJson());
    return User.fromJson(res as Map<String, dynamic>);
  }

  Future<User> forgot(User user) async {
    var res = await post('/auth/forgot', data: user);
    return User.fromJson(res);
  }
}
