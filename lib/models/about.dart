part '../parts/about.dart';

class About {
  String? terms;

  About({
    this.terms,
  });

  static $fromJson(Map<String, dynamic> json) => _$AboutFromJson(json);

  factory About.fromJson(Map<String, dynamic> json) => _$AboutFromJson(json);
  Map<String, dynamic> toJson() => _$AboutToJson(this);
}
