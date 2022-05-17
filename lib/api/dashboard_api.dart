import 'package:sos/models/sector.dart';

import '../utils/http_request.dart';

class DashboardApi extends HttpRequest {
  Future<Sector> sector() async {
    var res = await get('/sector', handler: false);
    return Sector.fromJson(res as Map<String, dynamic>);
  }
}
