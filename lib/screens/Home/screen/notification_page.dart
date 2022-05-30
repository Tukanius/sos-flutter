import 'package:flutter/material.dart';
import 'package:sos/widgets/colors.dart';

class NotificationPage extends StatefulWidget {
  static const routeName = "/notificationpage";
  const NotificationPage({Key? key}) : super(key: key);
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(color: dark),
          backgroundColor: primaryColor,
          title: const Text(
            "Notify",
            style: TextStyle(
              color: dark,
              fontSize: 16,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: red,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
