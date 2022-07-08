part of '../models/general.dart';

General _$GeneralFromJson(Map<String, dynamic> json) {
  String? s3host;
  List<General>? userStatus;
  List<General>? postStatus;
  List<General>? userRoles;
  String? code;
  String? name;
  String? url;
  String? version;

  if (json['version'] != null) version = json['version'];
  if (json['s3host'] != null) s3host = json['s3host'];
  if (json['url'] != null) url = json['url'];
  if (json['code'] != null) code = json['code'];
  if (json['name'] != null) name = json['name'];
  if (json['userStatus'] != null) {
    userStatus =
        (json['userStatus'] as List).map((e) => General.fromJson(e)).toList();
  }
  if (json['postStatus'] != null) {
    postStatus =
        (json['postStatus'] as List).map((e) => General.fromJson(e)).toList();
  }
  if (json['userRoles'] != null) {
    userRoles =
        (json['userRoles'] as List).map((e) => General.fromJson(e)).toList();
  }

  return General(
    s3host: s3host,
    userStatus: userStatus,
    postStatus: postStatus,
    userRoles: userRoles,
    code: code,
    name: name,
    url: url,
    version: version,
  );
}

Map<String, dynamic> _$GeneralToJson(General instance) {
  Map<String, dynamic> json = {};

  if (instance.s3host != null) json['s3host'] = instance.s3host;
  if (instance.userStatus != null) json['userStatus'] = instance.userStatus;
  if (instance.postStatus != null) json['postStatus'] = instance.postStatus;
  if (instance.userRoles != null) json['userRoles'] = instance.userRoles;
  if (instance.code != null) json['code'] = instance.code;
  if (instance.name != null) json['name'] = instance.name;
  if (instance.url != null) json['url'] = instance.url;
  if (instance.version != null) json['version'] = instance.version;

  return json;
}
