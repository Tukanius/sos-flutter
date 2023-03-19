import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sos/api/general_api.dart';
import 'package:sos/models/about.dart';
import '../../../../models/user.dart';
import '../../../../widgets/colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/form_textfield.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter_html/flutter_html.dart';

class RegisterForm extends StatefulWidget {
  final Function? onSubmit;
  final User? user;
  final bool? isLoading;
  const RegisterForm({Key? key, this.user, this.onSubmit, this.isLoading})
      : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> with AfterLayoutMixin {
  bool showPassword = true;
  bool showconfirmPassword = true;
  bool _isVisible = true;
  bool _isVisible1 = true;
  bool isSubmit = false;
  bool _isPasswordEightCharacters = false;
  bool _hasUptext = false;
  bool _hasPasswordOneNumber = false;
  bool ternAndCondition = false;
  bool isError = false;
  ScrollController scrollController = ScrollController();
  About about = About();
  String? pVal;

  @override
  void afterFirstLayout(BuildContext context) async {
    about = await GeneralApi().getAbout();
  }

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
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (isTop) {
          print('At the top');
        } else {
          print('At the bottom');
        }
      }
    });
    super.initState();
  }

  onClick() async {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      enableDrag: false,
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.95,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0.1,
              backgroundColor: white,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: const Text(
                "Үйлчилгээний нөхцөл",
                style: TextStyle(
                  fontSize: 16,
                  color: dark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: dark,
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              controller: scrollController,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Html(
                      data: about.terms,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    final upTextRegex = RegExp(r'(?=.*[A-Z])');

    setState(() {
      _hasUptext = false;
      if (upTextRegex.hasMatch(password)) _hasUptext = true;

      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) _hasPasswordOneNumber = true;

      _isPasswordEightCharacters = false;
      if (password.length >= 8) _isPasswordEightCharacters = true;
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
            validators: FormBuilderValidators.compose([
              (value) {
                return validatePhone(value.toString(), context);
              }
            ]),
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
            onChanged: (password) => onPasswordChanged(password),
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
                pVal = user.fbKey.currentState?.fields['password']?.value;
                return pVal == null
                    ? ""
                    : pVal != value
                        ? 'Оруулсан нууц үгтэй таарахгүй байна'
                        : null;
              }
            ]),
          ),
          const SizedBox(
            height: 15,
          ),
          Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: orange,
            ),
            child: FormBuilderCheckbox(
              key: const ValueKey(4),
              name: 'accept_terms',
              checkColor: primaryColor,
              activeColor: orange,
              controlAffinity: ListTileControlAffinity.leading,
              initialValue: false,
              onChanged: (value) {
                setState(() {
                  ternAndCondition = !ternAndCondition;
                });
              },
              title: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Та',
                      style: TextStyle(color: dark),
                    ),
                    WidgetSpan(
                      child: InkWell(
                        onTap: () {
                          onClick();
                        },
                        child: const Text(
                          ' ЭНД ',
                          style: TextStyle(color: orange),
                        ),
                      ),
                    ),
                    const TextSpan(
                      text:
                          'дарж үйлчилгээний нөхцөлтэй танилцаад зөвшөөрч буй бол чагтлана уу.',
                      style: TextStyle(color: dark),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: CustomButton(
              width: MediaQuery.of(context).size.width,
              onClick: () {
                if (ternAndCondition == true) {
                  setState(() {
                    isError = false;
                  });
                } else {
                  setState(() {
                    isError = true;
                  });
                }
                if (isError == false) {
                  if (widget.isLoading == false) {
                    widget.onSubmit!();
                    setState(() {
                      isError = false;
                    });
                  } else {
                    setState(() {
                      isError = true;
                    });
                  }
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
  RegExp regex = RegExp(r'^.{6,20}$');
  if (value.isEmpty) {
    return 'Нууц үгээ оруулна уу';
  } else {
    if (!regex.hasMatch(value)) {
      return 'Нууц үг нь дор хаяж 6 тэмдэгтээс бүрдэх ёстой';
    } else {
      return null;
    }
  }
}

String? validatePhone(String value, context) {
  RegExp regex = RegExp(r'[(9|8]{1}[0-9]{7}$');
  if (value.isEmpty) {
    return 'Утасны дугаараа оруулна уу';
  } else {
    if (!regex.hasMatch(value)) {
      return 'Утасны дугаараа шалгана уу';
    } else {
      return null;
    }
  }
}
