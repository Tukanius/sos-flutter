import 'package:sos/models/notification.dart';
import '../models/result.dart';
import '../utils/http_request.dart';

class NotifyApi extends HttpRequest {
  Future<Result> list(ResultArguments resultArguments) async {
    var res = await get('/notice', data: resultArguments.toJson());
    return Result.fromJson(res, Notify.$fromJson);
  }

  Future<Notify> getNotify(String id) async {
    var res = await get('/notice/$id', handler: false);
    return Notify.fromJson(res as Map<String, dynamic>);
  }
}
