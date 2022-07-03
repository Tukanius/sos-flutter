import 'package:intl/intl.dart';
import 'package:simple_moment/simple_moment.dart';

import '../utils/http_request.dart';
part '../parts/notification.dart';

class Notify {
  int? seenCount;
  String? id;
  String? post;
  String? title;
  String? user;
  String? body;
  String? notifyType;
  String? notifyStatusDate;
  String? targetType;
  String? type;
  String? navigation;
  bool? seen;
  String? sector;
  bool? isSeen;
  String? seenDate;
  bool? isFireBase;
  bool? isFireBaseSuccess;
  String? fireBaseError;
  bool? status;
  String? image;
  String? notificationStatus;
  String? notificationStatusDate;
  String? navigationId;
  bool? isNavigation;

  getImage() {
    return HttpRequest.s3host + image.toString();
  }

  String getDate() {
    return Moment.parse(DateFormat("yyyy-MM-ddTHH:mm:ssZ")
            .parseUTC(notificationStatusDate!)
            .toLocal()
            .toIso8601String())
        .format("yyyy-MM-dd HH:mm");
  }

  Notify({
    this.seen,
    this.id,
    this.seenCount,
    this.post,
    this.user,
    this.title,
    this.body,
    this.notifyType,
    this.notifyStatusDate,
    this.targetType,
    this.navigation,
    this.type,
    this.sector,
    this.isSeen,
    this.seenDate,
    this.isFireBase,
    this.isFireBaseSuccess,
    this.fireBaseError,
    this.status,
    this.image,
    this.notificationStatusDate,
    this.notificationStatus,
    this.navigationId,
    this.isNavigation,
  });

  static $fromJson(Map<String, dynamic> json) => _$NotifyFromJson(json);

  factory Notify.fromJson(Map<String, dynamic> json) => _$NotifyFromJson(json);
  Map<String, dynamic> toJson() => _$NotifyToJson(this);
}
