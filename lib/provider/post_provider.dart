import 'package:flutter/material.dart';
import 'package:sos/models/post.dart';

import '../api/post_api.dart';

class PostProvider extends ChangeNotifier {
  Post? like;
  bool? isLike;

  getLike(id) async {
    like = await PostApi().like("$id");
    notifyListeners();
  }
}
