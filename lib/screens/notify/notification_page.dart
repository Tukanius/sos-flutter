import 'package:flutter/material.dart';
import 'package:sos/main.dart';
import 'package:sos/models/result.dart';
import 'package:sos/screens/home/screen/post_detail.dart';
import 'package:sos/widgets/colors.dart';
import 'package:after_layout/after_layout.dart';

import '../../api/notify_api.dart';

class NotificationPage extends StatefulWidget {
  static const routeName = "/notificationpage";
  const NotificationPage({Key? key}) : super(key: key);
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with AfterLayoutMixin {
  int page = 1;
  int limit = 1000;
  bool isLoading = true;
  Result notifyList = Result(rows: [], count: 0);

  @override
  void afterFirstLayout(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    await notify(page, limit);
    setState(() {
      isLoading = false;
    });
  }

  notify(int page, int limit) async {
    Filter filter = Filter();
    Offset offset = Offset(limit: limit, page: page);
    Result res =
        await NotifyApi().list(ResultArguments(filter: filter, offset: offset));
    setState(() {
      notifyList = res;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(color: dark),
          backgroundColor: primaryColor,
          title: const Text(
            "Мэдэгдэл",
            style: TextStyle(
              color: dark,
              fontSize: 16,
            ),
          ),
        ),
        body: isLoading == true
            ? const SizedBox()
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    if (notifyList.rows!.isEmpty)
                      Column(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          Image.asset(
                            "assets/empty.png",
                            height: 250,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Хоосон байна",
                            style: TextStyle(
                                color: orange,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    for (var i = 0; i < notifyList.rows!.length; i++)
                      InkWell(
                        onTap: () {
                          if (notifyList.rows![i].notifyType == "WEB") {
                            print("web");
                          } else {
                            NotifyApi().getNotify(notifyList.rows![i].id);
                            Navigator.of(context).pushNamed(
                              PostDetailPage.routeName,
                              arguments: PostDetailPageArguments(
                                  id: notifyList.rows![i].post),
                            );
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          notifyList.rows![i].title,
                                          style: TextStyle(
                                            fontWeight:
                                                notifyList.rows![i].seen != true
                                                    ? FontWeight.w700
                                                    : FontWeight.w400,
                                          ),
                                        ),
                                        if (notifyList.rows![i].seen != true)
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 5),
                                            decoration: BoxDecoration(
                                              color: orange,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            width: 8,
                                            height: 8,
                                          )
                                      ],
                                    ),
                                    Text(
                                      notifyList.rows![i].getDate(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notifyList.rows![i].body,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
