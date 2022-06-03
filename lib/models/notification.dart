import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:simple_moment/simple_moment.dart';
part '../parts/notification.dart';

class Notify {
  int? seenCount;
  String? id;
  String? post;
  String? title;
  String? body;
  String? notifyType;
  String? notifyStatusDate;
  String? targetType;
  String? type;
  String? navigation;
  bool? seen;

  String getDate() {
    return Moment.parse(DateFormat("yyyy-MM-ddTHH:mm:ssZ")
            .parseUTC(notifyStatusDate!)
            .toLocal()
            .toIso8601String())
        .format("yyyy-MM-dd HH:mm");
  }

  Notify({
    this.seen,
    this.id,
    this.seenCount,
    this.post,
    this.title,
    this.body,
    this.notifyType,
    this.notifyStatusDate,
    this.targetType,
    this.navigation,
    this.type,
  });

  static $fromJson(Map<String, dynamic> json) => _$NotifyFromJson(json);

  factory Notify.fromJson(Map<String, dynamic> json) => _$NotifyFromJson(json);
  Map<String, dynamic> toJson() => _$NotifyToJson(this);
}
