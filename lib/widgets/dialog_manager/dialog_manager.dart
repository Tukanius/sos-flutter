import 'package:flutter/material.dart';
import 'package:sos/main.dart';
import 'package:sos/services/dialog.dart';

import 'components/error_dialog.dart';
import 'components/notification_dialog.dart';
import 'components/success_dialog.dart';

class DialogManager extends StatefulWidget {
  final Widget? child;
  const DialogManager({Key? key, this.child}) : super(key: key);
  @override
  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService? dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    dialogService!.registerGetContextListener(getContext);
    dialogService!.registerSuccessDialogListener(
        SuccessDialog(context: context, dialogService: dialogService).show);
    dialogService!.registerErrorDialogListener(
        ErrorDialog(context: context, dialogService: dialogService).show);
    dialogService!.registerNotification(
        NotificationDialog(context: context, dialogService: dialogService)
            .show);
  }

  BuildContext getContext() {
    return context;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}
