import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:sos/provider/user_provider.dart';
import 'package:sos/screens/splash/index.dart';
import 'package:sos/widgets/colors.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import '../../models/user.dart';
import 'package:provider/provider.dart';
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

  @override
  void afterFirstLayout(BuildContext context) {
    print(widget.phone);
  }

  onVerify() async {
    otpCode = controller.text;
    try {
      await Provider.of<UserProvider>(context, listen: false)
          .verifyOtp(User(code: otpCode, phone: widget.phone));
      switch (widget.type) {
        case 'REGISTER':
          Navigator.of(context).pushReplacementNamed(SplashPage.routeName);
          break;

        default:
      }
    } on HttpHandler catch (_) {
      controller.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
