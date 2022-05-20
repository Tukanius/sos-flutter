import 'package:flutter/material.dart';
import 'package:sos/widgets/colors.dart';

class PendingPostPage extends StatefulWidget {
  static const routeName = "/pendingpostpage";

  const PendingPostPage({Key? key}) : super(key: key);

  @override
  State<PendingPostPage> createState() => _PendingPostPageState();
}

class _PendingPostPageState extends State<PendingPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Pending post",
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
