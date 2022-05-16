import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/auth.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  final DefaultCacheManager cacheManager = DefaultCacheManager();

  User user = User();

  Future<User?> me(bool handler) async {
    user = await AuthApi().me(handler);
    notifyListeners();
    return user;
  }

  login(User data) async {
    User res = await AuthApi().login(data);
    await setAccessToken(res.accessToken);
  }

  register(User data) async {
    User res = await AuthApi().register(data);
    await setAccessToken(res.accessToken);
  }

  logout() async {
    user = User();
    clearAccessToken();
    notifyListeners();
  }

  forgot(User data) async {
    User res = await AuthApi().forgot(data);
    await setAccessToken(res.accessToken);
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
}
