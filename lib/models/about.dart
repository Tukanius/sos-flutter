part '../parts/about.dart';

class About {
  String? terms;
  String? policy;

  About({
    this.terms,
    this.policy,
  });

  static $fromJson(Map<String, dynamic> json) => _$AboutFromJson(json);

  factory About.fromJson(Map<String, dynamic> json) => _$AboutFromJson(json);
  Map<String, dynamic> toJson() => _$AboutToJson(this);
}
