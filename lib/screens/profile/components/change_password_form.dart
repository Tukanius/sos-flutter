import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sos/models/user.dart';
import 'package:sos/widgets/colors.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/form_textfield.dart';
import '../../register/components/register_form.dart';

class ChangePasswordForm extends StatefulWidget {
  final User user;
  final Function onSubmit;
  final String? type;
  final bool isLoading;
  const ChangePasswordForm({
    Key? key,
    required this.user,
    required this.onSubmit,
    required this.isLoading,
    this.type,
  }) : super(key: key);

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  bool _isVisible = true;
  bool _isVisible1 = true;
  bool oldPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.user.fbKey,
      child: Column(
        children: [
          widget.type == "FORGOT"
              ? const SizedBox()
              : FormTextField(
                  name: "oldPassword",
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  obscureText: oldPasswordVisible,
                  controller: widget.user.oldPasswordController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          oldPasswordVisible = !oldPasswordVisible;
                        });
                      },
                      icon: oldPasswordVisible
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    filled: true,
                    hintStyle:
                        const TextStyle(color: Colors.black54, fontSize: 14),
                    hintText: "Хуучин нууц үг",
                    fillColor: white,
                  ),
                  validators: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Заавал оруулна"),
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
              hintText: "Шинэ нууц үг",
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
              hintText: "Шинэ нууц үгээ давтан оруулна уу",
              fillColor: white,
            ),
            validators: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                  errorText: "Шинэ нууц үгээ давтан оруулна уу"),
              (value) {
                final String pVal =
                    widget.user.fbKey.currentState?.fields['password']?.value;
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
                  widget.onSubmit();
                }
              },
              color: orange,
              customWidget: const Text(
                "Солих",
                style: TextStyle(color: black, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
