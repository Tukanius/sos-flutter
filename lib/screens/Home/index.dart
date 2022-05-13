import 'package:flutter/material.dart';
import 'package:sos/components/Header/index.dart';
import 'package:sos/screens/Home/components/HomeTabPage.dart';
import 'package:sos/widgets/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/HomePage";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController controller = PageController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  changePage(index) {
    controller.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
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
    return Scaffold(
      backgroundColor: Color(0x4fff9fafb),
      appBar: CustomAppBar(),
      body: PageView(
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: <Widget>[
          HomeTabPage(),
          const Center(
            child: Text('2'),
          ),
          const Center(
            child: Text('3'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryYellow,
        onPressed: () {},
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        changePage(0);
                      },
                      child: Container(
                        width: 37,
                        height: 37,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: checkPage(0)
                              ? Color(0x4ff3f4448)
                              : primaryBorderColor,
                          border:
                              Border.all(color: primaryBorderColor, width: 1),
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
                        changePage(1);
                      },
                      child: Container(
                        width: 37,
                        height: 37,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: checkPage(1)
                              ? Color(0x4ff3f4448)
                              : primaryBorderColor,
                          border:
                              Border.all(color: primaryBorderColor, width: 1),
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
                      onTap: () {
                        changePage(2);
                      },
                      child: Container(
                        width: 37,
                        height: 37,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: checkPage(2)
                              ? Color(0x4ff3f4448)
                              : primaryBorderColor,
                          border:
                              Border.all(color: primaryBorderColor, width: 1),
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
                  width: 37,
                  height: 37,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    // color: Color(0x4ff3f4448),
                    // border: Border.all(color: primaryBorderColor, width: 1),
                    borderRadius: BorderRadius.circular(80),
                  ),
                  child: SvgPicture.asset(
                    "assets/tab/4.svg",
                    width: 37,
                    height: 37,
                  ),
                ),
                const SizedBox(width: 18),
                Container(
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
              ],
            )),
      ),
    );
  }
}
