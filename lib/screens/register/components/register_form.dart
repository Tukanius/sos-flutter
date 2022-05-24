import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../../models/user.dart';
import '../../../../widgets/colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/form_textfield.dart';

class RegisterForm extends StatefulWidget {
  final Function? onSubmit;
  final User? user;
  final bool? isLoading;
  const RegisterForm({Key? key, this.user, this.onSubmit, this.isLoading})
      : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool showPassword = true;
  bool showconfirmPassword = true;
  bool _isVisible = true;
  bool _isVisible1 = true;
  bool isSubmit = false;

  @override
  void dispose() {
    super.dispose();
  }

  void togglePasswordView() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void toggleConfirmPassword() {
    setState(() {
      showconfirmPassword = !showconfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user!;
    return FormBuilder(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: user.fbKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormTextField(
            name: "phone",
            maxLenght: 8,
            textCapitalization: TextCapitalization.none,
            inputType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            inputAction: TextInputAction.next,
            decoration: InputDecoration(
              counterText: "",
              enabled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              filled: true,
              hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
              hintText: "Утасны дугаараа оруулна уу",
              fillColor: white,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Заавал оруулна';
              }
              if (value.trim().length < 8) {
                return 'Утасны дугаараа оруулна уу';
              }
              // Return null if the entered password is valid
              return null;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          FormTextField(
            name: "lastName",
            textCapitalization: TextCapitalization.none,
            inputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter(RegExp(r'[0-9]'), allow: false)
            ],
            decoration: InputDecoration(
              enabled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              filled: true,
              hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
              hintText: "Овог",
              fillColor: white,
            ),
            validators: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: "Заавал бөглөнө",
              ),
            ]),
          ),
          const SizedBox(
            height: 15,
          ),
          FormTextField(
            name: "firstName",
            textCapitalization: TextCapitalization.none,
            inputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter(RegExp(r'[0-9]'), allow: false)
            ],
            decoration: InputDecoration(
              enabled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              filled: true,
              hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
              hintText: "Нэр",
              fillColor: white,
            ),
            validators: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: "Заавал бөглөнө",
              ),
            ]),
          ),
          const SizedBox(
            height: 15,
          ),
          FormTextField(
            name: "password",
            inputType: TextInputType.text,
            inputAction: TextInputAction.next,
            obscureText: _isVisible,
            decoration: InputDecoration(
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              filled: true,
              hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
              hintText: "Нууц үгээ оруулна уу",
              fillColor: white,
            ),
            validators: FormBuilderValidators.compose([
              (value) {
                return validatePassword(value.toString(), context);
              }
            ]),
          ),
          const SizedBox(
            height: 15,
          ),
          FormTextField(
            name: "password_verify",
            inputType: TextInputType.text,
            inputAction: TextInputAction.done,
            obscureText: _isVisible1,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isVisible1 = !_isVisible1;
                  });
                },
                icon: _isVisible1
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              filled: true,
              hintStyle: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
              hintText: "Нууц үгээ давтан оруулна уу",
              fillColor: white,
            ),
            validators: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                  errorText: "Нууц үгээ давтан оруулна уу"),
              (value) {
                final String pVal =
                    user.fbKey.currentState?.fields['password']?.value;
                return pVal != value
                    ? 'Оруулсан нууц үгтэй таарахгүй байна'
                    : null;
              }
            ]),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: CustomButton(
              width: MediaQuery.of(context).size.width,
              onClick: () {
                if (widget.isLoading == false) {
                  widget.onSubmit!();
                }
              },
              color: orange,
              customWidget: const Text(
                "Бүртгүүлэх",
                style: TextStyle(color: black, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}

String? validatePassword(String value, context) {
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~?]).{8,}$');
  if (value.isEmpty) {
    return 'Нууц үгээ оруулна уу';
  } else {
    if (!regex.hasMatch(value)) {
      return 'Нууц үг тохирохгүй байна';
    } else {
      return null;
    }
  }
}
