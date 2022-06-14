import 'package:flutter/material.dart';
import 'package:sos/screens/otp/otp_page.dart';
import 'package:sos/screens/register/components/register_form.dart';
import 'package:sos/utils/http_handler.dart';
import 'package:sos/widgets/colors.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:lottie/lottie.dart';
import '../../models/user.dart';
import '../../provider/user_provider.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = "/registerpage";

  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();
  User user = User();
  bool? isLoading = false;

  onSubmit() async {
    final form = user.fbKey.currentState;
    if (form?.saveAndValidate() ?? false) {
      try {
        setState(() {
          isLoading = true;
        });
        User data = User.fromJson(form!.value);
        User code = await Provider.of<UserProvider>(context, listen: false)
            .register(data);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pushNamed(OtpVerifyPage.routeName,
            arguments: OtpVerifyPageArguments(
                type: "REGISTER", data: code, phone: data.phone));
      } on HttpHandler catch (err) {
        debugPrint(err.toString());
        setState(() {
          isLoading = false;
        });
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: dark),
        backgroundColor: primaryColor,
        elevation: 0.5,
        title: const Text(
          "Бүртгүүлэх",
          style: TextStyle(color: dark, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                "Бүртгүүлэх",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              RegisterForm(
                onSubmit: onSubmit,
                isLoading: isLoading,
                user: user,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
