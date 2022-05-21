import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sos/models/sector.dart';
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
  String? image;
  String? postStatus;
  String? postStatusDate;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  Sector? sector = Sector();
  bool? liked;
  String? reply;
  String? result;
  String? resultImage;

  getImage() {
    return HttpRequest.s3host + image.toString();
  }

  resImage() {
    return HttpRequest.s3host + resultImage.toString();
  }

  Post({
    this.stats,
    this.statsNew,
    this.pending,
    this.solved,
    this.count,
    this.rows,
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
    this.createdBy,
    this.updatedBy,
    this.sector,
    this.liked,
    this.reply,
    this.result,
    this.resultImage,
  });

  static $fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
