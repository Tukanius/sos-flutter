import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sos/models/sector.dart';

import '../utils/http_request.dart';
part '../parts/user.dart';

class User {
  final GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();
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
  String? email;
  String? deviceToken;
  Sector? sector;

  String? oldPassword;
  String? code;

  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();

  final passwordVerifyController = TextEditingController();
  final passwordVerifyFocusNode = FocusNode();

  final oldPasswordController = TextEditingController();
  final oldPasswordFocusNode = FocusNode();

  final refuseController = TextEditingController();
  final refuseFocusNode = FocusNode();

  String? type;
  String? message;

  final firstNameController = TextEditingController();
  final firstNameFocusNode = FocusNode();

  final lastNameController = TextEditingController();
  final lastNameFocusNode = FocusNode();

  final phoneController = TextEditingController();
  final phoneFocusNode = FocusNode();

  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  final stateController = TextEditingController();
  final stateFocusNode = FocusNode();

  final cityController = TextEditingController();
  final cityFocusNode = FocusNode();

  final countryController = TextEditingController();
  final countryFocusNode = FocusNode();

  final postController = TextEditingController();
  final postFocusNode = FocusNode();

  final addressController = TextEditingController();
  final addressFocusNode = FocusNode();

  final apartmentController = TextEditingController();
  final apartmentFocusNode = FocusNode();

  final pinController = TextEditingController();
  final verifyPinController = TextEditingController();
  final oldPinConroller = TextEditingController();
  final codeController = TextEditingController();
  final pinFocusNode = FocusNode();

  getAvatar() {
    return HttpRequest.s3host + avatar.toString();
  }

  User(
      {this.username,
      this.password,
      this.accessToken,
      this.tokenType,
      this.sessionState,
      this.isActive,
      this.userStatus,
      this.status,
      this.id,
      this.phone,
      this.userStatusDate,
      this.role,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.otpMethod,
      this.firstName,
      this.lastName,
      this.avatar,
      this.deviceToken,
      this.email,
      this.code,
      this.oldPassword,
      this.message,
      this.sector});

  static $fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
