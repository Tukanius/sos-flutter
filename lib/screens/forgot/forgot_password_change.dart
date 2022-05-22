import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:sos/screens/profile/screens/change_password.dart';
import 'package:sos/widgets/colors.dart';
import '../../provider/user_provider.dart';
import '../../utils/http_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../models/user.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class ForgotPasswordChangeArguments {
  User? data;
  ForgotPasswordChangeArguments({this.data});
}

class ForgotPasswordChange extends StatefulWidget {
  static const routeName = "/forgotpasswordchange";

  final User? data;

  const ForgotPasswordChange({Key? key, this.data}) : super(key: key);

  @override
  State<ForgotPasswordChange> createState() => _ForgotPasswordChangeState();
}

class _ForgotPasswordChangeState extends State<ForgotPasswordChange>
    with AfterLayoutMixin {
  TextEditingController controller = TextEditingController();
  User otp = User();
  String code = "";
  bool isLoading = false;
  bool hasError = false;
  bool oldPasswordVisible = false;

  @override
  void afterFirstLayout(BuildContext context) {}

  // show(ctx) async {
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) {
  //         return Container(
  //           alignment: Alignment.center,
  //           margin: const EdgeInsets.symmetric(horizontal: 20),
  //           child: Stack(
  //             alignment: Alignment.topCenter,
  //             children: <Widget>[
  //               Container(
  //                 margin: const EdgeInsets.only(top: 75),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 padding: const EdgeInsets.only(top: 90, left: 20, right: 20),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: <Widget>[
  //                     const Text(
  //                       'Амжилттай',
  //                       style: TextStyle(
  //                           color: dark,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 24),
  //                     ),
  //                     const SizedBox(
  //                       height: 16,
  //                     ),
  //                     const Text(
  //                       'Нууц үг амжилттай шинэчлэгдлээ',
  //                     ),
  //                     ButtonBar(
  //                       buttonMinWidth: 100,
  //                       alignment: MainAxisAlignment.spaceEvenly,
  //                       children: <Widget>[
  //                         TextButton(
  //                           child: const Text("Үргэлжлүүлэх"),
  //                           onPressed: () {
  //                             Navigator.of(context).pop();
  //                             locator<NavigationService>().pushReplacementNamed(
  //                               routeName: SplashPage.routeName,
  //                             );
  //                           },
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Lottie.asset('assets/success.json', height: 150, repeat: false),
  //             ],
  //           ),
  //         );
  //       });
  // }

  onVerify() async {
    setState(() {
      isLoading == true;
    });
    final form = widget.data!.fbKey.currentState;
    if (widget.data!.fbKey.currentState!.saveAndValidate()) {
      if (form?.saveAndValidate() ?? false) {
        setState(() {
          isLoading = true;
        });
        try {
          var send = controller.text;
          print("================SEND=================");
          print(send);
          print("================SEND=================");
          await Provider.of<UserProvider>(context, listen: false)
              .otpPassword(User(code: send));
          Navigator.of(context).pushNamed(ChangePasswordPage.routeName,
              arguments: ChangePasswordPageArguments(type: "FORGOT"));
          // show(context);
          setState(
            () {
              isLoading = false;
            },
          );
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: dark),
        elevation: 0.0,
        backgroundColor: primaryColor,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
              child: FormBuilder(
                key: widget.data!.fbKey,
                child: Column(
                  children: [
                    const Text(
                      "Баталгаажуулалт",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: dark,
                          fontSize: 24),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      '${widget.data!.message}',
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: dark,
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    PinCodeTextField(
                      autofocus: true,
                      controller: controller,
                      hideCharacter: true,
                      highlight: true,
                      highlightColor: orange,
                      defaultBorderColor: greyDark,
                      hasTextBorderColor: grey,
                      highlightPinBoxColor: white,
                      pinBoxRadius: 10,
                      maxLength: 4,
                      hasError: hasError,
                      onTextChanged: (text) {
                        setState(() {
                          hasError = false;
                        });
                      },
                      onDone: (text) {
                        if (isLoading == false) {
                          onVerify();
                        }
                      },
                      pinBoxWidth: 50,
                      pinBoxHeight: 64,
                      hasUnderline: false,
                      wrapAlignment: WrapAlignment.spaceAround,
                      pinBoxDecoration:
                          ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                      pinTextStyle: const TextStyle(fontSize: 22.0),
                      pinTextAnimatedSwitcherTransition:
                          ProvidedPinBoxTextAnimation.scalingTransition,
                      pinTextAnimatedSwitcherDuration:
                          const Duration(milliseconds: 300),
                      highlightAnimationBeginColor: Colors.black,
                      highlightAnimationEndColor: Colors.white12,
                      keyboardType: TextInputType.number,
                    ),
                    // const SizedBox(
                    //   height: 25,
                    // ),
                    // FormTextField(
                    //   name: "password",
                    //   inputType: TextInputType.text,
                    //   inputAction: TextInputAction.next,
                    //   obscureText: _isVisible,
                    //   decoration: InputDecoration(
                    //     suffixIcon: IconButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           _isVisible = !_isVisible;
                    //         });
                    //       },
                    //       icon: _isVisible
                    //           ? const Icon(
                    //               Icons.visibility_off,
                    //               color: Colors.black,
                    //             )
                    //           : const Icon(
                    //               Icons.visibility,
                    //               color: Colors.grey,
                    //             ),
                    //     ),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //     contentPadding: const EdgeInsets.symmetric(
                    //         horizontal: 15, vertical: 15),
                    //     filled: true,
                    //     hintStyle: const TextStyle(
                    //         color: Colors.black54, fontSize: 14),
                    //     hintText: "Шинэ нууц үг",
                    //     fillColor: white,
                    //   ),
                    //   validators: FormBuilderValidators.compose([
                    //     (value) {
                    //       return validatePassword(value.toString(), context);
                    //     }
                    //   ]),
                    // ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    // FormTextField(
                    //   name: "password_verify",
                    //   inputType: TextInputType.text,
                    //   inputAction: TextInputAction.done,
                    //   obscureText: _isVisible1,
                    //   decoration: InputDecoration(
                    //     suffixIcon: IconButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           _isVisible1 = !_isVisible1;
                    //         });
                    //       },
                    //       icon: _isVisible1
                    //           ? const Icon(
                    //               Icons.visibility_off,
                    //               color: Colors.black,
                    //             )
                    //           : const Icon(
                    //               Icons.visibility,
                    //               color: Colors.grey,
                    //             ),
                    //     ),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //     contentPadding: const EdgeInsets.symmetric(
                    //         horizontal: 15, vertical: 15),
                    //     filled: true,
                    //     hintStyle: const TextStyle(
                    //       color: Colors.black54,
                    //       fontSize: 14,
                    //     ),
                    //     hintText: "Шинэ нууц үгээ давтан оруулна уу",
                    //     fillColor: white,
                    //   ),
                    //   validators: FormBuilderValidators.compose([
                    //     FormBuilderValidators.required(
                    //         errorText: "Шинэ нууц үгээ давтан оруулна уу"),
                    //     (value) {
                    //       final String pVal = widget.data!.fbKey.currentState
                    //           ?.fields['password']?.value;
                    //       return pVal != value
                    //           ? 'Оруулсан нууц үгтэй таарахгүй байна'
                    //           : null;
                    //     }
                    //   ]),
                    // ),
                    // const SizedBox(
                    //   height: 25,
                    // ),
                    // CustomButton(
                    //   width: MediaQuery.of(context).size.width,
                    //   onClick: () {
                    //     if (isLoading == false) {
                    //       onVerify();
                    //     }
                    //   },
                    //   color: orange,
                    //   customWidget: const Text(
                    //     "Солих",
                    //     style: TextStyle(color: black, fontSize: 16),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
