part of '../models/about.dart';

About _$AboutFromJson(Map<String, dynamic> json) {
  String? terms;

  if (json['terms'] != null) terms = json['terms'];

  return About(
    terms: terms,
  );
}

Map<String, dynamic> _$AboutToJson(About instance) {
  Map<String, dynamic> json = {};

  if (instance.terms != null) json['terms'] = instance.terms;

  return json;
}
