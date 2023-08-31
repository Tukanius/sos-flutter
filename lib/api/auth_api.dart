import '../models/user.dart';
import '../provider/user_provider.dart';
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

  Future<User> resend() async {
    var res = await get('/otp');
    return User.fromJson(res);
  }

  Future<User> forgot(User user) async {
    var res = await post('/auth/forgot', data: user.toJson());
    return User.fromJson(res);
  }

  Future<User> otpSocial(User user) async {
    var res = await post('/otp/social', data: user.toJson());
    return User.fromJson(res);
  }

  update(User user) async {
    await put('/user', data: user.toJson());
  }

  Future<User> verify(User user) async {
    var res = await post('/otp/verify', data: user.toJson(), handler: true);
    return User.fromJson(res as Map<String, dynamic>);
  }

  Future<User> otpPassword(User user) async {
    var res = await post('/otp/password', data: user.toJson(), handler: true);
    return User.fromJson(res as Map<String, dynamic>);
  }

  Future<void> socialLogin(User data) async {
    var res = await post('/auth/social', data: data.toJson());
    UserProvider().setAccessToken(res["accessToken"]);
    UserProvider().setSessionScope(res["sessionScope"]);
  }
}
