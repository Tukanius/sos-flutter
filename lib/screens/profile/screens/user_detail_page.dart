import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sos/models/user.dart';
import 'package:sos/screens/profile/components/upload_avatar.dart';
import 'package:sos/screens/profile/components/user_detail_form.dart';
import '../../../provider/user_provider.dart';
import '../../../widgets/colors.dart';

class UserDetailPage extends StatefulWidget {
  static const routeName = "/userdetailpage";

  const UserDetailPage({Key? key}) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  User user = User();
  bool? isLoading = false;

  onChange(image) async {
    setState(() {
      user.avatar = image;
    });
  }

  onSubmit() async {
    final form = user.fbKey.currentState!;
    if (form.saveAndValidate()) {
      user = User.fromJson(form.value);
      try {
        await Provider.of<UserProvider>(context, listen: false).update(user);
        await Provider.of<UserProvider>(context, listen: false).me(true);
        Navigator.of(context).pop();
      } catch (err) {
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: dark),
        backgroundColor: primaryColor,
        elevation: 0.5,
        title: Text(
          user.username.toString(),
          style: const TextStyle(color: dark, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              UploadAvatar(user: user, onChange: onChange),
              Text("${user.firstName}"),
              const SizedBox(
                height: 20,
              ),
              UserDetailForm(
                user: user,
                onSubmit: onSubmit,
                isLoading: isLoading,
              )
            ],
          ),
        ),
      ),
    );
  }
}
