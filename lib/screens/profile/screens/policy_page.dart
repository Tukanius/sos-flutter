import 'package:flutter/material.dart';
import 'package:sos/models/about.dart';
import 'package:sos/api/page_api.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sos/widgets/colors.dart';

class PolicyPage extends StatefulWidget {
  static const routeName = "/PolicyPage";
  const PolicyPage({Key? key}) : super(key: key);

  @override
  _PolicyPageState createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> with AfterLayoutMixin {
  About about = About();
  bool isLoading = true;

  @override
  void afterFirstLayout(BuildContext context) async {
    about = await PageApi().getAbout();
    setState(() {
      isLoading = false;
    });
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Container(
            color: white,
            child: Center(
              child: Container(
                height: 40,
                width: 40,
                margin: EdgeInsets.all(5),
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation(Colors.orange),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0.1,
              backgroundColor: white,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: const Text(
                "Нууцлалын журам",
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
            body: isLoading == false
                ? SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          if (about.policy != null)
                            Html(
                              data: about.policy,
                            ),
                        ],
                      ),
                    ),
                  )
                : const SpinKitCircle(
                    size: 25,
                    color: black,
                  ),
          );
  }
}
