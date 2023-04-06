import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:sos/api/general_api.dart';
import 'package:sos/models/result.dart';
import 'package:sos/screens/profile/screens/components/accordion.dart';
import 'package:sos/widgets/colors.dart';

class FaqPage extends StatefulWidget {
  static const routeName = "/FaqPage";

  const FaqPage({Key? key}) : super(key: key);

  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> with AfterLayoutMixin {
  bool loading = true;
  int page = 1;
  int limit = 10;
  Result? faqList = Result(count: 0, rows: []);

  @override
  void afterFirstLayout(BuildContext context) async {
    await faq(page, limit);
  }

  Future<List<dynamic>?> faq(int page, int limit) async {
    Offset offset = Offset(limit: limit, page: page);
    Result res = await GeneralApi()
        .list(ResultArguments(filter: Filter(), offset: offset));
    setState(() {
      faqList = res;
      loading = false;
    });
    return res.rows;
  }

  @override
  Widget build(BuildContext context) {
    return loading == true
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
                "Түгээмэл асуултууд",
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
              child: Column(
                children: [
                  for (var i = 0; i < faqList!.rows!.length; i++)
                    Accordion(
                      title: faqList!.rows![i].title.toString(),
                      content: faqList!.rows![i].body.toString(),
                    ),
                ],
              ),
            ),
          );
  }
}
