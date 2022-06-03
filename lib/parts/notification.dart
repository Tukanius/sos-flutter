part of '../models/notification.dart';

Notify _$NotifyFromJson(Map<String, dynamic> json) {
  int? seenCount;
  String? id;
  String? post;
  String? title;
  String? body;
  String? noticeStatusDate;
  String? targetType;
  bool? seen;

  if (json["seenCount"] != null) seenCount = int.parse('${json["seenCount"]}');
  if (json['_id'] != null) id = json['_id'];
  if (json['post'] != null) post = json['post'];
  if (json['title'] != null) title = json['title'];
  if (json['body'] != null) body = json['body'];
  if (json['noticeStatusDate'] != null) {
    noticeStatusDate = json['noticeStatusDate'];
  }
  if (json['targetType'] != null) targetType = json['targetType'];
  if (json['seen'] != null) seen = json['seen'];

  return Notify(
    seenCount: seenCount,
    post: post,
    id: id,
    title: title,
    body: body,
    noticeStatusDate: noticeStatusDate,
    targetType: targetType,
    seen: seen,
  );
}

Map<String, dynamic> _$NotifyToJson(Notify instance) {
  Map<String, dynamic> json = {};

  if (instance.seenCount != null) json['seenCount'] = instance.seenCount;
  if (instance.id != null) json['_id'] = instance.id;
  if (instance.post != null) json['post'] = instance.post;
  if (instance.title != null) json['title'] = instance.title;
  if (instance.body != null) json['body'] = instance.body;
  if (instance.noticeStatusDate != null) {
    json['noticeStatusDate'] = instance.noticeStatusDate;
  }
  if (instance.targetType != null) json['targetType'] = instance.targetType;
  if (instance.seen != null) json['seen'] = instance.seen;

  return json;
}
