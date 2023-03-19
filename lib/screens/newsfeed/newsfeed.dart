import 'package:flutter/material.dart';
import 'package:sos/components/Header/index.dart';
import 'package:sos/screens/newsfeed/newsfeed_post_card.dart';

class NewsFeed extends StatefulWidget {
  const NewsFeed({Key? key}) : super(key: key);

  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        bottom: false,
        top: false,
        child: Column(
          children: [
            for (var i = 0; i < 10; i++) NewsFeedPostCard(),
          ],
        ),
      ),
    );
  }
}
