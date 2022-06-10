import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:sos/widgets/colors.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          Lottie.asset('assets/notfound.json', height: 150, repeat: true),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Мэдээлэл олдсонгүй",
            style: TextStyle(
              color: dark,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
