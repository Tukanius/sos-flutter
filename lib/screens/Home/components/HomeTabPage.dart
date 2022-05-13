import 'package:flutter/material.dart';
import 'package:sos/provider/general_provider.dart';
import 'package:sos/widgets/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class HomeTabPage extends StatefulWidget {
  HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  final PageController controller = PageController();
  BottomDrawerController bottomDrawerController = BottomDrawerController();
  int currentIndex = 0;

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
                      Container(
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
                                  Container(
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
                  Container(
                    height: 130,
                    child: PageView(
                      controller: controller,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      children: [
                        switchTabBody(),
                        Container(
                          child: Text("PIE CHART"),
                        ),
                        Container(
                          child: Text("LINE CHART"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                await Provider.of<GeneralProvider>(context, listen: false)
                    .setBottomDrawerSetType("VIEW");
                bottomDrawerController.open();
              },
              child: card(),
            ),
            InkWell(
              onTap: () async {
                await Provider.of<GeneralProvider>(context, listen: false)
                    .setBottomDrawerSetType("VIEW");
                bottomDrawerController.open();
              },
              child: card(),
            ),
          ],
        ),
      ),
    );
  }

  card() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/tab/1.svg",
                  width: 37,
                  height: 37,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Шинэ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("2 цагын өмнө"),
                        ],
                      ),
                    ),
                    const Text("Хүлээгдэж байна."),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Image.asset("assets/post.png"),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              "3-9-р байр 3-24-р байр хоёрын хоорондох явган хүний замын эвдрэл",
              style: TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: white,
              border:
                  Border(top: BorderSide(color: Color(0x4ffEBEDF1), width: 1)),
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
                          // color: Color(0x4ffA7A7A7),
                        ),
                        const SizedBox(width: 7),
                        const Text("27"),
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
    );
  }

  switchTabBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                color: Color(0x4ffEA4335),
              ),
              child: const Center(
                child: Text(
                  "5",
                  style: TextStyle(
                      color: white, fontSize: 25, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Хүлээгдэж байна",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            )
          ],
        ),
        Column(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                color: Color(0x4ffFBBC05),
              ),
              child: const Center(
                child: Text(
                  "12",
                  style: TextStyle(
                      color: white, fontSize: 25, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Хянагдаж байна",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            )
          ],
        ),
        Column(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                color: Color(0x4ff34A853),
              ),
              child: const Center(
                child: Text(
                  "1500",
                  style: TextStyle(
                      color: white, fontSize: 25, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Шийдвэрлэгдсэн",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            )
          ],
        ),
      ],
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
              padding: EdgeInsets.all(6),
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
