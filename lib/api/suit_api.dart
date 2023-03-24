import 'package:sos/models/post.dart';
import 'package:sos/utils/http_request.dart';

class SuitApi extends HttpRequest {
  sharePost(String id) async {
    var res = await get('/post/$id/share', handler: true);
    return Post.fromJson(res as Map<String, dynamic>);
  }
}
