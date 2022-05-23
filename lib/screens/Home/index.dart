import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sos/components/header/index.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sos/provider/sector_provider.dart';
import 'package:sos/screens/Home/components/chart_number.dart';
import 'package:sos/screens/create_post/create_post_page.dart';
import 'package:sos/screens/login/login_page.dart';
import 'package:sos/screens/profile/profile_page.dart';
import 'package:sos/widgets/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../models/result.dart';
import '../../models/sector.dart';
import '../../models/user.dart';
import 'package:after_layout/after_layout.dart';
import '../../provider/user_provider.dart';
import 'package:sos/screens/profile/screens/components/page1.dart';
import '../../../components/header/index.dart';
import '../../../models/result.dart';
import '../../../models/sector.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:skeletons/skeletons.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/HomePage";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AfterLayoutMixin, SingleTickerProviderStateMixin {
  User user = User();
  final PageController controller = PageController();
  int currentIndex = 0;
  int page = 1;
  int limit = 1000;
  bool visible = false;
  Sector? sectorData;
  List<Sector> response = [];
  ScrollController scrollController = ScrollController();
  late TabController tabController;
  bool? isLoading = true;
  Filter filter = Filter(postStatus: "NEW");
  Result? warningPost = Result(count: 0, rows: []);
  Sector data = Sector();
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

  @override
  void afterFirstLayout(BuildContext context) async {
    if (user.username != null) {
      setState(() {
        visible = true;
      });
    } else {
      setState(() {
        visible = false;
      });
    }

    // setState(() {
    //   sectorData = data;
    //   for (var element in sectorData!.response!) {
    //     response.add(element);
    //   }
    // });
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
      case 3:
        setState(() {
          filter.postStatus = "FAILED";
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

  Map<String, double> dataMap = {
    "Flutter": 5,
    "React": 3,
    "Xamarin": 2,
    "Ionic": 2,
  };

  final colorList = <Color>[
    const Color(0xfffdcb6e),
    const Color(0xff0984e3),
    const Color(0xfffd79a8),
    const Color(0xffe17055),
    const Color(0xff6c5ce7),
  ];

  switchTab() {
    if (response.isEmpty) {
      return SkeletonAvatar(
        style: SkeletonAvatarStyle(
          height: 50,
          width: 140,
          borderRadius: BorderRadius.circular(15),
        ),
      );
    } else {
      return Container(
        width: 140,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0x4ffEBEDF1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  changePage(0);
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: checkPage(0) == true
                        ? Border.all(color: const Color(0x4ff3F4448), width: 2)
                        : Border.all(color: white, width: 0),
                    color: white,
                  ),
                  child: const Icon(Icons.more_horiz_rounded),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: InkWell(
                onTap: () {
                  changePage(1);
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: checkPage(1) == true
                        ? Border.all(color: const Color(0x4ff3F4448), width: 2)
                        : Border.all(color: white, width: 0),
                    borderRadius: BorderRadius.circular(10),
                    color: white,
                  ),
                  child: const Icon(Icons.pie_chart_rounded),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: InkWell(
                onTap: () {
                  changePage(2);
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: checkPage(2) == true
                        ? Border.all(color: const Color(0x4ff3F4448), width: 2)
                        : Border.all(color: white, width: 0),
                    borderRadius: BorderRadius.circular(10),
                    color: white,
                  ),
                  child: const Icon(Icons.stacked_bar_chart_rounded),
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: true).user;
    sectorData = Provider.of<SectorProvider>(context, listen: true).sectorData;
    response = Provider.of<SectorProvider>(context, listen: true).response;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: const CustomAppBar(),
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: sectorData == null
                                    ? SkeletonAvatar(
                                        style: SkeletonAvatarStyle(
                                          height: 50,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 50,
                                        child: FormBuilderDropdown(
                                          hint: const Text(
                                            "Салбар нэгж",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          allowClear: true,
                                          icon: Container(
                                            decoration: BoxDecoration(
                                              color: white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: const Icon(
                                              Icons.arrow_drop_down,
                                              color: black,
                                            ),
                                          ),
                                          name: 'type',
                                          onChanged: (value) async {
                                            await Provider.of<SectorProvider>(
                                                    context,
                                                    listen: false)
                                                .sectorGet(value);
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color(0x4ffEBEDF1),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 10),
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: white, width: 0),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: white, width: 0),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          items: sectorData!.rows!
                                              .map(
                                                (item) => DropdownMenuItem(
                                                  value: item.id,
                                                  child: Text(
                                                    '${item.fullName}',
                                                    style: const TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              switchTab(),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 90,
                            child: PageView(
                              controller: controller,
                              onPageChanged: (index) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: response
                                      .map((Sector e) => ChartNumberCard(
                                            dashboard: e,
                                          ))
                                      .toList(),
                                ),
                                PieChart(
                                  dataMap: dataMap,
                                  animationDuration:
                                      const Duration(milliseconds: 800),
                                  chartLegendSpacing: 32,
                                  chartRadius: 55,
                                  colorList: colorList,
                                  initialAngleInDegree: 0,
                                  chartType: ChartType.ring,
                                  ringStrokeWidth: 32,
                                  legendOptions: const LegendOptions(
                                    showLegendsInRow: false,
                                    legendPosition: LegendPosition.right,
                                    showLegends: true,
                                    legendShape: BoxShape.circle,
                                    legendTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  chartValuesOptions: const ChartValuesOptions(
                                    showChartValueBackground: false,
                                    showChartValues: true,
                                    showChartValuesInPercentage: false,
                                    showChartValuesOutside: false,
                                    chartValueStyle: TextStyle(fontSize: 12),
                                    decimalPlaces: 0,
                                  ),
                                )
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: response
                                //       .map((Sector e) => ChartNumberCard(
                                //             dashboard: e,
                                //           ))
                                //       .toList(),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            dragStartBehavior: DragStartBehavior.start,
            children: [
              SingleChildScrollView(
                child: Page1(
                  name: "Page 1",
                  filter: filter,
                ),
              ),
              SingleChildScrollView(
                child: Page1(
                  name: "Page 2",
                  filter: filter,
                ),
              ),
              SingleChildScrollView(
                child: Page1(
                  name: "Page 3",
                  filter: filter,
                ),
              ),
              SingleChildScrollView(
                child: Page1(
                  name: "Page 4",
                  filter: filter,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: visible,
        child: FloatingActionButton(
          backgroundColor: primaryYellow,
          elevation: 0.0,
          onPressed: () async {
            Navigator.of(context).pushNamed(CreatePostPage.routeName);
          },
          child: const Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(80),
                    onTap: () {
                      tabController.index = 0;
                      onChangeTap(tabController.index);
                      scrollController.animateTo(0.0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    },
                    child: Container(
                      width: 37,
                      height: 37,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: tabController.index != 0
                                ? primaryBorderColor
                                : black,
                            width: 1),
                        borderRadius: BorderRadius.circular(80),
                      ),
                      child: SvgPicture.asset(
                        "assets/tab/1.svg",
                        width: 37,
                        height: 37,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  InkWell(
                    borderRadius: BorderRadius.circular(80),
                    onTap: () {
                      tabController.index = 1;
                      onChangeTap(tabController.index);
                      scrollController.animateTo(0.0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    },
                    child: Container(
                      width: 37,
                      height: 37,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: tabController.index != 1
                                ? primaryBorderColor
                                : black,
                            width: 1),
                        borderRadius: BorderRadius.circular(80),
                      ),
                      child: SvgPicture.asset(
                        "assets/tab/2.svg",
                        width: 37,
                        height: 37,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  InkWell(
                    borderRadius: BorderRadius.circular(80),
                    onTap: () {
                      tabController.index = 2;
                      onChangeTap(tabController.index);
                      scrollController.animateTo(0.0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    },
                    child: Container(
                      width: 37,
                      height: 37,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: tabController.index != 2
                                ? primaryBorderColor
                                : black,
                            width: 1),
                        borderRadius: BorderRadius.circular(80),
                      ),
                      child: SvgPicture.asset(
                        "assets/tab/3.svg",
                        width: 37,
                        height: 37,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  InkWell(
                    borderRadius: BorderRadius.circular(80),
                    onTap: () {
                      tabController.index = 3;
                      onChangeTap(tabController.index);
                      scrollController.animateTo(0.0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    },
                    child: Container(
                      width: 37,
                      height: 37,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: tabController.index != 3
                                ? primaryBorderColor
                                : black,
                            width: 1),
                        borderRadius: BorderRadius.circular(80),
                      ),
                      child: SvgPicture.asset(
                        "assets/tab/5.svg",
                        width: 37,
                        height: 37,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 18),
              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(80),
              //   ),
              //   child: InkWell(
              //     onTap: () {
              //       // Navigator.of(context).pushNamed(NotificationPage.routeName);
              //     },
              //     child: Container(
              //       width: 32,
              //       height: 32,
              //       padding: const EdgeInsets.all(3),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(80),
              //       ),
              //       child: SvgPicture.asset(
              //         "assets/tab/4.svg",
              //         width: 32,
              //         height: 32,
              //       ),
              //     ),
              //   ),
              // ),
              InkWell(
                  borderRadius: BorderRadius.circular(80),
                  onTap: () {
                    user.id == null
                        ? Navigator.of(context).pushNamed(LoginPage.routeName)
                        : Navigator.of(context)
                            .pushNamed(ProfilePage.routeName);
                  },
                  child: user.avatar != null
                      ? Container(
                          width: 37,
                          height: 37,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: primaryBorderColor, width: 1),
                            borderRadius: BorderRadius.circular(80),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(user.getAvatar()),
                            ),
                          ),
                        )
                      : Container(
                          height: 37,
                          width: 37,
                          decoration: BoxDecoration(
                            color: orange,
                            borderRadius: BorderRadius.circular(80),
                          ),
                          child: const Icon(Icons.person),
                        )),
            ],
          ),
        ),
      ),
    );
  }
}
