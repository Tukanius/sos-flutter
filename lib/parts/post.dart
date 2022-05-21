part of '../models/post.dart';

Post _$PostFromJson(Map<String, dynamic> json) {
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
  User user = User();
  String? text;
  String? image;
  String? postStatus;
  String? postStatusDate;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  Sector? sector;
  bool? liked;
  String? reply;
  String? result;
  String? resultImage;

  if (json['result'] != null) result = json['result'];
  if (json['resultImage'] != null) resultImage = json['resultImage'];
  if (json['stats'] != null) stats = json['stats'];
  if (json['reply'] != null) reply = json['reply'];
  if (json['statsNew'] != null) statsNew = json['statsNew'];
  if (json['pending'] != null) pending = json['pending'];
  if (json['solved'] != null) solved = json['solved'];
  if (json['count'] != null) count = json['count'];
  if (json['rows'] != null) rows = json['rows'];
  if (json["user"] != null) {
    user = User.fromJson(json["user"] as Map<String, dynamic>);
  }
  if (json['likeCount'] != null) likeCount = json['likeCount'];
  if (json['seenCount'] != null) seenCount = json['seenCount'];
  if (json['shareCount'] != null) shareCount = json['shareCount'];
  if (json['replyCount'] != null) replyCount = json['replyCount'];
  if (json['_id'] != null) id = json['_id'];
  if (json['text'] != null) text = json['text'];
  if (json['image'] != null) image = json['image'];
  if (json['postStatus'] != null) postStatus = json['postStatus'];
  if (json['postStatusDate'] != null) postStatusDate = json['postStatusDate'];
  if (json['createdAt'] != null) createdAt = json['createdAt'];
  if (json['updatedAt'] != null) updatedAt = json['updatedAt'];
  if (json['createdBy'] != null) createdBy = json['createdBy'];
  if (json['updatedBy'] != null) updatedBy = json['updatedBy'];
  if (json["sector"] != null) {
    sector = Sector.fromJson(json["sector"] as Map<String, dynamic>);
  }
  if (json['liked'] != null) liked = json['liked'];

  return Post(
    stats: stats,
    statsNew: statsNew,
    pending: pending,
    solved: solved,
    count: count,
    rows: rows,
    likeCount: likeCount,
    seenCount: seenCount,
    shareCount: shareCount,
    replyCount: replyCount,
    status: status,
    id: id,
    user: user,
    text: text,
    image: image,
    postStatus: postStatus,
    postStatusDate: postStatusDate,
    createdAt: createdAt,
    updatedAt: updatedAt,
    createdBy: createdBy,
    updatedBy: updatedBy,
    sector: sector,
    reply: reply,
    liked: liked,
    result: result,
    resultImage: resultImage,
  );
}

Map<String, dynamic> _$PostToJson(Post instance) {
  Map<String, dynamic> json = {};

  if (instance.result != null) json['result'] = instance.result;
  if (instance.resultImage != null) json['resultImage'] = instance.resultImage;
  if (instance.stats != null) json['stats'] = instance.stats;
  if (instance.statsNew != null) json['statsNew'] = instance.statsNew;
  if (instance.pending != null) json['pending'] = instance.pending;
  if (instance.solved != null) json['solved'] = instance.solved;
  if (instance.count != null) json['count'] = instance.count;
  if (instance.rows != null) json['rows'] = instance.rows;
  if (instance.likeCount != null) json['likeCount'] = instance.likeCount;
  if (instance.seenCount != null) json['seenCount'] = instance.seenCount;
  if (instance.shareCount != null) json['shareCount'] = instance.shareCount;
  if (instance.replyCount != null) json['replyCount'] = instance.replyCount;
  if (instance.id != null) json['_id'] = instance.id;
  if (instance.user != null) json['user'] = instance.user;
  if (instance.text != null) json['text'] = instance.text;
  if (instance.image != null) json['image'] = instance.image;
  if (instance.postStatus != null) json['postStatus'] = instance.postStatus;
  if (instance.postStatusDate != null) {
    json['postStatusDate'] = instance.postStatusDate;
  }
  if (instance.createdAt != null) json['createdAt'] = instance.createdAt;
  if (instance.updatedAt != null) json['updatedAt'] = instance.updatedAt;
  if (instance.createdBy != null) json['createdBy'] = instance.createdBy;
  if (instance.updatedBy != null) json['updatedBy'] = instance.updatedBy;
  if (instance.sector != null) json['sector'] = instance.sector;
  if (instance.liked != null) json['liked'] = instance.liked;
  if (instance.reply != null) json['reply'] = instance.reply;

  return json;
}
