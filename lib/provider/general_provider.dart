import 'package:flutter/material.dart';
import 'package:bottom_drawer/bottom_drawer.dart';

class GeneralProvider extends ChangeNotifier {
  BottomDrawerController bottomDrawerController = BottomDrawerController();
  String bottomDrawerType = '';

  setBottomDrawerSetType(String type) {
    bottomDrawerType = type;
    notifyListeners();
  }
}
