import 'package:flutter/material.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:sos/models/general.dart';

import '../api/general_api.dart';

class GeneralProvider extends ChangeNotifier {
  BottomDrawerController bottomDrawerController = BottomDrawerController();
  String bottomDrawerType = '';
  String id = '';
  General? general;

  setBottomDrawerSetType(String type, String id) {
    bottomDrawerType = type;
    this.id = id;
    notifyListeners();
  }

  clearBottomDrawer() {
    bottomDrawerType = '';
    id = '';
    notifyListeners();
  }

  init(bool handler) async {
    general = await GeneralApi().init(handler);
    notifyListeners();
  }
}
