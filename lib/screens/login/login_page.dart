import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sos/screens/Splash/index.dart';
import 'package:sos/screens/register/register_page.dart';
import 'package:sos/widgets/colors.dart';
import 'package:sos/widgets/custom_button.dart';
import '../../models/user.dart';
import '../../provider/user_provider.dart';
import '../../widgets/form_textfield.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:after_layout/after_layout.dart';
import 'package:provider/provider.dart';
import '../forgot/forgot_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/loginpage";

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with AfterLayoutMixin<LoginPage> {
  GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();

  bool isSubmit = false;

  @override
  void afterFirstLayout(BuildContext context) {}

  onSubmit() async {
    if (fbKey.currentState!.saveAndValidate()) {
      try {
        setState(() {
          isSubmit = true;
        });
        User save = User.fromJson(fbKey.currentState!.value);
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
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Lottie.asset(
                  'assets/sos.json',
                  height: 150,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Дархан хотод тавтай морил",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Эрсдэлийг мэдэгд!",
                style: TextStyle(fontSize: 12),
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
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        enabled: true,
                        prefixIconColor: primaryGreen,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        disabledBorder: InputBorder.none,
                        filled: true,
                        hintStyle: const TextStyle(
                            color: Colors.black54, fontSize: 14),
                        hintText: "Утасны дугаараа",
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
                      obscureText: true,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        enabled: true,
                        prefixIconColor: primaryGreen,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
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
              const SizedBox(
                height: 25,
              ),
              CustomButton(
                width: double.infinity,
                onClick: () {
                  onSubmit();
                },
                color: orange,
                textColor: black,
                labelText: "Нэвтрэх",
              ),
              const SizedBox(
                height: 25,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(ForgotPage.routeName);
                },
                child: const Text(
                  "Нууц үг сэргээх",
                  style: TextStyle(color: dark),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RegisterPage.routeName);
                },
                child: const Text(
                  "Бүртгүүлэх",
                  style: TextStyle(color: dark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
