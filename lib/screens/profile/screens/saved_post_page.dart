import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sos/models/user.dart';
import 'package:sos/screens/profile/screens/components/saved_page.dart';
import 'package:sos/widgets/colors.dart';

import 'package:after_layout/after_layout.dart';
import '../../../models/result.dart';
import '../../../provider/user_provider.dart';
import 'components/page1.dart';

class SavedPostPage extends StatefulWidget {
  static const routeName = "/savedpostpage";

  const SavedPostPage({Key? key}) : super(key: key);

  @override
  State<SavedPostPage> createState() => _SavedPostPageState();
}

class _SavedPostPageState extends State<SavedPostPage>
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
    tabController = TabController(length: 4, vsync: this);
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
          "Миний хадгалсан эрсдэлүүд",
          style: TextStyle(color: dark, fontSize: 16),
        ),
      ),
      body: DefaultTabController(
        length: 4,
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
              SingleChildScrollView(
                child: SavePostList(
                  filter: Filter(
                    postStatus: "NEW",
                  ),
                  type: "MYPOST",
                  height: 50,
                ),
              ),
              SingleChildScrollView(
                child: SavePostList(
                  filter: Filter(postStatus: "PENDING"),
                  height: 50,
                ),
              ),
              SingleChildScrollView(
                child: SavePostList(
                  height: 50,
                  filter: Filter(postStatus: "SOLVED"),
                ),
              ),
              SingleChildScrollView(
                child: SavePostList(
                  height: 50,
                  filter: Filter(postStatus: "FAILED"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
