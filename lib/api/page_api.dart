import 'package:sos/models/about.dart';
import '../utils/http_request.dart';

class PageApi extends HttpRequest {
  Future<About> getAbout() async {
    var res = await get('/about', handler: true);
    return About.fromJson(res as Map<String, dynamic>);
  }
}
