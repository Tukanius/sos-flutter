import 'package:flutter/cupertino.dart';

class CustomController extends ChangeNotifier {
  bool? value;

  CustomController();

  changeVariable(bool value) {
    this.value = value;
    notifyListeners();
  }
}
