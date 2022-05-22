import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sos/models/user.dart';
import 'package:sos/screens/forgot/forgot_password_change.dart';
import '../../provider/user_provider.dart';
import '../../widgets/colors.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/form_textfield.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class ForgotPage extends StatefulWidget {
  static const routeName = "/forgotpage";

  const ForgotPage({Key? key}) : super(key: key);

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  User user = User();
  bool? isLoading = false;

  forgot() async {
    setState(() {
      isLoading = true;
    });
    final form = user.fbKey.currentState!;

    if (form.saveAndValidate()) {
      user = User.fromJson(form.value);
      try {
        var res = await Provider.of<UserProvider>(context, listen: false)
            .forgot(user);
        Navigator.of(context).pushNamed(ForgotPasswordChange.routeName,
            arguments: ForgotPasswordChangeArguments(data: res));
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: dark),
        backgroundColor: primaryColor,
        elevation: 0.5,
        title: const Text(
          "Нууц үг сэргээх",
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
                    hintStyle:
                        const TextStyle(color: Colors.black54, fontSize: 14),
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
                  forgot();
                },
                color: orange,
                fontSize: 16,
                textColor: black,
                labelText: "Сэргээх",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
