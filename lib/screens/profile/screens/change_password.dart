import 'package:flutter/material.dart';
import 'package:sos/models/user.dart';
import 'package:sos/screens/profile/components/change_password_form.dart';
import 'package:provider/provider.dart';
import 'package:sos/widgets/colors.dart';

import '../../../provider/user_provider.dart';
import '../../../utils/http_handler.dart';

class ChangePasswordPage extends StatefulWidget {
  static const routeName = "/changepasswordpage";

  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  User user = User();
  bool isLoading = false;

  onSubmit() async {
    final form = user.fbKey.currentState;
    if (user.fbKey.currentState!.saveAndValidate()) {
      if (form?.saveAndValidate() ?? false) {
        setState(() {
          isLoading = true;
        });
        try {
          User send = User.fromJson(form!.value);
          send.oldPassword = user.oldPasswordController.text;
          await Provider.of<UserProvider>(context, listen: false)
              .changePassword(send);
          Navigator.of(context).pop();
          setState(
            () {
              isLoading = false;
            },
          );
        } on HttpHandler catch (err) {
          debugPrint(err.toString());
          setState(() {
            isLoading = false;
          });
        }
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: dark),
        backgroundColor: primaryColor,
        elevation: 0.5,
        title: const Text(
          "Нууц үг солих",
          style: TextStyle(color: dark, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              ChangePasswordForm(
                user: user,
                onSubmit: onSubmit,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
