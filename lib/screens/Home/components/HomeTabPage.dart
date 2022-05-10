import 'package:flutter/material.dart';

class HomeTabPage extends StatefulWidget {
  HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: const [
            TextField(
              decoration: InputDecoration(
                filled: true,
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
