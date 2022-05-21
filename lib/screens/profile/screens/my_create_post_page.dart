import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:after_layout/after_layout.dart';
import 'package:sos/screens/home/components/post_card.dart';
import 'package:sos/screens/profile/screens/components/page1.dart';
import 'package:sos/widgets/colors.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../../api/dashboard_api.dart';
import '../../../api/post_api.dart';
import '../../../components/header/index.dart';
import '../../../models/result.dart';
import '../../../models/sector.dart';
import 'package:skeletons/skeletons.dart';

class MyCreatePostPage extends StatefulWidget {
  static const routeName = "/mycreatepostpage";
  const MyCreatePostPage({Key? key}) : super(key: key);

  @override
  State<MyCreatePostPage> createState() => _MyCreatePostPageState();
}

class _MyCreatePostPageState extends State<MyCreatePostPage>
    with AfterLayoutMixin {
  final PageController controller = PageController();
  Sector? sectorData;
  int currentIndex = 0;
  List<Sector> response = [];
  bool isLoading = true;
  TabController? tabController;
  int page = 1;
  int limit = 1000;
  Filter filter = Filter(postStatus: "NEW");
  Result? warningPost = Result(count: 0, rows: []);
  ScrollController scrollController = ScrollController();

  // RefreshController _refreshController =
  //     RefreshController(initialRefresh: false);

  // void _onRefresh() async {
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use refreshFailed()
  //   _refreshController.refreshCompleted();
  // }

  // void _onLoading() async {
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use loadFailed(),if no data return,use LoadNodata()
  //   // items.add((items.length + 1).toString());
  //   if (mounted) setState(() {});
  //   _refreshController.loadComplete();
  // }

  List<String> tabs = [
    "123",
    "123",
    "123",
  ];

  @override
  void afterFirstLayout(BuildContext context) async {
    Sector data = await DashboardApi().sector();
    setState(() {
      sectorData = data;
      // for (var element in sectorData!.response!) {
      //   response.add(element);
      // }
    });
    // print("==========================RESPONS================");
    // print(sectorData!.rows!.length);
    // print(sectorData!.rows!.map((e) => e.toJson()));
    // print(sectorData!.rows!.map((e) => print(e.id)));
    // print("=================================================");
  }

  onChangeTap(index) async {
    setState(() {
      isLoading = true;
    });
    switch (index) {
      case 0:
        setState(() {
          filter.postStatus = "NEW";
        });
        break;
      case 1:
        setState(() {
          filter.postStatus = "PENDING";
        });
        break;
      case 2:
        setState(() {
          filter.postStatus = "SOLVED";
        });
        break;
      default:
    }
  }

  changePage(index) {
    controller.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    setState(() {
      currentIndex = index;
    });
  }

  checkPage(int index) {
    if (currentIndex == index) {
      return true;
    } else {
      return false;
    }
  }

  switchTab() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0x4ffebedf1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              changePage(0);
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: checkPage(0) == true
                    ? Border.all(color: Color(0x4ff3F4448), width: 2)
                    : Border.all(color: white, width: 0),
                color: white,
              ),
              child: const Icon(Icons.more_horiz_rounded),
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () {
              changePage(1);
            },
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: checkPage(1) == true
                    ? Border.all(color: Color(0x4ff3F4448), width: 2)
                    : Border.all(color: white, width: 0),
                borderRadius: BorderRadius.circular(10),
                color: white,
              ),
              child: const Icon(Icons.pie_chart_rounded),
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () {
              changePage(2);
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: checkPage(2) == true
                    ? Border.all(color: Color(0x4ff3F4448), width: 2)
                    : Border.all(color: white, width: 0),
                borderRadius: BorderRadius.circular(10),
                color: white,
              ),
              child: const Icon(Icons.stacked_bar_chart_rounded),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.7 -
                                    20,
                                child: FormBuilderDropdown(
                                  allowClear: false,
                                  icon: Container(
                                    decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_drop_down,
                                      color: black,
                                    ),
                                  ),
                                  name: 'type',
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0x4ffEBEDF1),
                                    contentPadding: const EdgeInsets.all(15),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: white, width: 0),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: white, width: 0),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    prefixIcon: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: Image.asset(
                                              "assets/tshn.png",
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                          const SizedBox(height: 1),
                                        ]),
                                  ),
                                  items:
                                      [sectorData!.rows!.map((e) => e.fullName)]
                                          .map(
                                            (item) => DropdownMenuItem(
                                              value: item,
                                              child: Text('$item'),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ),
                              switchTab(),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // SizedBox(
                          //   height: 130,
                          //   child: PageView(
                          //     controller: controller,
                          //     onPageChanged: (index) {
                          //       setState(() {
                          //         currentIndex = index;
                          //       });
                          //     },
                          //     children: [
                          //       Row(
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.spaceBetween,
                          //         children: response
                          //             .map((Sector e) => ChartNumberCard(
                          //                   dashboard: e,
                          //                 ))
                          //             .toList(),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  pinned: true,
                  floating: true,
                  snap: false,
                  elevation: 0.0,
                  toolbarHeight: 0,
                  backgroundColor: white,
                  excludeHeaderSemantics: false,
                  automaticallyImplyLeading: false,
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                      labelColor: black,
                      indicatorColor: orange,
                      onTap: (index) async {
                        scrollController.animateTo(0.0,
                            duration: Duration(milliseconds: 500),
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
                      ]),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 100),
                  child: Text("1"),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 100),
                  child: Text("2"),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 100),
                  child: Text("3"),
                ),
              ),

              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 100),
              //   child: Page1(name: "Page 2"),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 100),
              //   child: Page1(name: "Page 3"),
              // ),
            ],

            // children: tabs.map(
            //   (String name) {
            //     return SafeArea(
            //       top: false,
            //       bottom: false,
            //       child: Builder(
            //         builder: (BuildContext context) {
            //           return CustomScrollView(
            //             key: PageStorageKey<String>(name),
            //             slivers: <Widget>[
            //               SliverOverlapInjector(
            //                 handle:
            //                     NestedScrollView.sliverOverlapAbsorberHandleFor(
            //                         context),
            //               ),
            //               SliverPadding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 sliver: SliverGrid.count(
            //                   crossAxisCount: 1,
            //                   children: [

            //                   ],
            //                 ),
            //               ),
            //             ],
            //           );
            //         },
            //       ),
            //     );
            //   },
            // ).toList(),
          ),
        ),
      ),
    );
  }

  postList() {
    if (isLoading == false) {
      if (warningPost!.rows!.isNotEmpty) {
        for (var i = 0; i < warningPost!.rows!.length; i++) {
          return PostCard(
            data: warningPost!.rows![i],
          );
        }
        // }
      } else {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Text("empty"),
        );
      }
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SkeletonItem(
          child: Column(
            children: [
              Row(
                children: [
                  const SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                        shape: BoxShape.circle, width: 50, height: 50),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SkeletonParagraph(
                      style: SkeletonParagraphStyle(
                          lines: 2,
                          spacing: 6,
                          lineStyle: SkeletonLineStyle(
                            randomLength: true,
                            height: 10,
                            borderRadius: BorderRadius.circular(8),
                            minLength: MediaQuery.of(context).size.width / 6,
                            maxLength: MediaQuery.of(context).size.width / 3,
                          )),
                    ),
                  ),
                  const Icon(Icons.more_vert),
                ],
              ),
              const SizedBox(height: 12),
              const SkeletonAvatar(
                style: SkeletonAvatarStyle(width: double.infinity, height: 200),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.2, color: grey)),
                      height: 55,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/heart.svg",
                            ),
                            const SizedBox(width: 7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.2, color: grey)),
                      height: 55,
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/location.svg",
                          color: Color(0x4ffA7A7A7),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
  }
}
