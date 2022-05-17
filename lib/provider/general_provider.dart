import 'package:flutter/material.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:sos/models/general.dart';

import '../api/general_api.dart';

class GeneralProvider extends ChangeNotifier {
  BottomDrawerController bottomDrawerController = BottomDrawerController();
  String bottomDrawerType = '';
  String id = '';
  General? general;
  bool? drawerIsOpen = false;

  setBottomDrawerSetType(String type, String id) async {
    drawerIsOpen = true;
    bottomDrawerType = type;
    this.id = id;
    bottomDrawerController.open();
    notifyListeners();
  }

  closeBottomDrawer(bool action) {
    drawerIsOpen = false;
    bottomDrawerType = '';
    id = '';
    notifyListeners();
  }

  init(bool handler) async {
    general = await GeneralApi().init(handler);
    notifyListeners();
  }
}
