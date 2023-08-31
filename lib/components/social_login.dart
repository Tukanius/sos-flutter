import 'package:flutter/material.dart';

class SocialLogin extends StatefulWidget {
  final String type;
  const SocialLogin({Key? key, required this.type}) : super(key: key);

  @override
  State<SocialLogin> createState() => _SocialLoginState();
}

String fbClientId = "991625551494669";
String fbRedirectUri = "https://dev-sos.zto.mn/web/auth/facebook";

String googleClientId =
    "273002303620-lsnv0cp8f8qm2rf6s2iv4i3ogc4e54ms.apps.googleusercontent.com";
String googleRedirectUri = "https://dev-sos.zto.mn/web/auth/google";

class _SocialLoginState extends State<SocialLogin> {
  String facebookLoginUri =
      "https://www.facebook.com/v13.0/dialog/oauth?client_id=$fbClientId&redirect_uri=$fbRedirectUri&scope=email&response_type=code&auth_type=rerequest&display=popup";
  String googleLoginUri =
      "https://accounts.google.com/o/oauth2/v2/auth?client_id=$googleClientId&redirect_uri=$googleRedirectUri&scope=email%openid'&response_type=code&auth_type=rerequest&display=popup";
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
