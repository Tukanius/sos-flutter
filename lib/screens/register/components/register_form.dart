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
  bool _isPasswordEightCharacters = false;
  bool _hasUptext = false;
  bool _hasPasswordOneNumber = false;
  bool ternAndCondition = false;
  bool isError = false;
  ScrollController scrollController = ScrollController();

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
                    const Text(
                      "Бид Meta-д ямар мэдээлэл цуглуулж, хэрхэн ашиглаж, хуваалцаж байгааг ойлгохыг хүсч байна. Тиймээс бид таныг манай Нууцлалын бодлогыг уншихыг зөвлөж байна. Энэ нь танд Мета бүтээгдэхүүнийг өөрт тохирсон байдлаар ашиглахад тусална. Нууцлалын бодлогод бид мэдээллийг хэрхэн цуглуулах, ашиглах, хуваалцах, хадгалах, шилжүүлэх талаар тайлбарладаг. Мөн бид танд эрхээ мэдэгдэнэ. Бодлогын хэсэг бүр нь бидний дадлагыг ойлгоход хялбар болгох үүднээс тустай жишээнүүд болон энгийн хэллэгийг агуулдаг. Мөн бид таны сонирхсон нууцлалын сэдвүүдийн талаар илүү ихийг мэдэх боломжтой эх сурвалжуудын холбоосыг нэмсэн. Та өөрийн нууцлалыг хэрхэн хянахаа мэддэг байх нь бидний хувьд чухал тул бид таны ашигладаг Мета Бүтээгдэхүүний тохиргооноос мэдээллээ хаанаас удирдах боломжтойг харуулах болно. Та туршлагаа бүрдүүлж чадна. Доорх бодлогыг бүрэн эхээр нь уншина уу.",
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: CustomButton(
                        width: MediaQuery.of(context).size.width,
                        onClick: () {
                          setState(() {
                            ternAndCondition = true;
                            isError = false;
                          });
                          Navigator.of(context).pop();
                        },
                        color: orange,
                        customWidget: const Text(
                          "Зөвшөөрөх",
                          style: TextStyle(color: black, fontSize: 16),
                        ),
                      ),
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
          Container(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          color: _isPasswordEightCharacters
                              ? Colors.green
                              : Colors.transparent,
                          border: _isPasswordEightCharacters
                              ? Border.all(color: Colors.transparent)
                              : Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color:
                              _isPasswordEightCharacters ? Colors.white : dark,
                          size: 12,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Багадаа 8 үсэг тоо тэмдэгт байх хэрэгтэй.",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
                const SizedBox(
                  height: 7,
                ),
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          color: _hasPasswordOneNumber
                              ? Colors.green
                              : Colors.transparent,
                          border: _hasPasswordOneNumber
                              ? Border.all(color: Colors.transparent)
                              : Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color: _hasPasswordOneNumber ? Colors.white : dark,
                          size: 12,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Багадаа 1 тоо байх хэрэгтэй.",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
                const SizedBox(
                  height: 7,
                ),
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          color: _hasUptext ? Colors.green : Colors.transparent,
                          border: _hasUptext
                              ? Border.all(color: Colors.transparent)
                              : Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color: _hasUptext ? Colors.white : dark,
                          size: 12,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Багадаа 1 том үсэг байх хэрэгтэй.",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ],
            ),
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
          InkWell(
            onTap: () {
              onClick();

              // setState(() {
              //   ternAndCondition = !ternAndCondition;
              // });
            },
            child: Row(
              children: [
                Icon(
                  ternAndCondition == true
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: isError == true ? red : orange,
                  size: 20.0,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Үйлчилгээний нөхцөл зөвшөөрөх',
                  style: TextStyle(
                    fontSize: 14,
                    color: isError == true ? red : black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                GestureDetector(
                  onTap: () {
                    onClick();
                  },
                  child: Text(""),
                ),
              ],
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
                  print("========ternAndCondition=========");
                  if (widget.isLoading == false) {
                    print("========ONSUBMIT=========");
                    widget.onSubmit!();
                    setState(() {
                      isError = false;
                    });
                    print("========isError=========");
                  } else {
                    setState(() {
                      isError = true;
                    });
                    print("========isError2=========");
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
  RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
  if (value.isEmpty) {
    return 'Нууц үгээ оруулна уу';
  } else {
    if (!regex.hasMatch(value)) {
      return 'Доорх шаардлагыг хангасан нууц үг үүсгэнэ үү';
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
