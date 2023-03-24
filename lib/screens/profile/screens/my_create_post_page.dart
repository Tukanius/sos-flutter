import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sos/models/user.dart';
import 'package:sos/widgets/colors.dart';

import 'package:after_layout/after_layout.dart';
import '../../../models/result.dart';
import '../../../provider/user_provider.dart';
import 'components/page1.dart';

class MyCreatePostPage extends StatefulWidget {
  static const routeName = "/mycreatepost";

  const MyCreatePostPage({Key? key}) : super(key: key);

  @override
  State<MyCreatePostPage> createState() => _MyCreatePostPageState();
}

class _MyCreatePostPageState extends State<MyCreatePostPage>
    with SingleTickerProviderStateMixin, AfterLayoutMixin {
  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      filter = Filter(
        postStatus: "NEW",
        user: user.id,
      );
    });
  }

  @override
  void initState() {
    tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  ScrollController scrollController = ScrollController();
  late TabController tabController;
  User user = User();
  Filter filter = Filter();

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: true).user;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: dark),
        title: const Text(
          "Миний илгээсэн",
          style: TextStyle(color: dark, fontSize: 16),
        ),
      ),
      body: DefaultTabController(
        length: 5,
        child: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  pinned: true,
                  floating: true,
                  snap: false,
                  elevation: 0.0,
                  toolbarHeight: 0,
                  backgroundColor: white.withOpacity(0.5),
                  excludeHeaderSemantics: false,
                  automaticallyImplyLeading: false,
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                      labelColor: black,
                      indicatorColor: orange,
                      controller: tabController,
                      onTap: (index) async {
                        scrollController.animateTo(0.0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      automaticIndicatorColorAdjustment: false,
                      tabs: [
                        Tab(
                          icon: SvgPicture.asset(
                            "assets/tab/1.svg",
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Tab(
                          icon: SvgPicture.asset(
                            "assets/tab/2.svg",
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Tab(
                          icon: SvgPicture.asset(
                            "assets/tab/3.svg",
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Tab(
                          icon: SvgPicture.asset(
                            "assets/tab/5.svg",
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ]),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: tabController,
            dragStartBehavior: DragStartBehavior.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 50),
                child: Page1(
                  name: "Page 1",
                  filter: Filter(
                    user: user.id,
                    postStatus: "NEW",
                  ),
                  type: "MYPOST",
                  height: 50,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50),
                child: Page1(
                  name: "Page 2",
                  filter: Filter(user: user.id, postStatus: "PENDING"),
                  height: 50,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50),
                child: Page1(
                  name: "Page 3",
                  height: 50,
                  filter: Filter(user: user.id, postStatus: "SOLVED"),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50),
                child: Page1(
                  name: "Page 4",
                  height: 50,
                  filter: Filter(user: user.id, postStatus: "FAILED"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
