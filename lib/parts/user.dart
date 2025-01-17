part of '../models/user.dart';

User _$UserFromJson(Map<String, dynamic> json) {
  String? username;
  String? password;
  String? accessToken;
  String? tokenType;
  String? sessionState;
  bool? isActive;
  String? userStatus;
  bool? status;
  String? id;
  String? phone;
  String? userStatusDate;
  String? role;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? otpMethod;
  String? firstName;
  String? lastName;
  String? avatar;
  String? deviceToken;
  String? email;
  String? code;
  String? oldPassowrd;
  String? message;
  Sector? sector;
  String? type;
  String? redirectUri;
  String? idToken;
  int? notification;
  int? referToMe;
  int? mine;
  int? mySector;
  int? allSectorTask;

  if (json['referToMe'] != null) referToMe = json['referToMe'];
  if (json['mine'] != null) mine = json['mine'];
  if (json['mySector'] != null) mySector = json['mySector'];
  if (json['allSectorTask'] != null) allSectorTask = json['allSectorTask'];

  if (json['username'] != null) username = json['username'];
  if (json['id_token'] != null) idToken = json['id_token'];
  if (json['password'] != null) password = json['password'];
  if (json['accessToken'] != null) accessToken = json['accessToken'];
  if (json['tokenType'] != null) tokenType = json['tokenType'];
  if (json['sessionState'] != null) sessionState = json['sessionState'];

  if (json['isActive'] != null) isActive = json['isActive'];
  if (json['userStatus'] != null) userStatus = json['userStatus'];
  if (json['status'] != null) status = json['status'];
  if (json['_id'] != null) id = json['_id'];
  if (json['phone'] != null) phone = json['phone'];
  if (json['userStatusDate'] != null) userStatusDate = json['userStatusDate'];
  if (json['role'] != null) role = json['role'];
  if (json['createdAt'] != null) createdAt = json['createdAt'];
  if (json['updatedAt'] != null) updatedAt = json['updatedAt'];
  if (json['createdBy'] != null) createdBy = json['createdBy'];
  if (json['updatedBy'] != null) updatedBy = json['updatedBy'];
  if (json['otpMethod'] != null) otpMethod = json['otpMethod'];
  if (json['firstName'] != null) firstName = json['firstName'];
  if (json['lastName'] != null) lastName = json['lastName'];
  if (json['avatar'] != null) avatar = json['avatar'];
  if (json['deviceToken'] != null) deviceToken = json['deviceToken'];
  if (json['email'] != null) email = json['email'];
  if (json['code'] != null) code = json['code'];
  if (json['oldPassowrd'] != null) oldPassowrd = json['oldPassowrd'];
  if (json['message'] != null) message = json['message'];
  if (json['type'] != null) type = json['type'];
  if (json['redirect_uri'] != null) redirectUri = json['redirect_uri'];
  if (json["sector"] != null) {
    sector = Sector.fromJson(json["sector"] as Map<String, dynamic>);
  }
  if (json["notification"] != null) {
    notification = int.parse('${json["notification"]}');
  }

  return User(
    username: username,
    password: password,
    accessToken: accessToken,
    tokenType: tokenType,
    sessionState: sessionState,
    isActive: isActive,
    userStatus: userStatus,
    userStatusDate: userStatusDate,
    status: status,
    id: id,
    phone: phone,
    role: role,
    createdAt: createdAt,
    updatedAt: updatedAt,
    createdBy: createdBy,
    updatedBy: updatedBy,
    otpMethod: otpMethod,
    firstName: firstName,
    lastName: lastName,
    avatar: avatar,
    deviceToken: deviceToken,
    email: email,
    code: code,
    oldPassword: oldPassowrd,
    message: message,
    sector: sector,
    type: type,
    redirectUri: redirectUri,
    idToken: idToken,
    notification: notification,
    referToMe: referToMe,
    mine: mine,
    mySector: mySector,
    allSectorTask: allSectorTask,
  );
}

Map<String, dynamic> _$UserToJson(User instance) {
  Map<String, dynamic> json = {};

  if (instance.referToMe != null) json['referToMe'] = instance.referToMe;
  if (instance.mine != null) json['mine'] = instance.mine;
  if (instance.mySector != null) json['mySector'] = instance.mySector;
  if (instance.allSectorTask != null) {
    json['allSectorTask'] = instance.allSectorTask;
  }

  if (instance.username != null) json['username'] = instance.username;
  if (instance.type != null) json['type'] = instance.type;
  if (instance.password != null) json['password'] = instance.password;
  if (instance.accessToken != null) json['accessToken'] = instance.accessToken;
  if (instance.tokenType != null) json['tokenType'] = instance.tokenType;
  if (instance.sessionState != null) {
    json['sessionState'] = instance.sessionState;
  }
  if (instance.isActive != null) json['isActive'] = instance.isActive;
  if (instance.userStatus != null) json['userStatus'] = instance.userStatus;
  if (instance.status != null) json['status'] = instance.status;
  if (instance.id != null) json['_id'] = instance.id;
  if (instance.phone != null) json['phone'] = instance.phone;
  if (instance.userStatusDate != null) {
    json['userStatusDate'] = instance.userStatusDate;
  }
  if (instance.role != null) json['role'] = instance.role;
  if (instance.createdAt != null) json['createdAt'] = instance.createdAt;
  if (instance.updatedAt != null) json['updatedAt'] = instance.updatedAt;
  if (instance.createdBy != null) json['createdBy'] = instance.createdBy;
  if (instance.updatedBy != null) json['updatedBy'] = instance.updatedBy;
  if (instance.otpMethod != null) json['otpMethod'] = instance.otpMethod;
  if (instance.firstName != null) json['firstName'] = instance.firstName;
  if (instance.lastName != null) json['lastName'] = instance.lastName;
  if (instance.avatar != null) json['avatar'] = instance.avatar;
  if (instance.deviceToken != null) json['deviceToken'] = instance.deviceToken;
  if (instance.email != null) json['email'] = instance.email;
  if (instance.code != null) json['code'] = instance.code;
  if (instance.oldPassword != null) json['oldPassword'] = instance.oldPassword;
  if (instance.message != null) json['message'] = instance.message;
  if (instance.sector != null) json['sector'] = instance.sector;
  if (instance.redirectUri != null) json['redirect_uri'] = instance.redirectUri;
  if (instance.idToken != null) json['id_token'] = instance.idToken;
  if (instance.notification != null) {
    json['notification'] = instance.notification;
  }

  return json;
}
