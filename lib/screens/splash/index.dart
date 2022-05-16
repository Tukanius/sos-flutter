import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:sos/screens/Home/index.dart';
import 'package:provider/provider.dart';
import '../../provider/general_provider.dart';
import '../../provider/user_provider.dart';

class SplashPage extends StatefulWidget {
  static const routeName = "/SplashPage";
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with AfterLayoutMixin<SplashPage> {
  @override
  void afterFirstLayout(BuildContext context) async {
    try {
      await Provider.of<GeneralProvider>(context, listen: false).init(false);
      await Provider.of<UserProvider>(context, listen: false).me(false);
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    } catch (e) {
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(),
    );
  }
}
