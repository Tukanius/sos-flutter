import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sos/screens/Splash/index.dart';
import 'package:sos/screens/register/register_page.dart';
import 'package:sos/widgets/colors.dart';
import 'package:sos/widgets/custom_button.dart';
import '../../api/auth_api.dart';
import '../../components/social_login.dart';
import '../../main.dart';
import '../../models/user.dart';
import '../../provider/user_provider.dart';
import '../../services/navigation.dart';
import '../../widgets/form_textfield.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:after_layout/after_layout.dart';
import 'package:provider/provider.dart';
import '../forgot/forgot_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/loginpage";

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with AfterLayoutMixin<LoginPage> {
  GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();
  bool _isVisible = true;
  bool isSubmit = false;
  bool loading = false;
  bool saveIsUsername = false;
  final usernameController = TextEditingController();

  @override
  void afterFirstLayout(BuildContext context) async {
    String? username = await UserProvider().getUsername();

    if (username == null) {
      setState(() {
        username = username = "";
      });
      setState(() {
        saveIsUsername = false;
      });
    } else {
      setState(() {
        saveIsUsername = true;
      });
    }
    setState(() {
      usernameController.text = username.toString();
    });
  }

  googleLogin() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      setState(() {
        loading = true;
      });
      googleSignIn.signIn().then((result) {
        result!.authentication.then((googleKey) async {
          await AuthApi().socialLogin(
            User(
              type: "GOOGLE",
              accessToken: googleKey.accessToken,
              idToken: googleKey.idToken,
              redirectUri: googleRedirectUri,
            ),
          );
          locator<NavigationService>()
              .pushReplacementNamed(routeName: SplashPage.routeName);
          setState(() {
            loading = false;
          });
        }).catchError((err) {});
      }).catchError((err) {
        setState(() {
          loading = false;
        });
      });
    } catch (err) {
      debugPrint(err.toString());
      setState(() {
        loading = false;
      });
    }
  }

  facebookLogin() async {
    try {
      setState(() {
        loading = true;
      });
      LoginResult userData = await FacebookAuth.instance
          .login(permissions: ["public_profile", "email"]);
      await AuthApi().socialLogin(
        User(
          type: "FACEBOOK",
          accessToken: userData.accessToken!.token,
          redirectUri: fbRedirectUri,
        ),
      );
      locator<NavigationService>()
          .pushReplacementNamed(routeName: SplashPage.routeName);
      setState(() {
        loading = false;
      });
    } catch (err) {
      setState(() {
        loading = false;
      });
      debugPrint(err.toString());
    }
  }

  onSubmit() async {
    if (fbKey.currentState!.saveAndValidate()) {
      try {
        setState(() {
          isSubmit = true;
        });
        User save = User.fromJson(fbKey.currentState!.value);
        if (saveIsUsername == true) {
          UserProvider().setUsername(save.username.toString());
        } else {
          UserProvider().setUsername("");
        }
        await Provider.of<UserProvider>(context, listen: false).login(save);
        Navigator.of(context).pushReplacementNamed(SplashPage.routeName);
      } catch (e) {
        debugPrint(e.toString());
        setState(() {
          isSubmit = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: dark),
        backgroundColor: primaryColor,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                "Дархан хотод тавтай морил".toUpperCase().toString(),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Эрсдэлийг мэдэгд!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 30,
              ),
              FormBuilder(
                key: fbKey,
                child: Column(
                  children: [
                    FormTextField(
                      name: "username",
                      inputType: TextInputType.phone,
                      inputAction: TextInputAction.next,
                      maxLenght: 8,
                      textCapitalization: TextCapitalization.none,
                      controller: usernameController,
                      decoration: InputDecoration(
                        enabled: true,
                        counterText: "",
                        prefixIconColor: primaryGreen,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        disabledBorder: InputBorder.none,
                        filled: true,
                        hintStyle: const TextStyle(
                            color: Colors.black54, fontSize: 14),
                        hintText: "Утасны дугаар",
                        fillColor: white,
                      ),
                      validators: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Утасны дугаараа оруулна уу.')
                      ]),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    FormTextField(
                      name: "password",
                      inputAction: TextInputAction.next,
                      obscureText: _isVisible,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        enabled: true,
                        prefixIconColor: primaryGreen,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          },
                          icon: _isVisible
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: Colors.grey,
                                ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        disabledBorder: InputBorder.none,
                        filled: true,
                        hintStyle: const TextStyle(
                            color: Colors.black54, fontSize: 14),
                        hintText: "Нууц үг",
                        fillColor: white,
                      ),
                      validators: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Нууц үгээ оруулна уу.')
                      ]),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SaveNameCheck(
                    isSelected: saveIsUsername,
                    onChanged: (value) {
                      setState(() => saveIsUsername = !saveIsUsername);
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(ForgotPage.routeName);
                    },
                    child: const Text(
                      "Нууц үг сэргээх",
                      style: TextStyle(color: dark, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              CustomButton(
                width: double.infinity,
                onClick: () {
                  onSubmit();
                },
                color: orange,
                fontSize: 16,
                textColor: black,
                labelText: "Нэвтрэх",
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 35,
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: const BoxDecoration(gradient: gradientDark1),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Нэвтрэх боломжууд",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: const BoxDecoration(gradient: gradientDark2),
                    ),
                  ),
                  const SizedBox(
                    width: 35,
                  ),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        facebookLogin();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 2, color: white),
                        ),
                        child: SvgPicture.asset(
                          "assets/facebook.svg",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        googleLogin();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 2, color: white),
                        ),
                        child: SvgPicture.asset(
                          "assets/google.svg",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Хэрэглэгч биш бол",
                    style: TextStyle(fontSize: 12),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(RegisterPage.routeName);
                    },
                    child: Text(
                      "Бүртгүүлэх".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: orange,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SaveNameCheck extends StatefulWidget {
  final bool isSelected;
  final Function(bool) onChanged;
  const SaveNameCheck(
      {Key? key, this.isSelected = false, required this.onChanged})
      : super(key: key);

  @override
  _SaveNameCheckState createState() => _SaveNameCheckState();
}

class _SaveNameCheckState extends State<SaveNameCheck> {
  bool isSelected = false;
  @override
  void initState() {
    isSelected = widget.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        widget.onChanged(isSelected);
      },
      child: Row(
        children: [
          Icon(
            widget.isSelected ? Icons.check_circle : Icons.circle_outlined,
            color: orange,
            size: 20.0,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            'Нэвтрэх нэр хадгалах',
            style: TextStyle(
              fontSize: 14,
              color: black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
