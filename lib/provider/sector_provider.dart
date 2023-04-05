import 'package:flutter/material.dart';
import 'package:sos/api/dashboard_api.dart';
import 'package:sos/models/sector.dart';

class SectorProvider extends ChangeNotifier {
  Sector sectorData = Sector();
  List<Sector> response = [];
  String? avatar;

  clear() {
    response = [];
    notifyListeners();
  }

  sector() async {
    sectorData = await DashboardApi().sector();
    response = sectorData.response!;
    response.removeWhere(
      (element) => element.key == "ALL",
    );
    response.removeWhere(
      (element) => element.key == "REVIEW",
    );
    notifyListeners();
  }

  sectorGet(id) async {
    if (id != null) {
      var data = await DashboardApi().getSector(id);
      response = data.response!;
    } else {
      await sector();
    }
    notifyListeners();
  }
}
