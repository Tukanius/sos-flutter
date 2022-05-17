part of '../models/sector.dart';

Sector _$SectorFromJson(Map<String, dynamic> json) {
  int? count;
  int? newCount;
  int? pendingCount;
  int? solvedCount;
  List<Sector>? response;
  String? statusString;
  bool? status;
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

  if (json['count'] != null) count = json['count'];
  if (json['new'] != null) newCount = json['new'];
  if (json['pending'] != null) pendingCount = json['pending'];
  if (json['solved'] != null) solvedCount = json['solved'];
  // if (json['status'] != null) status = json['status'];
  if (json['status'] != null) {
    if (json['status'].runtimeType == bool) {
      status = json["status"];
    } else {
      statusString = json["status"];
    }
  }
  if (json["total"] != null) total = int.parse('${json["total"]}');
  if (json['_id'] != null) id = json['_id'];
  if (json['avatar'] != null) avatar = json['avatar'];
  if (json['fullname'] != null) fullname = json['fullname'];
  if (json['phone'] != null) phone = json['phone'];
  if (json['email'] != null) email = json['email'];
  if (json['address'] != null) address = json['address'];
  if (json['createdAt'] != null) createdAt = json['createdAt'];
  if (json['updatedAt'] != null) updatedAt = json['updatedAt'];
  if (json['isActive'] != null) isActive = json['isActive'];

  if (json['response'] != null) {
    response =
        (json['response'] as List).map((e) => Sector.fromJson(e)).toList();
  }

  if (json['rows'] != null) {
    rows = (json['rows'] as List).map((e) => Sector.fromJson(e)).toList();
  }

  return Sector(
    count: count,
    newCount: newCount,
    pendingCount: pendingCount,
    solvedCount: solvedCount,
    response: response,
    rows: rows,
    status: status,
    statusString: statusString,
    total: total,
    id: id,
    avatar: avatar,
    fullname: fullname,
    phone: phone,
    email: email,
    address: address,
    createdAt: createdAt,
    updatedAt: updatedAt,
    role: role,
    isActive: isActive,
  );
}

Map<String, dynamic> _$SectorToJson(Sector instance) {
  Map<String, dynamic> json = {};

  if (instance.count != null) json['count'] = instance.count;
  if (instance.newCount != null) json['new'] = instance.newCount;
  if (instance.pendingCount != null) json['pending'] = instance.pendingCount;
  if (instance.solvedCount != null) json['solved'] = instance.solvedCount;
  if (instance.response != null) json['response'] = instance.response;
  if (instance.status != null) json['status'] = instance.status;
  if (instance.total != null) json['total'] = instance.total;
  if (instance.rows != null) json['rows'] = instance.rows;
  if (instance.id != null) json['_id'] = instance.id;
  if (instance.avatar != null) json['avatar'] = instance.avatar;
  if (instance.fullname != null) json['fullname'] = instance.fullname;
  if (instance.phone != null) json['phone'] = instance.phone;
  if (instance.email != null) json['email'] = instance.email;
  if (instance.address != null) json['address'] = instance.address;
  if (instance.createdAt != null) json['createdAt'] = instance.createdAt;
  if (instance.updatedAt != null) json['updatedAt'] = instance.updatedAt;
  if (instance.role != null) json['role'] = instance.role;
  if (instance.isActive != null) json['isActive'] = instance.isActive;

  return json;
}
