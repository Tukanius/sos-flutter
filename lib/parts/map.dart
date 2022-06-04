part of '../models/map.dart';

MapModel _$MapModelFromJson(Map<String, dynamic> json) {
  MapModel? location;
  bool? isActive;
  int? likeCount;
  int? reportCount;
  int? shareCount;
  bool? isAssigned;
  bool? isRefused;
  bool? status;
  String? id;
  String? user;
  String? text;
  String? image;
  String? imageThumb;
  String? postStatus;
  double? lat;
  double? lng;

  if (json["location"] != null) {
    location = MapModel.fromJson(json["location"] as Map<String, dynamic>);
  }
  if (json['isActive'] != null) isActive = json['isActive'];
  if (json['likeCount'] != null) likeCount = json['likeCount'];
  if (json['reportCount'] != null) reportCount = json['reportCount'];
  if (json['shareCount'] != null) shareCount = json['shareCount'];
  if (json['isAssigned'] != null) isAssigned = json['isAssigned'];
  if (json['isRefused'] != null) isRefused = json['isRefused'];
  if (json['status'] != null) status = json['status'];
  if (json['_id'] != null) id = json['_id'];
  if (json['user'] != null) user = json['user'];
  if (json['text'] != null) text = json['text'];
  if (json['image'] != null) image = json['image'];
  if (json['imageThumb'] != null) imageThumb = json['imageThumb'];
  if (json['postStatus'] != null) postStatus = json['postStatus'];
  if (json['lat'] != null) lat = json['lat'];
  if (json['lng'] != null) lng = json['lng'];

  return MapModel(
    location: location,
    isActive: isActive,
    likeCount: likeCount,
    reportCount: reportCount,
    shareCount: shareCount,
    isAssigned: isAssigned,
    isRefused: isRefused,
    status: status,
    id: id,
    user: user,
    text: text,
    image: image,
    imageThumb: imageThumb,
    postStatus: postStatus,
    lat: lat,
    lng: lng,
  );
}

Map<String, dynamic> _$MapModelToJson(MapModel instance) {
  Map<String, dynamic> json = {};

  if (instance.location != null) json['location'] = instance.location;
  if (instance.isActive != null) json['isActive'] = instance.isActive;
  if (instance.likeCount != null) json['likeCount'] = instance.likeCount;
  if (instance.reportCount != null) json['reportCount'] = instance.reportCount;
  if (instance.shareCount != null) json['shareCount'] = instance.shareCount;
  if (instance.isAssigned != null) json['isAssigned'] = instance.isAssigned;
  if (instance.isRefused != null) json['isRefused'] = instance.isRefused;
  if (instance.status != null) json['status'] = instance.status;
  if (instance.id != null) json['_id'] = instance.id;
  if (instance.user != null) json['user'] = instance.user;
  if (instance.text != null) json['text'] = instance.text;
  if (instance.image != null) json['image'] = instance.image;
  if (instance.imageThumb != null) json['imageThumb'] = instance.imageThumb;
  if (instance.postStatus != null) json['postStatus'] = instance.postStatus;
  if (instance.lat != null) json['lat'] = instance.lat;
  if (instance.lng != null) json['lng'] = instance.lng;

  return json;
}
