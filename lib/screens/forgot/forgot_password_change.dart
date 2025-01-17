import 'dart:async';

import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:sos/screens/profile/screens/change_password.dart';
import 'package:sos/widgets/colors.dart';
import '../../api/auth_api.dart';
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
  late Timer _timer;
  bool isGetCode = false;
  int _counter = 120;
  bool isSubmit = false;

  @override
  void afterFirstLayout(BuildContext context) {}

  void getCode() async {
    var res = await AuthApi().resend();
    setState(() {
      widget.data!.message = res.message!;
    });
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  void _startTimer() async {
    if (isSubmit == true) {
      setState(() {
        isGetCode = false;
      });
      getCode();
      _counter = 120;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_counter > 0) {
          setState(() {
            _counter--;
          });
        } else {
          setState(() {
            isGetCode = true;
          });
          _timer.cancel();
        }
      });
    } else {
      setState(() {
        isGetCode = false;
      });
      _counter = 120;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_counter > 0) {
          setState(() {
            _counter--;
          });
        } else {
          setState(() {
            isGetCode = true;
          });
          _timer.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String intToTimeLeft(int value) {
    int h, m, s;
    h = value ~/ 3600;
    m = ((value - h * 3600)) ~/ 60;
    s = value - (h * 3600) - (m * 60);
    String result = "$m:$s";
    return result;
  }

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
          await Provider.of<UserProvider>(context, listen: false)
              .otpPassword(User(code: send));
          Navigator.of(context).pushReplacementNamed(
              ChangePasswordPage.routeName,
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
                      height: 10,
                    ),
                    if (isGetCode == false)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Дахин код авах',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: greyDark),
                          ),
                          Text(
                            '0${intToTimeLeft(_counter)} ',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: orange),
                          ),
                          const Text(
                            'секунд',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: greyDark),
                          ),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isSubmit = true;
                              });
                              _startTimer();
                            },
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.refresh,
                                  color: Colors.orange,
                                ),
                                Text(
                                  "Код дахин авах",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
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
