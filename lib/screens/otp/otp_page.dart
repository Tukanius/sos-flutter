import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sos/main.dart';
import 'package:sos/provider/user_provider.dart';
import 'package:sos/screens/splash/index.dart';
import 'package:sos/widgets/colors.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import '../../api/auth_api.dart';
import '../../models/user.dart';
import 'package:provider/provider.dart';
import '../../services/navigation.dart';
import '../../utils/http_handler.dart';

class OtpVerifyPageArguments {
  String? type;
  User? data;
  String? phone;
  OtpVerifyPageArguments({this.type, this.data, this.phone});
}

class OtpVerifyPage extends StatefulWidget {
  static const routeName = "/OtpVerifyPage";
  final String? type;
  final User? data;
  final String? phone;

  const OtpVerifyPage({
    Key? key,
    this.type,
    this.data,
    this.phone,
  }) : super(key: key);

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage>
    with TickerProviderStateMixin, AfterLayoutMixin<OtpVerifyPage> {
  TextEditingController controller = TextEditingController();
  User otp = User();
  String otpCode = "";
  bool isLoading = false;
  bool hasError = false;
  User user = User();
  bool isGetCode = false;
  int _counter = 120;
  late Timer _timer;
  bool isSubmit = false;
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

  @override
  void afterFirstLayout(BuildContext context) {}

  show(ctx) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 75),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.only(top: 90, left: 20, right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'Амжилттай',
                        style: TextStyle(
                            color: dark,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Таны бүртгэл амжилттай үүслээ.',
                        textAlign: TextAlign.center,
                      ),
                      ButtonBar(
                        buttonMinWidth: 100,
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          TextButton(
                            child: const Text(
                              "Нэвтрэх",
                              style: TextStyle(color: dark),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              UserProvider().logout();
                              Navigator.of(ctx).pop();
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Lottie.asset('assets/success.json', height: 150, repeat: false),
              ],
            ),
          );
        });
  }

  otpshow(ctx) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 75),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.only(top: 90, left: 20, right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'Амжилттай',
                        style: TextStyle(
                            color: dark,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Таны бүртгэл амжилттай үүслээ.',
                        textAlign: TextAlign.center,
                      ),
                      ButtonBar(
                        buttonMinWidth: 100,
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          TextButton(
                            child: const Text(
                              "Нэвтрэх",
                              style: TextStyle(color: dark),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await UserProvider().clearSessionScopen();
                              locator<NavigationService>()
                                  .restorablePopAndPushNamed(
                                      routeName: SplashPage.routeName);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Lottie.asset('assets/success.json', height: 150, repeat: false),
              ],
            ),
          );
        });
  }

  onVerify() async {
    otpCode = controller.text;
    try {
      if (widget.type == "SOCIAL") {
        await Provider.of<UserProvider>(context, listen: false)
            .otpSocial(User(code: otpCode));
      } else {
        await Provider.of<UserProvider>(context, listen: false)
            .verifyOtp(User(code: otpCode, phone: widget.phone));
      }

      switch (widget.type) {
        case 'REGISTER':
          show(context);
          break;
        default:
          otpshow(context);
      }
    } on HttpHandler catch (_) {
      controller.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
              child: Column(
                children: [
                  const Text(
                    "Баталгаажуулалт",
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: dark, fontSize: 24),
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
                                color: Colors.black,
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
          ],
        ),
      ),
    );
  }
}
