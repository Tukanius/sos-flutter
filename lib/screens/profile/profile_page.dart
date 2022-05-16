import 'package:flutter/material.dart';
import 'package:sos/provider/user_provider.dart';
import 'package:sos/screens/Splash/index.dart';
import 'package:sos/widgets/colors.dart';
import 'package:provider/provider.dart';
import 'package:sos/widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = "/profilepage";

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  logout() async {
    await Provider.of<UserProvider>(context, listen: false).logout();
    Navigator.of(context).pushReplacementNamed(SplashPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: dark),
        backgroundColor: primaryColor,
        elevation: 0.5,
        title: const Text(
          "Profile",
          style: TextStyle(color: dark, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: CustomButton(
          labelText: "Гарах",
          color: red,
          onClick: () async {
            logout();
          },
        ),
      ),
    );
  }
}
