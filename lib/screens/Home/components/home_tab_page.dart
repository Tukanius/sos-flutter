import 'package:flutter/material.dart';
import 'package:sos/api/post_api.dart';
import 'package:sos/models/post.dart';
import 'package:sos/models/sector.dart';
import 'package:sos/provider/general_provider.dart';
import 'package:sos/screens/home/components/chart_number.dart';
import 'package:sos/widgets/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:after_layout/after_layout.dart';

import '../../../api/dashboard_api.dart';
import '../../../models/result.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> with AfterLayoutMixin {
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
    Filter filter = Filter();

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

  @override
  Widget build(BuildContext context) {
    bottomDrawerController = Provider.of<GeneralProvider>(context, listen: true)
        .bottomDrawerController;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: white,
                hintText: "Хайх",
                prefixIcon: const Icon(Icons.search, color: Color(0x4ffEBEDF1)),
                contentPadding: const EdgeInsets.all(15),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 255, 254, 254), width: 0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 255, 254, 254), width: 0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 255, 254, 254), width: 0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(4),
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
                        width: MediaQuery.of(context).size.width / 1.7 - 20,
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
                              borderSide:
                                  const BorderSide(color: white, width: 0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: white, width: 0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                          items: ["Цахилгаан түгээх"]
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
                        const Text("PIE CHART"),
                        const Text("LINE CHART"),
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
                  .map((e) => Container(
                        child: card(e),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  type(Post data) {
    switch (data.postStatus) {
      case "PENDING":
        return "Хүлээгдэж байгаа";
      case "NEW":
        return "ШИНЭ";
      case "SOLVED":
        return "Шийдвэрлэгдсэн";
      case "FAILED":
        return "Шийдвэрлэгдээгүй";
      default:
    }
  }

  icon(Post data) {
    switch (data.postStatus) {
      case "PENDING":
        return "assets/tab/1.svg";
      case "NEW":
        return "assets/tab/2.svg";
      case "SOLVED":
        return "assets/tab/3.svg";
      case "FAILED":
        return "assets/tab/4.svg";
      default:
    }
  }

  card(Post data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () async {
          await Provider.of<GeneralProvider>(context, listen: false)
              .setBottomDrawerSetType("VIEW", "${data.id}");
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "${icon(data)}",
                      width: 37,
                      height: 37,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${data.user!.firstName} ${data.user!.lastName}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                type(data),
                              ),
                            ],
                          ),
                          const Text(
                            "date",
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 200,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    data.getImage(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.text.toString(),
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: white,
                  border: Border(
                      top: BorderSide(color: Color(0x4ffEBEDF1), width: 1)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/heart.svg",
                            ),
                            const SizedBox(width: 7),
                            Text(data.likeCount.toString()),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/location.svg",
                              color: Color(0x4ffA7A7A7),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
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
}
