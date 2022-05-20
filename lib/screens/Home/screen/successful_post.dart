import 'package:flutter/material.dart';
import 'package:sos/widgets/colors.dart';

class SuccessfulPostPage extends StatefulWidget {
  static const routeName = "/successfulpostpage";

  const SuccessfulPostPage({Key? key}) : super(key: key);

  @override
  State<SuccessfulPostPage> createState() => _SuccessfulPostPageState();
}

class _SuccessfulPostPageState extends State<SuccessfulPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Successful post",
          style: TextStyle(fontSize: 16, color: dark),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.close,
                color: dark,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
