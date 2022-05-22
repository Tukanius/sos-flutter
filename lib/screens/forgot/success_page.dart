import 'package:flutter/material.dart';
import 'package:sos/screens/splash/index.dart';
import 'package:sos/widgets/colors.dart';
import 'package:sos/widgets/custom_button.dart';

class SuccessPageArguments {
  String? title;
  String? message;
  SuccessPageArguments({this.title, this.message});
}

class SuccessPage extends StatefulWidget {
  static const routeName = "/successpage";
  final String? message;
  final String? title;

  const SuccessPage({
    Key? key,
    this.message,
    this.title,
  }) : super(key: key);

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: white,
        title: Text(
          "${widget.title}",
          style: const TextStyle(
            color: dark,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Text("${widget.message}"),
          CustomButton(
            onClick: () {
              Navigator.of(context).pushReplacementNamed(SplashPage.routeName);
            },
          )
        ],
      ),
    );
  }
}
