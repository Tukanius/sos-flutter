import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sos/models/user.dart';
import 'package:simple_moment/simple_moment.dart';

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
  String? sector;
  bool? liked;

  getImage() {
    return HttpRequest.s3host + image.toString();
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
  });

  static $fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
