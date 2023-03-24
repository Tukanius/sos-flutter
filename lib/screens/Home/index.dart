import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sos/components/header/index.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sos/models/general.dart';
import 'package:sos/provider/general_provider.dart';
import 'package:sos/provider/sector_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:sos/screens/Home/components/chart_number.dart';
import 'package:sos/screens/create_post/create_post_page.dart';
import 'package:sos/screens/login/login_page.dart';
import 'package:sos/screens/newsfeed/news_feed.dart';
import 'package:sos/screens/profile/profile_page.dart';
import 'package:sos/screens/profile/screens/components/page_change_controller.dart';
import 'package:sos/screens/search/search_page.dart';
import 'package:sos/utils/http_request.dart';
import 'package:sos/widgets/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../models/result.dart';
import '../../models/sector.dart';
import '../../models/user.dart';
import 'package:after_layout/after_layout.dart';
import '../../provider/user_provider.dart';
import 'package:sos/screens/profile/screens/components/page1.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:skeletons/skeletons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../notify/notification_page.dart';

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
  Filter newsfeedFilter = Filter(isNotice: true);
  Sector data = Sector();
  String? avatar;
  General? general = General();
  String? sectorId;
  ValueNotifier sectorIdNotifier = ValueNotifier("");
  PageChangeController pageChangeController = PageChangeController();

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
    if (general!.version != "1.0.0") {
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
                    padding:
                        const EdgeInsets.only(top: 90, left: 20, right: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text(
                          'UPDATE',
                          style: TextStyle(
                              color: dark,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'Та аппликейшн-аа шинэчилнэ үү.',
                          textAlign: TextAlign.center,
                        ),
                        ButtonBar(
                          buttonMinWidth: 100,
                          alignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            TextButton(
                              child: const Text(
                                "Шинэчлэх",
                                style: TextStyle(color: dark),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _launchUrl();
                              },
                            ),
                            TextButton(
                              child: const Text(
                                "Алгасах",
                                style: TextStyle(color: dark),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Lottie.asset('assets/update.json',
                      height: 150, repeat: false),
                ],
              ),
            );
          });
    }
  }

  final Uri _url = Uri.parse('https://play.google.com/store/apps');
  final Uri _url2 = Uri.parse('https://www.apple.com/app-store/');

  void _launchUrl() async {
    if (Platform.isAndroid) {
      await launchUrl(_url);
    } else if (Platform.isIOS) {
      await launchUrl(_url2);
    }
  }

  onChangeTap(index) async {
    setState(() {
      isLoading = true;
    });
    switch (index) {
      case 0:
        setState(() {
          filter.sector = sectorId;
          filter.postStatus = "NEW";
        });
        break;
      case 1:
        setState(() {
          filter.sector = sectorId;
          filter.postStatus = "PENDING";
        });
        break;
      case 2:
        setState(() {
          filter.sector = sectorId;
          filter.postStatus = "SOLVED";
        });
        break;
      case 3:
        setState(() {
          filter.sector = sectorId;
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

  final colorList = <Color>[
    red,
    orange,
    green,
    grey,
  ];

  Map<String, double> chartData(res) {
    Map<String, double> jsonData = {};
    for (var element in res) {
      jsonData["${element.statusString}"] = double.parse("${element.total}");
    }
    return jsonData;
  }

  switchTab() {
    return Container(
      width: 100,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0x4ffebedf1),
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: true).user;
    sectorData = Provider.of<SectorProvider>(context, listen: true).sectorData;
    response = Provider.of<SectorProvider>(context, listen: true).response;
    avatar = Provider.of<SectorProvider>(context, listen: true).avatar;
    general = Provider.of<GeneralProvider>(context, listen: true).general;

    return WillPopScope(
        child: Scaffold(
          backgroundColor: primaryColor,
          appBar: const CustomAppBar(),
          body: DefaultTabController(
            length: 5,
            child: NestedScrollView(
              controller: scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(SearchPage.routeName);
                            },
                            borderRadius: BorderRadius.circular(15),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.manage_search_sharp,
                                  color: dark,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Хайх...",
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        tabController.index != 4
                            ? Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: sectorData == null
                                              ? SkeletonAvatar(
                                                  style: SkeletonAvatarStyle(
                                                    height: 50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: 50,
                                                  child: FormBuilderDropdown(
                                                    hint: const Text(
                                                      "Салбар нэгж",
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                    allowClear: true,
                                                    icon: Container(
                                                      decoration: BoxDecoration(
                                                        color: white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: const Icon(
                                                        Icons.arrow_drop_down,
                                                        color: black,
                                                      ),
                                                    ),
                                                    name: 'type',
                                                    onChanged: (value) async {
                                                      await Provider.of<
                                                                  SectorProvider>(
                                                              context,
                                                              listen: false)
                                                          .clear();
                                                      await Provider.of<
                                                                  SectorProvider>(
                                                              context,
                                                              listen: false)
                                                          .sectorGet(value);

                                                      if (value != null) {
                                                        setState(() {
                                                          sectorId =
                                                              value.toString();
                                                        });
                                                      } else {
                                                        setState(() {
                                                          sectorId = null;
                                                        });
                                                      }

                                                      onChangeTap(
                                                          tabController.index);

                                                      pageChangeController
                                                          .changeVariable(
                                                              sectorId
                                                                  .toString());
                                                    },
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: const Color(
                                                          0xFFEBEDF1),
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 12,
                                                              horizontal: 10),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: white,
                                                                width: 0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: white,
                                                                width: 0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                    items: sectorData!.rows!
                                                        .map(
                                                          (item) =>
                                                              DropdownMenuItem(
                                                                  value:
                                                                      item.id,
                                                                  child: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            30,
                                                                        width:
                                                                            30,
                                                                        child: Image.network(HttpRequest.s3host +
                                                                            item.avatar.toString()),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            SizedBox(
                                                                          child:
                                                                              Text(
                                                                            '${item.fullName}',
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 10,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )),
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
                                          response.isNotEmpty
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: response
                                                      .map((Sector e) =>
                                                          ChartNumberCard(
                                                            tabController:
                                                                tabController,
                                                            onChangeTap:
                                                                onChangeTap,
                                                            scrollController:
                                                                scrollController,
                                                            dashboard: e,
                                                          ))
                                                      .toList(),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        SkeletonAvatar(
                                                          style:
                                                              SkeletonAvatarStyle(
                                                            width: 50,
                                                            height: 50,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        SkeletonAvatar(
                                                          style:
                                                              SkeletonAvatarStyle(
                                                            width: 50,
                                                            height: 8,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        SkeletonAvatar(
                                                          style:
                                                              SkeletonAvatarStyle(
                                                            width: 50,
                                                            height: 50,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        SkeletonAvatar(
                                                          style:
                                                              SkeletonAvatarStyle(
                                                            width: 50,
                                                            height: 8,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        SkeletonAvatar(
                                                          style:
                                                              SkeletonAvatarStyle(
                                                            width: 50,
                                                            height: 50,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        SkeletonAvatar(
                                                          style:
                                                              SkeletonAvatarStyle(
                                                            width: 50,
                                                            height: 8,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        SkeletonAvatar(
                                                          style:
                                                              SkeletonAvatarStyle(
                                                            width: 50,
                                                            height: 50,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        SkeletonAvatar(
                                                          style:
                                                              SkeletonAvatarStyle(
                                                            width: 50,
                                                            height: 8,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                          Row(
                                            children: [
                                              response.isNotEmpty
                                                  ? Expanded(
                                                      child: PieChart(
                                                        dataMap:
                                                            chartData(response),
                                                        animationDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    800),
                                                        chartLegendSpacing: 32,
                                                        chartRadius: 55,
                                                        colorList: colorList,
                                                        initialAngleInDegree: 0,
                                                        chartType:
                                                            ChartType.ring,
                                                        ringStrokeWidth: 30,
                                                        legendOptions:
                                                            const LegendOptions(
                                                          showLegendsInRow:
                                                              false,
                                                          legendPosition:
                                                              LegendPosition
                                                                  .left,
                                                          showLegends: true,
                                                          legendShape:
                                                              BoxShape.circle,
                                                          legendTextStyle:
                                                              TextStyle(
                                                                  fontSize: 10),
                                                        ),
                                                        chartValuesOptions:
                                                            const ChartValuesOptions(
                                                          showChartValueBackground:
                                                              false,
                                                          showChartValues: true,
                                                          showChartValuesInPercentage:
                                                              false,
                                                          showChartValuesOutside:
                                                              false,
                                                          chartValueStyle:
                                                              TextStyle(
                                                                  fontSize: 10),
                                                          decimalPlaces: 0,
                                                        ),
                                                      ),
                                                    )
                                                  : Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Center(
                                                                  child:
                                                                      SkeletonParagraph(
                                                                    style: SkeletonParagraphStyle(
                                                                        lines:
                                                                            3,
                                                                        spacing:
                                                                            15,
                                                                        lineStyle: SkeletonLineStyle(
                                                                            randomLength:
                                                                                false,
                                                                            height:
                                                                                10,
                                                                            borderRadius:
                                                                                BorderRadius.circular(1),
                                                                            width: 90)),
                                                                  ),
                                                                ),
                                                              ]),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const SizedBox(
                                                                  height: 7,
                                                                ),
                                                                Center(
                                                                  child:
                                                                      SkeletonParagraph(
                                                                    style: SkeletonParagraphStyle(
                                                                        lines:
                                                                            1,
                                                                        spacing:
                                                                            15,
                                                                        lineStyle: SkeletonLineStyle(
                                                                            randomLength:
                                                                                false,
                                                                            height:
                                                                                10,
                                                                            borderRadius:
                                                                                BorderRadius.circular(1),
                                                                            width: 90)),
                                                                  ),
                                                                ),
                                                              ]),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          SkeletonAvatar(
                                                            style:
                                                                SkeletonAvatarStyle(
                                                              width: 80,
                                                              height: 80,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          1000),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
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
                  Page1(
                    filter: filter,
                    pageChangeController: pageChangeController,
                  ),
                  Page1(
                    filter: filter,
                    pageChangeController: pageChangeController,
                  ),
                  Page1(
                    filter: filter,
                    pageChangeController: pageChangeController,
                  ),
                  Page1(
                    filter: filter,
                    pageChangeController: pageChangeController,
                  ),
                  NewsFeedList(
                    filter: newsfeedFilter,
                    // pageChangeController: pageChangeController,
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
                                color: tabController.index != 4
                                    ? black
                                    : primaryColor,
                                width: 1),
                            borderRadius: BorderRadius.circular(80),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image(
                              image: AssetImage('assets/icon/appstore.png'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      InkWell(
                        borderRadius: BorderRadius.circular(80),
                        onTap: () {
                          tabController.index = 4;
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
                                color: tabController.index != 4
                                    ? primaryBorderColor
                                    : black,
                                width: 1),
                            borderRadius: BorderRadius.circular(80),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image(
                              image: AssetImage(
                                'assets/icon/darkhan.jpg',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 130),
                  if (user.id != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(NotificationPage.routeName);
                        },
                        child: Container(
                            width: 32,
                            height: 32,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                            ),
                            child: Stack(
                              children: [
                                SvgPicture.asset(
                                  "assets/tab/4.svg",
                                  width: 32,
                                  height: 32,
                                ),
                                if (user.notification != 0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: red,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Text(
                                        user.notification.toString(),
                                        style: const TextStyle(
                                            color: white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11),
                                      ),
                                    ),
                                  )
                              ],
                            )),
                      ),
                    ),
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
                              border: Border.all(
                                  color: primaryBorderColor, width: 1),
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
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) {
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          const EdgeInsets.only(top: 120, left: 20, right: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text(
                            'Гарах',
                            style: TextStyle(
                                color: dark,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Та эрсдэл аппликейшнээс гарах гэж байна.',
                            textAlign: TextAlign.center,
                          ),
                          ButtonBar(
                            buttonMinWidth: 100,
                            alignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              TextButton(
                                child: const Text(
                                  "Үгүй",
                                  style: TextStyle(color: dark),
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  "Тийм",
                                  style: TextStyle(color: dark),
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Lottie.asset('assets/sos.json', height: 120, repeat: true),
                  ],
                ),
              );
            },
          );
          return shouldPop!;
        });
  }
}
