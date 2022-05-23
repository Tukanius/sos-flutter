import 'package:flutter/material.dart';
import 'package:sos/models/post.dart';

import '../api/post_api.dart';
import '../models/result.dart';

class PostProvider extends ChangeNotifier {
  Post? like;
  bool? isLike;
  Result? postList;

  getLike(id) async {
    like = await PostApi().like("$id");
    notifyListeners();
  }

  post(int? page, int? limit, Filter? filter) async {
    Offset offset = Offset(limit: limit, page: page);
    Result res =
        await PostApi().list(ResultArguments(filter: filter, offset: offset));
    postList = res;
    notifyListeners();
  }

  // getFilter(Filter filters) {
  //   filter = filters;
  //   print("-------------------FILTER----------------");
  //   print(filter!.postStatus);
  //   print("-------------------FILTER----------------");
  //   notifyListeners();
  // }
}
