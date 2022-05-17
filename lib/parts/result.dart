part of '../models/result.dart';

Result _$ResultFromJson(dynamic res, Function fromJson) {
  Map<String, dynamic>? json;
  List<dynamic>? results;

  if (res.runtimeType == <dynamic>[].runtimeType) {
    results = res as List?;

    return Result(
        rows: results!
            .map((json) => fromJson(json as Map<String, dynamic>))
            .toList(),
        count: results.length);
  } else {
    json = res as Map<String, dynamic>?;
    return Result(
      rows: (json!['rows'] as List)
          .map((json) => fromJson(json as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int?,
    );
  }
}

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'rows': instance.rows,
      'count': instance.count,
    };

Map<String, dynamic> _$ResultArgumentToJson(ResultArguments instance) {
  Map<String, dynamic> params = {};

  if (instance != null) {
    params['offset'] = {};
    params['filter'] = {};
    params['filter']['order_name'] = instance.filter!.orderName;
    params['filter']['order_by'] = instance.filter!.orderBy;
    params['filter']['query'] = instance.filter!.query;
    params['filter']['start_date'] = instance.filter!.startDate;
    params['filter']['end_date'] = instance.filter!.endDate;
    params['filter']['type'] = instance.filter!.type;
    params['filter']['account_type'] = instance.filter!.accountType;
    params['filter']['invite_status'] = instance.filter!.inviteStatus;

    if (instance.offset!.page! > 0) {
      params['offset']['page'] = instance.offset!.page;
    }
    if (instance.offset!.limit! > 0) {
      params['offset']['limit'] = instance.offset!.limit;
    }
  }

  return params;
}
