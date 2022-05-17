import '../models/post.dart';
import '../models/result.dart';
import '../utils/http_request.dart';

class PostApi extends HttpRequest {
  Future<Result> list(ResultArguments resultArguments) async {
    var res = await get('/post', data: resultArguments.toJson());
    return Result.fromJson(res, Post.$fromJson);
  }

  Future<Post> getPost(String id) async {
    var res = await get('/post/$id', handler: false);
    return Post.fromJson(res as Map<String, dynamic>);
  }
}
