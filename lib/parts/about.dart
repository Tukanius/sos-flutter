part of '../models/about.dart';

About _$AboutFromJson(Map<String, dynamic> json) {
  String? terms;
  String? policy;

  if (json['terms'] != null) terms = json['terms'];
  if (json['policy'] != null) policy = json['policy'];

  return About(
    terms: terms,
    policy: policy,
  );
}

Map<String, dynamic> _$AboutToJson(About instance) {
  Map<String, dynamic> json = {};

  if (instance.terms != null) json['terms'] = instance.terms;
  if (instance.policy != null) json['policy'] = instance.policy;

  return json;
}
