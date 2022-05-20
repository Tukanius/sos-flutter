import 'package:flutter/material.dart';
import 'package:sos/widgets/colors.dart';
import '../../../api/post_api.dart';
import '../../../models/result.dart';
import 'package:after_layout/after_layout.dart';
import '../components/post_card.dart';

class NewPostPage extends StatefulWidget {
  static const routeName = "/newpostpage";

  const NewPostPage({Key? key}) : super(key: key);

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> with AfterLayoutMixin {
  Result? newPost = Result(count: 0, rows: []);
  int page = 1;
  int limit = 1000;

  @override
  void afterFirstLayout(BuildContext context) async {
    await post(page, limit);
  }

  Future<List<dynamic>?> post(int page, int limit) async {
    Filter filter = Filter(postStatus: "NEW");
    Offset offset = Offset(limit: limit, page: page);
    Result res =
        await PostApi().list(ResultArguments(filter: filter, offset: offset));
    setState(() {
      newPost = res;
    });
    return res.rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: const Text(
          "New post",
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
          children: newPost!.rows!
              .map((e) => PostCard(
                    data: e,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
