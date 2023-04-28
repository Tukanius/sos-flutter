import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:sos/models/sector.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:sos/models/user.dart';

import '../utils/http_request.dart';
part '../parts/post.dart';

class Post {
  final GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();

  Post? stats;
  int? statsNew;
  int? pending;
  int? solved;
  int? count;
  List<Post>? rows;
  int? likeCount;
  int? seenCount;
  int? shareCount;
  int? replyCount;
  bool? status;
  String? id;
  User? user = User();
  String? text;
  String? url;
  String? image;
  String? postStatus;
  String? postStatusDate;
  String? createdAt;
  String? updatedAt;
  String? title;
  String? createdBy;
  String? updatedBy;
  Sector? sector = Sector();
  bool? liked;
  String? body;
  String? reply;
  String? result;
  String? resultImage;
  String? repliedDate;
  String? resultDate;
  String? sectorUser;
  String? refuse;
  bool? isRefused;
  String? reportType;
  String? imageThumb;
  Post? location;
  double? lng;
  double? lat;
  bool? isLocated;

  getImage() {
    return HttpRequest.s3host + image.toString();
  }

  getThumb() {
    return HttpRequest.s3host + imageThumb.toString();
  }

  resImage() {
    return HttpRequest.s3host + resultImage.toString();
  }

  String getPostDate() {
    return Moment.parse(DateFormat("yyyy-MM-ddTHH:mm:ssZ")
            .parseUTC(createdAt!)
            .toLocal()
            .toIso8601String())
        .format("yyyy-MM-dd HH:mm");
  }

  String getPostStatusDate() {
    return Moment.parse(DateFormat("yyyy-MM-ddTHH:mm:ssZ")
            .parseUTC(postStatusDate!)
            .toLocal()
            .toIso8601String())
        .format("yyyy-MM-dd HH:mm");
  }

  String getReplyDate() {
    return Moment.parse(DateFormat("yyyy-MM-ddTHH:mm:ssZ")
            .parseUTC(repliedDate!)
            .toLocal()
            .toIso8601String())
        .format("yyyy-MM-dd HH:mm");
  }

  String getResultDate() {
    return Moment.parse(DateFormat("yyyy-MM-ddTHH:mm:ssZ")
            .parseUTC(resultDate!)
            .toLocal()
            .toIso8601String())
        .format("yyyy-MM-dd HH:mm");
  }

  Post({
    this.stats,
    this.statsNew,
    this.pending,
    this.solved,
    this.count,
    this.rows,
    this.title,
    this.likeCount,
    this.seenCount,
    this.shareCount,
    this.replyCount,
    this.status,
    this.id,
    this.user,
    this.text,
    this.image,
    this.postStatus,
    this.postStatusDate,
    this.createdAt,
    this.updatedAt,
    this.body,
    this.createdBy,
    this.url,
    this.updatedBy,
    this.sector,
    this.liked,
    this.reply,
    this.result,
    this.resultImage,
    this.repliedDate,
    this.resultDate,
    this.sectorUser,
    this.refuse,
    this.isRefused,
    this.imageThumb,
    this.reportType,
    this.location,
    this.lat,
    this.lng,
    this.isLocated,
  });

  static $fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
