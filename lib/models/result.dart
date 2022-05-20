part '../parts/result.dart';

class Filter {
  String? query;
  String? postStatus;
  String? user;

  Filter({
    this.query,
    this.postStatus,
    this.user,
  });
}

class Offset {
  int? page;
  int? limit;

  Offset({this.page, this.limit});
}

class ResultArguments {
  Filter? filter = Filter();
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
