import 'package:flutter/material.dart';
import 'package:sos/services/dialog.dart';

import '../dialog_wrapper.dart';

class ErrorDialog {
  final BuildContext? context;
  final DialogService? dialogService;
  final Duration duration = const Duration(milliseconds: 1500);

  ErrorDialog({this.context, this.dialogService});

  void show(String message) {
    showDialog(
      context: context!,
      barrierDismissible: true,
      builder: (context) {
        Future.delayed(duration, () {
          dialogService!.dialogComplete();

          // ignore: unnecessary_null_comparison
          if (context == null) return;
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context).pop(true);
          }
        });

        return DialogWrapper(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 10.0),
              const Center(
                child: Icon(
                  Icons.error,
                  size: 65.0,
                  // color: red,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        );
      },
    );
  }
}
