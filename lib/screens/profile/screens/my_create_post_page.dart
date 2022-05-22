import 'package:flutter/material.dart';

class MyCreatePostPage extends StatefulWidget {
  static const routeName = "/mycreatepost";

  const MyCreatePostPage({Key? key}) : super(key: key);

  @override
  State<MyCreatePostPage> createState() => _MyCreatePostPageState();
}

class _MyCreatePostPageState extends State<MyCreatePostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}
