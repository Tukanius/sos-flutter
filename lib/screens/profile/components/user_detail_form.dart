import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../../models/user.dart';
import '../../../../widgets/colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/form_textfield.dart';

class UserDetailForm extends StatefulWidget {
  final Function? onSubmit;
  final User? user;
  final bool? isLoading;
  const UserDetailForm({Key? key, this.user, this.onSubmit, this.isLoading})
      : super(key: key);

  @override
  _UserDetailFormState createState() => _UserDetailFormState();
}

class _UserDetailFormState extends State<UserDetailForm> {
  bool showPassword = true;
  bool showconfirmPassword = true;
  bool isSubmit = false;

  @override
  Widget build(BuildContext context) {
    User user = widget.user!;
    return FormBuilder(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: user.fbKey,
      initialValue: {
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormTextField(
            name: "firstName",
            textCapitalization: TextCapitalization.none,
            inputAction: TextInputAction.next,
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
            name: "lastName",
            textCapitalization: TextCapitalization.none,
            inputAction: TextInputAction.next,
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
          // FormTextField(
          //   name: "email",
          //   textCapitalization: TextCapitalization.none,
          //   inputAction: TextInputAction.next,
          //   decoration: InputDecoration(
          //     enabled: true,
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(10),
          //       borderSide: BorderSide.none,
          //     ),
          //     contentPadding:
          //         const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          //     filled: true,
          //     hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
          //     hintText: "И-мейл",
          //     fillColor: white,
          //   ),
          //   validators: FormBuilderValidators.compose([
          //     FormBuilderValidators.required(
          //       errorText: "И-мейлээ оруулна уу",
          //     ),
          //     (dynamic value) {
          //       return isEmail(value.toString())
          //           ? null
          //           : "Мэйл хаяг оруулна уу!";
          //     }
          //   ]),
          // ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: CustomButton(
              onClick: () {
                if (widget.isLoading == false) {
                  widget.onSubmit!();
                }
              },
              color: orange,
              customWidget: const Text(
                "Засах",
                style: TextStyle(color: black, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

bool isEmail(String str) {
  return RegExp(emailRegex).hasMatch(str);
}

const String emailRegex =
    r"^((([a-zA-Z]|\d|[!#\$%&'*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-zA-Z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-zA-Z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-zA-Z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-zA-Z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-zA-Z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-zA-Z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-zA-Z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-zA-Z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-zA-Z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";

String? validatePassword(String value, context) {
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  if (value.isEmpty) {
    return 'Нууц үгээ оруулна уу';
  } else {
    if (!regex.hasMatch(value)) {
      return 'Нууц үг багадаа 1 том үсэг 1 тэмдэгт авна';
    } else {
      return null;
    }
  }
}
