import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sos/provider/user_provider.dart';
import 'package:sos/screens/otp/otp_page.dart';
import 'package:sos/screens/splash/index.dart';
import '../../models/user.dart';
import '../../widgets/colors.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/form_textfield.dart';
import 'package:lottie/lottie.dart';

class PhoneAskPage extends StatefulWidget {
  static const routeName = "/phoneaskpage";

  const PhoneAskPage({Key? key}) : super(key: key);

  @override
  State<PhoneAskPage> createState() => _PhoneAskPageState();
}

class _PhoneAskPageState extends State<PhoneAskPage> {
  User user = User();
  bool? isLoading = false;

  onSubmit() async {
    setState(() {
      isLoading = true;
    });
    final form = user.fbKey.currentState!;
    if (form.saveAndValidate()) {
      user = User.fromJson(form.value);
      try {
        var res = await Provider.of<UserProvider>(context, listen: false)
            .otpSocial(user);
        Navigator.of(context).pushNamed(OtpVerifyPage.routeName,
            arguments: OtpVerifyPageArguments(data: res));
      } catch (err) {
        debugPrint(err.toString());
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: dark),
            backgroundColor: primaryColor,
            elevation: 0.5,
            title: const Text(
              "Баталгаажуулалт",
              style: TextStyle(color: dark, fontSize: 16),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
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
                    "Манай апп-ыг хэрэглэхийн тулд утасны дугаараа баталгаажуулсан байх шаардлагатай.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FormBuilder(
                    key: user.fbKey,
                    child: FormTextField(
                      name: "phone",
                      inputType: TextInputType.phone,
                      maxLenght: 8,
                      inputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        enabled: true,
                        counterText: "",
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
                        hintText: "Утасны дугаар",
                        fillColor: white,
                      ),
                      validators: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Утасны дугаараа оруулна уу.')
                      ]),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomButton(
                    width: double.infinity,
                    onClick: () {
                      if (isLoading == false) {
                        onSubmit();
                      }
                    },
                    color: orange,
                    fontSize: 16,
                    textColor: black,
                    labelText: "Баталгаажуулах",
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          await UserProvider().clearSessionScopen();
          await UserProvider().clearAccessToken();
          Navigator.of(context).pushReplacementNamed(SplashPage.routeName);
          return true;
        });
  }
}
