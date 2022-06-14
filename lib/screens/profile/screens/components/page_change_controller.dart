import 'package:flutter/cupertino.dart';

class PageChangeController extends ChangeNotifier {
  String? value;

  PageChangeController();

  changeVariable(String value) {
    this.value = value;
    notifyListeners();
  }
}
