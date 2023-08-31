import 'package:sos/models/map.dart';

import '../models/post.dart';
import '../models/result.dart';
import '../utils/http_request.dart';

class PostApi extends HttpRequest {
  Future<Result> list(ResultArguments resultArguments) async {
    var res = await get('/post', data: resultArguments.toJson());
    return Result.fromJson(res, Post.$fromJson);
  }

  Future<Result> likedList(ResultArguments resultArguments) async {
    var res = await get('/post/liked', data: resultArguments.toJson());
    return Result.fromJson(res, Post.$fromJson);
  }

  Future<Post> getPost(String id) async {
    var res = await get('/post/$id', handler: false);
    return Post.fromJson(res as Map<String, dynamic>);
  }

  Future<Post> like(String id) async {
    var res = await get('/post/$id/like', handler: true);
    return Post.fromJson(res as Map<String, dynamic>);
  }

  createPost(Post data) async {
    var res = await post('/post', data: data.toJson(), handler: true);
    return res;
  }

  reportPost(String id, Post data) async {
    await post('/post/$id/report', data: data.toJson(), handler: true);
  }

  addResult(String? id, Post data) async {
    await put('/post/$id/result', data: data.toJson());
  }

  deletePost(String? id) async {
    await del('/post/$id');
  }

  editPost(String? id, Post data) async {
    await put('/post/$id', data: data.toJson());
  }

  assignPost(String? id, Post data) async {
    await put('/post/$id/assign', data: data.toJson());
  }

  Future<Result> mapList(ResultArguments resultArguments) async {
    var res = await get('/map', data: resultArguments.toJson());
    return Result.fromJson(res, MapModel.$fromJson);
  }
}
