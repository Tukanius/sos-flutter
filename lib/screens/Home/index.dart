import 'package:flutter/material.dart';
import 'package:sos/components/header/index.dart';
import 'package:sos/provider/general_provider.dart';
import 'package:sos/screens/home/components/post_card.dart';
import 'package:sos/screens/login/login_page.dart';
import 'package:sos/screens/profile/profile_page.dart';
import 'package:sos/widgets/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import '../../api/dashboard_api.dart';
import '../../api/post_api.dart';
import '../../models/result.dart';
import '../../models/sector.dart';
import '../../models/user.dart';
import 'package:after_layout/after_layout.dart';
import '../../provider/user_provider.dart';
import 'components/chart_number.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/HomePage";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin {
  User user = User();
  String? status;
  final PageController controller = PageController();
  BottomDrawerController bottomDrawerController = BottomDrawerController();
  int currentIndex = 0;
  int page = 1;
  int limit = 1000;
  Sector? sectorData;
  List<Sector> response = [];
  Result? warningPost = Result(count: 0, rows: []);

  @override
  void afterFirstLayout(BuildContext context) async {
    Sector data = await DashboardApi().sector();
    await post(page, limit);
    setState(() {
      sectorData = data;
      for (var element in sectorData!.response!) {
        response.add(element);
      }
    });
  }

  Future<List<dynamic>?> post(int page, int limit) async {
    Filter filter = Filter(status: status);
    Offset offset = Offset(limit: limit, page: page);
    Result res =
        await PostApi().list(ResultArguments(filter: filter, offset: offset));
    setState(() {
      warningPost = res;
    });
    return res.rows;
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
        color: Color(0x4ffEBEDF1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              changePage(0);
            },
            child: Container(
              padding: EdgeInsets.all(6),
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
    bottomDrawerController = Provider.of<GeneralProvider>(context, listen: true)
        .bottomDrawerController;
    user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      backgroundColor: dark,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
          child: Column(
            children: [
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 5),
              //   child: TextField(
              //     decoration: InputDecoration(
              //       filled: true,
              //       fillColor: white,
              //       hintText: "Хайх",
              //       prefixIcon:
              //           const Icon(Icons.search, color: Color(0x4ffEBEDF1)),
              //       contentPadding: const EdgeInsets.all(15),
              //       border: OutlineInputBorder(
              //         borderSide: const BorderSide(
              //             color: Color.fromARGB(255, 255, 254, 254), width: 0),
              //         borderRadius: BorderRadius.circular(20.0),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: const BorderSide(
              //             color: Color.fromARGB(255, 255, 254, 254), width: 0),
              //         borderRadius: BorderRadius.circular(20.0),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: const BorderSide(
              //             color: Color.fromARGB(255, 255, 254, 254), width: 0),
              //         borderRadius: BorderRadius.circular(20.0),
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 15),
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
                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width / 1.7 - 20,
                        //   child: FormBuilderDropdown(
                        //     allowClear: false,
                        //     icon: Container(
                        //       decoration: BoxDecoration(
                        //         color: white,
                        //         borderRadius: BorderRadius.circular(10),
                        //       ),
                        //       child: const Icon(
                        //         Icons.arrow_drop_down,
                        //         color: black,
                        //       ),
                        //     ),
                        //     name: 'type',
                        //     decoration: InputDecoration(
                        //       filled: true,
                        //       fillColor: Color(0x4ffEBEDF1),
                        //       contentPadding: const EdgeInsets.all(15),
                        //       border: OutlineInputBorder(
                        //         borderSide:
                        //             const BorderSide(color: white, width: 0),
                        //         borderRadius: BorderRadius.circular(20),
                        //       ),
                        //       enabledBorder: OutlineInputBorder(
                        //         borderSide:
                        //             const BorderSide(color: white, width: 0),
                        //         borderRadius: BorderRadius.circular(20),
                        //       ),
                        //       prefixIcon: Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             SizedBox(
                        //               width: 30,
                        //               height: 30,
                        //               child: Image.asset(
                        //                 "assets/tshn.png",
                        //                 width: 30,
                        //                 height: 30,
                        //               ),
                        //             ),
                        //             const SizedBox(height: 1),
                        //           ]),
                        //     ),
                        //     items: ["Цахилгаан түгээх"]
                        //         .map(
                        //           (item) => DropdownMenuItem(
                        //             value: item,
                        //             child: Text('$item'),
                        //           ),
                        //         )
                        //         .toList(),
                        //   ),
                        // ),
                        switchTab(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 130,
                      child: PageView(
                        controller: controller,
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: response
                                .map((Sector e) => ChartNumberCard(
                                      dashboard: e,
                                    ))
                                .toList(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: response
                                .map((Sector e) => ChartNumberCard(
                                      dashboard: e,
                                    ))
                                .toList(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: response
                                .map((Sector e) => ChartNumberCard(
                                      dashboard: e,
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: warningPost!.rows!
                    .map((e) => PostCard(
                          data: e,
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryYellow,
        onPressed: () async {
          bottomDrawerController.open();
        },
        child: const Icon(
          Icons.add,
          size: 30,
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
                    onTap: () {},
                    child: Container(
                      width: 37,
                      height: 37,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryBorderColor, width: 1),
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
                    onTap: () {
                      setState(() {
                        controller.jumpToPage(1);
                      });
                    },
                    child: Container(
                      width: 37,
                      height: 37,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryBorderColor, width: 1),
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
                    onTap: () {},
                    child: Container(
                      width: 37,
                      height: 37,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryBorderColor, width: 1),
                        borderRadius: BorderRadius.circular(80),
                      ),
                      child: SvgPicture.asset(
                        "assets/tab/3.svg",
                        width: 37,
                        height: 37,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 18),
              Container(
                width: 32,
                height: 32,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  // color: Color(0x4ff3f4448),
                  // border: Border.all(color: primaryBorderColor, width: 1),
                  borderRadius: BorderRadius.circular(80),
                ),
                child: SvgPicture.asset(
                  "assets/tab/4.svg",
                  width: 32,
                  height: 32,
                ),
              ),
              InkWell(
                onTap: () {
                  user.username == null
                      ? Navigator.of(context).pushNamed(LoginPage.routeName)
                      : Navigator.of(context).pushNamed(ProfilePage.routeName);
                },
                child: Container(
                  width: 37,
                  height: 37,
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryBorderColor, width: 1),
                    borderRadius: BorderRadius.circular(80),
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage("https://picsum.photos/id/1/200/200"),
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
