import '../models/general.dart';
import '../utils/http_request.dart';

class GeneralApi extends HttpRequest {
  Future<General> init(bool handler) async {
    var res = await get('/general/init', handler: handler);
    return General.fromJson(res as Map<String, dynamic>);
  }
}
