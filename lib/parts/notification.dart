part of '../models/notification.dart';

Notify _$NotifyFromJson(Map<String, dynamic> json) {
  debugPrint("===================[JSON]===================");
  debugPrint("${json}");
  debugPrint("=type===>${json['type']}");
  debugPrint("=navigation===>${json['navigation']}");
  debugPrint("=_id===>${json['_id']}");

  int? seenCount;
  String? id;
  String? post;
  String? title;
  String? body;
  String? notifyStatusDate;
  String? targetType;
  String? notifyType;
  String? type;
  String? navigation;
  bool? seen;

  if (json["seenCount"] != null) seenCount = int.parse('${json["seenCount"]}');
  if (json['_id'] != null) id = json['_id'];
  if (json['post'] != null) post = json['post'];
  if (json['title'] != null) title = json['title'];
  if (json['body'] != null) body = json['body'];
  if (json['type'] != null) type = json['type'];
  if (json['navigation'] != null) navigation = json['navigation'];
  if (json['notifyType'] != null) notifyType = json['notifyType'];
  if (json['notifyStatusDate'] != null) {
    notifyStatusDate = json['notifyStatusDate'];
  }
  if (json['targetType'] != null) targetType = json['targetType'];
  if (json['seen'] != null) seen = json['seen'];

  return Notify(
    seenCount: seenCount,
    post: post,
    id: id,
    title: title,
    body: body,
    notifyStatusDate: notifyStatusDate,
    targetType: targetType,
    seen: seen,
    notifyType: notifyType,
    type: type,
    navigation: navigation,
  );
}

Map<String, dynamic> _$NotifyToJson(Notify instance) {
  Map<String, dynamic> json = {};

  if (instance.seenCount != null) json['seenCount'] = instance.seenCount;
  if (instance.id != null) json['_id'] = instance.id;
  if (instance.post != null) json['post'] = instance.post;
  if (instance.title != null) json['title'] = instance.title;
  if (instance.body != null) json['body'] = instance.body;
  if (instance.notifyType != null) json['notifyType'] = instance.notifyType;
  if (instance.notifyStatusDate != null) {
    json['notifyStatusDate'] = instance.notifyStatusDate;
  }
  if (instance.targetType != null) json['targetType'] = instance.targetType;
  if (instance.seen != null) json['seen'] = instance.seen;
  if (instance.navigation != null) json['navigation'] = instance.navigation;
  if (instance.type != null) json['type'] = instance.type;

  return json;
}
