part of '../models/notification.dart';

Notify _$NotifyFromJson(Map<String, dynamic> json) {
  int? seenCount;
  String? id;
  String? post;
  String? title;
  String? user;
  String? body;
  String? notifyType;
  String? notifyStatusDate;
  String? targetType;
  String? type;
  String? navigation;
  bool? seen;
  String? sector;
  bool? isSeen;
  String? seenDate;
  bool? isFireBase;
  bool? isFireBaseSuccess;
  String? fireBaseError;
  bool? status;
  String? image;
  String? notificationStatus;
  String? notificationStatusDate;
  String? navigationId;
  bool? isNavigation;

  if (json["seenCount"] != null) seenCount = int.parse('${json["seenCount"]}');
  if (json['_id'] != null) id = json['_id'];
  if (json['post'] != null) post = json['post'];
  if (json['user'] != null) user = json['user'];
  if (json['sector'] != null) sector = json['sector'];
  if (json['title'] != null) title = json['title'];
  if (json['body'] != null) body = json['body'];
  if (json['type'] != null) type = json['type'];
  if (json['navigation'] != null) navigation = json['navigation'];
  if (json['notifyType'] != null) notifyType = json['notifyType'];
  if (json['notifyStatusDate'] != null) {
    notifyStatusDate = json['notifyStatusDate'];
  }
  if (json['targetType'] != null) targetType = json['targetType'];

  if (json['isSeen'] != null) isSeen = json['isSeen'];
  if (json['seenDate'] != null) seenDate = json['seenDate'];
  if (json['isFireBase'] != null) isFireBase = json['isFireBase'];
  if (json['isFireBaseSuccess'] != null) {
    isFireBaseSuccess = json['isFireBaseSuccess'];
  }
  if (json['fireBaseError'] != null) fireBaseError = json['fireBaseError'];
  if (json['status'] != null) status = json['status'];
  if (json['image'] != null) image = json['image'];
  if (json['notificationStatusDate'] != null) {
    notificationStatusDate = json['notificationStatusDate'];
  }
  if (json['notificationStatus'] != null) {
    notificationStatus = json['notificationStatus'];
  }
  if (json['navigationId'] != null) navigationId = json['navigationId'];
  if (json['isNavigation'] != null) isNavigation = json['isNavigation'];

  return Notify(
    seenCount: seenCount,
    post: post,
    user: user,
    id: id,
    title: title,
    body: body,
    notifyStatusDate: notifyStatusDate,
    targetType: targetType,
    seen: seen,
    notifyType: notifyType,
    type: type,
    navigation: navigation,
    sector: sector,
    isSeen: isSeen,
    seenDate: seenDate,
    isFireBase: isFireBase,
    isFireBaseSuccess: isFireBaseSuccess,
    fireBaseError: fireBaseError,
    status: status,
    image: image,
    notificationStatusDate: notificationStatusDate,
    notificationStatus: notifyStatusDate,
    navigationId: navigationId,
    isNavigation: isNavigation,
  );
}

Map<String, dynamic> _$NotifyToJson(Notify instance) {
  Map<String, dynamic> json = {};

  if (instance.seenCount != null) json['seenCount'] = instance.seenCount;
  if (instance.id != null) json['_id'] = instance.id;
  if (instance.title != null) json['title'] = instance.title;
  if (instance.body != null) json['body'] = instance.body;
  if (instance.notifyType != null) json['notifyType'] = instance.notifyType;
  if (instance.notifyStatusDate != null) {
    json['notifyStatusDate'] = instance.notifyStatusDate;
  }
  if (instance.targetType != null) json['targetType'] = instance.targetType;
  if (instance.seen != null) json['seen'] = instance.seen;
  if (instance.navigation != null) json['navigation'] = instance.navigation;
  if (instance.sector != null) json['sector'] = instance.sector;
  if (instance.isSeen != null) json['isSeen'] = instance.isSeen;
  if (instance.seenDate != null) json['seenDate'] = instance.seenDate;
  if (instance.isFireBase != null) json['isFireBase'] = instance.isFireBase;
  if (instance.isFireBaseSuccess != null) {
    json['isFireBaseSuccess'] = instance.isFireBaseSuccess;
  }
  if (instance.fireBaseError != null) {
    json['fireBaseError'] = instance.fireBaseError;
  }
  if (instance.status != null) json['status'] = instance.status;
  if (instance.image != null) json['image'] = instance.image;
  if (instance.notificationStatusDate != null) {
    json['notificationStatusDate'] = instance.notificationStatusDate;
  }
  if (instance.notificationStatus != null) {
    json['notificationStatus'] = instance.notificationStatus;
  }
  if (instance.navigationId != null) {
    json['navigationId'] = instance.navigationId;
  }
  if (instance.isNavigation != null) {
    json['isNavigation'] = instance.isNavigation;
  }
  if (instance.post != null) json['post'] = instance.post;
  if (instance.user != null) json['user'] = instance.user;

  return json;
}
