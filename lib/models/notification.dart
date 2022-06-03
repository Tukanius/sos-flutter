import 'package:intl/intl.dart';
import 'package:simple_moment/simple_moment.dart';
part '../parts/notification.dart';

class Notify {
  int? seenCount;
  String? id;
  String? post;
  String? title;
  String? body;
  String? noticeStatusDate;
  String? targetType;
  bool? seen;

  String getDate() {
    return Moment.parse(DateFormat("yyyy-MM-ddTHH:mm:ssZ")
            .parseUTC(noticeStatusDate!)
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
    this.noticeStatusDate,
    this.targetType,
  });

  static $fromJson(Map<String, dynamic> json) => _$NotifyFromJson(json);

  factory Notify.fromJson(Map<String, dynamic> json) => _$NotifyFromJson(json);
  Map<String, dynamic> toJson() => _$NotifyToJson(this);
}
