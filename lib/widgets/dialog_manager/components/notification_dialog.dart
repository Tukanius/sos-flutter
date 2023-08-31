import 'package:flutter/material.dart';
import 'package:sos/services/dialog.dart';

class NotificationDialog {
  final BuildContext? context;
  final DialogService? dialogService;

  NotificationDialog({this.context, this.dialogService});

  void show(ListTile listTile, {int? duration}) {}
}
