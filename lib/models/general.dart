import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
part '../parts/general.dart';

class General {
  final GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();
  String? s3host;
  List<General>? userStatus;
  List<General>? postStatus;
  List<General>? userRoles;
  String? code;
  String? name;
  String? url;

  General({
    this.s3host,
    this.userStatus,
    this.postStatus,
    this.userRoles,
    this.code,
    this.name,
    this.url,
  });

  static $fromJson(Map<String, dynamic> json) => _$GeneralFromJson(json);

  factory General.fromJson(Map<String, dynamic> json) =>
      _$GeneralFromJson(json);
  Map<String, dynamic> toJson() => _$GeneralToJson(this);
}
