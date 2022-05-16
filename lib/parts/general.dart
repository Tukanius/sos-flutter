part of '../models/general.dart';

General _$GeneralFromJson(Map<String, dynamic> json) {
  String? s3host;

  if (json['s3host'] != null) s3host = json['s3host'];

  return General(
    s3host: s3host,
  );
}

Map<String, dynamic> _$GeneralToJson(General instance) {
  Map<String, dynamic> json = {};

  if (instance.s3host != null) json['s3host'] = instance.s3host;

  return json;
}
