import 'package:flutter/material.dart';
import 'package:sos/models/post.dart';

import '../api/post_api.dart';

class PostProvider extends ChangeNotifier {
  Post? like;

  getLike(id) async {
    like = await PostApi().like("$id");
    notifyListeners();
  }
}
