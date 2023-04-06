part of '../models/post.dart';

Post _$PostFromJson(Map<String, dynamic> json) {
  Post? stats;
  int? statsNew;
  int? pending;
  int? solved;
  int? count;
  List<Post>? rows;
  String? body;
  int? likeCount;
  int? seenCount;
  int? shareCount;
  int? replyCount;
  bool? status;
  String? id;
  User user = User();
  String? text;
  String? title;
  String? image;
  String? postStatus;
  String? postStatusDate;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  Sector sector = Sector();
  bool? liked;
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
  double? lat;
  String? url;
  double? lng;
  bool? isLocated;

  if (json["sector"] != null) {
    sector = Sector.fromJson(json["sector"] as Map<String, dynamic>);
  }
  if (json['title'] != null) title = json['title'];
  if (json['body'] != null) body = json['body'];
  if (json['repliedDate'] != null) repliedDate = json['repliedDate'];
  if (json['resultDate'] != null) resultDate = json['resultDate'];
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
  if (json["location"] != null) {
    location = Post.fromJson(json["location"] as Map<String, dynamic>);
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

  if (json['liked'] != null) liked = json['liked'];
  if (json['sectorUser'] != null) sectorUser = json['sectorUser'];
  if (json['refuse'] != null) refuse = json['refuse'];
  if (json['isRefused'] != null) isRefused = json['isRefused'];
  if (json['url'] != null) url = json['url'];
  if (json['reportType'] != null) reportType = json['reportType'];
  if (json['imageThumb'] != null) imageThumb = json['imageThumb'];
  if (json["lat"] != null) lat = double.parse('${json["lat"]}');
  if (json["lng"] != null) lng = double.parse('${json["lng"]}');
  if (json['isLocated'] != null) isLocated = json['isLocated'];

  return Post(
    title: title,
    stats: stats,
    statsNew: statsNew,
    pending: pending,
    solved: solved,
    count: count,
    rows: rows,
    likeCount: likeCount,
    seenCount: seenCount,
    shareCount: shareCount,
    body: body,
    replyCount: replyCount,
    status: status,
    id: id,
    user: user,
    text: text,
    image: image,
    postStatus: postStatus,
    url: url,
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
    resultDate: resultDate,
    repliedDate: repliedDate,
    sectorUser: sectorUser,
    refuse: refuse,
    isRefused: isRefused,
    reportType: reportType,
    imageThumb: imageThumb,
    lat: lat,
    lng: lng,
    location: location,
    isLocated: isLocated,
  );
}

Map<String, dynamic> _$PostToJson(Post instance) {
  Map<String, dynamic> json = {};

  if (instance.title != null) json['title'] = instance.title;
  if (instance.body != null) json['body'] = instance.body;
  if (instance.repliedDate != null) json['repliedDate'] = instance.repliedDate;
  if (instance.resultDate != null) json['resultDate'] = instance.resultDate;
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
  if (instance.url != null) json['url'] = instance.url;
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
  if (instance.sectorUser != null) json['sectorUser'] = instance.sectorUser;
  if (instance.refuse != null) json['refuse'] = instance.refuse;
  if (instance.isRefused != null) json['isRefused'] = instance.isRefused;
  if (instance.reportType != null) json['reportType'] = instance.reportType;
  if (instance.imageThumb != null) json['imageThumb'] = instance.imageThumb;
  if (instance.lat != null) json['lat'] = instance.lat;
  if (instance.lng != null) json['lng'] = instance.lng;
  if (instance.location != null) json['location'] = instance.location;
  if (instance.isLocated != null) json['isLocated'] = instance.isLocated;

  return json;
}
