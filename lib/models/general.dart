import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
part '../parts/general.dart';

class General {
  final GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();

  String? s3host;
  General({
    this.s3host,
  });

  static $fromJson(Map<String, dynamic> json) => _$GeneralFromJson(json);

  factory General.fromJson(Map<String, dynamic> json) =>
      _$GeneralFromJson(json);
  Map<String, dynamic> toJson() => _$GeneralToJson(this);
}
