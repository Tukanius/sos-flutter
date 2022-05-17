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
  String? id;
  String? avatar;
  String? fullname;
  String? phone;
  String? email;
  String? address;
  String? createdAt;
  String? updatedAt;
  String? role;
  bool? isActive;

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
    this.fullname,
    this.phone,
    this.email,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.role,
    this.isActive,
  });

  static $fromJson(Map<String, dynamic> json) => _$SectorFromJson(json);

  factory Sector.fromJson(Map<String, dynamic> json) => _$SectorFromJson(json);
  Map<String, dynamic> toJson() => _$SectorToJson(this);
}
