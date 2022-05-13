import 'package:flutter/material.dart';
import 'package:sos/widgets/colors.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class HomeTabPage extends StatefulWidget {
  HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  final PageController controller = PageController();
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
          ],
        ),
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
