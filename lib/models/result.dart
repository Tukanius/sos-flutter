part '../parts/result.dart';

class Filter {
  String? orderName;
  String? orderBy;
  String? query;
  DateTime? startDate;
  DateTime? endDate;
  String? type;
  String? accountType;
  String? inviteStatus;

  Filter(
      {this.orderName,
      this.orderBy,
      this.query,
      this.startDate,
      this.endDate,
      this.accountType,
      this.inviteStatus,
      this.type});
}

class Offset {
  int? page;
  int? limit;

  Offset({this.page, this.limit});
}

class ResultArguments {
  Filter? filter = Filter(query: "");
  Offset? offset = Offset(page: 1, limit: 10);

  ResultArguments({this.filter, this.offset});

  Map<String, dynamic> toJson() => _$ResultArgumentToJson(this);
}

class Result {
  List<dynamic>? rows = [];
  int? count = 0;
  int? notSeen = 0;

  Result({this.rows, this.count, this.notSeen});

  factory Result.fromJson(dynamic json, Function fromJson) =>
      _$ResultFromJson(json, fromJson);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
