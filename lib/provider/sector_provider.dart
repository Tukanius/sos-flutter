import 'package:flutter/material.dart';
import 'package:sos/api/dashboard_api.dart';
import 'package:sos/models/sector.dart';

class SectorProvider extends ChangeNotifier {
  Sector sectorData = Sector();
  List<Sector> response = [];

  clear() {
    response = [];
    notifyListeners();
  }

  sector() async {
    sectorData = await DashboardApi().sector();
    response = sectorData.response!;
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
