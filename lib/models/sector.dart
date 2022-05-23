import '../utils/http_request.dart';

part '../parts/sector.dart';

class Sector {
  int? count;
  int? newCount;
  int? pendingCount;
  int? solvedCount;
  List<Sector>? response;
  bool? status;
  String? statusString;
  int? total;
  List<Sector>? rows;
  String? firstName;
  String? id;
  String? avatar;
  String? fullName;
  String? lastName;
  String? phone;
  String? email;
  String? address;
  String? createdAt;
  String? updatedAt;
  String? role;
  bool? isActive;
  Sector? all;
  int? countPending;
  int? countSolved;
  Sector? posted;
  Sector? stats;
  int? pending;
  int? solved;

  getAvatar() {
    return HttpRequest.s3host + avatar.toString();
  }

  Sector({
    this.count,
    this.newCount,
    this.pendingCount,
    this.solvedCount,
    this.response,
    this.rows,
    this.status,
    this.statusString,
    this.total,
    this.id,
    this.avatar,
    this.fullName,
    this.phone,
    this.email,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.role,
    this.isActive,
    this.all,
    this.countPending,
    this.countSolved,
    this.posted,
    this.stats,
    this.pending,
    this.solved,
    this.firstName,
    this.lastName,
  });

  static $fromJson(Map<String, dynamic> json) => _$SectorFromJson(json);

  factory Sector.fromJson(Map<String, dynamic> json) => _$SectorFromJson(json);
  Map<String, dynamic> toJson() => _$SectorToJson(this);
}
