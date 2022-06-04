part '../parts/map.dart';

class MapModel {
  MapModel? location;
  bool? isActive;
  int? likeCount;
  int? reportCount;
  int? shareCount;
  bool? isAssigned;
  bool? isRefused;
  bool? status;
  String? id;
  String? user;
  String? text;
  String? image;
  String? imageThumb;
  String? postStatus;
  double? lat;
  double? lng;

  MapModel({
    this.location,
    this.isActive,
    this.likeCount,
    this.reportCount,
    this.shareCount,
    this.isAssigned,
    this.isRefused,
    this.status,
    this.id,
    this.user,
    this.text,
    this.image,
    this.imageThumb,
    this.postStatus,
    this.lat,
    this.lng,
  });

  static $fromJson(Map<String, dynamic> json) => _$MapModelFromJson(json);

  factory MapModel.fromJson(Map<String, dynamic> json) =>
      _$MapModelFromJson(json);
  Map<String, dynamic> toJson() => _$MapModelToJson(this);
}
