import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/auth_api.dart';
import '../api/user_api.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  final DefaultCacheManager cacheManager = DefaultCacheManager();

  User user = User();

  me(bool handler) async {
    user = await AuthApi().me(handler);
    notifyListeners();
  }

  login(User data) async {
    User res = await AuthApi().login(data);
    await setAccessToken(res.accessToken);
  }

  setUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("USERNAME", username);
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString("USERNAME");
    return username;
  }

  setDeviceToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("DEVICE_TOKEN", token);
  }

  static Future<String?> getDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("DEVICE_TOKEN");
    return token;
  }

  register(User data) async {
    User res = await AuthApi().register(data);
    await setAccessToken(res.accessToken);
    return res;
  }

  logout() async {
    user = User();
    clearAccessToken();
    notifyListeners();
  }

  forgot(User data) async {
    User res = await AuthApi().forgot(data);
    await setAccessToken(res.accessToken);
    return res;
  }

  setAccessToken(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (token != null) prefs.setString("ACCESS_TOKEN", token);
  }

  clearAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("ACCESS_TOKEN");
  }

  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("ACCESS_TOKEN");

    return token;
  }

  update(User user) async {
    await AuthApi().update(user);
  }

  changePassword(User user) async {
    User res = await UserApi().changePassword(user);
    await setAccessToken(res.accessToken);
  }

  otpPassword(User user) async {
    User res = await AuthApi().otpPassword(user);
    await setAccessToken(res.accessToken);
  }

  verifyOtp(User data) async {
    User res = await AuthApi().verify(data);
    await setAccessToken(res.accessToken);
  }
}
