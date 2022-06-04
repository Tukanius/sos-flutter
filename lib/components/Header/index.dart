import 'package:flutter/material.dart';
import 'package:sos/screens/map/map_screen_page.dart';
import 'package:sos/widgets/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

Color selectColor = Color(0x4ff3f4448);
Color unSelectColor = Color(0x4ffEBEDF1);

class _CustomAppBarState extends State<CustomAppBar> {
  String switchType = "LIST";

  selectCheck(type) {
    if (switchType == type) {
      return selectColor;
    } else {
      return unSelectColor;
    }
  }

  selectCheckIcon(type) {
    if (switchType == type) {
      return unSelectColor;
    } else {
      return selectColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.3,
      backgroundColor: white,
      centerTitle: false,
      title: Image.asset(
        "assets/header-logo.png",
        height: 40,
      ),
      actions: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(color: primaryBorderColor, width: 1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        switchType = "LIST";
                      });
                    },
                    child: AnimatedContainer(
                      height: 32,
                      width: 32,
                      duration: Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: selectCheck("LIST"),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: SvgPicture.asset(
                        "assets/list-icon.svg",
                        color: selectCheckIcon("LIST"),
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  InkWell(
                    onTap: () {
                      // setState(() {
                      //   switchType = "MAP";
                      // });
                      Navigator.of(context).pushNamed(MapScreenPage.routeName);
                    },
                    child: AnimatedContainer(
                      height: 32,
                      width: 32,
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: selectCheck("MAP"),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: SvgPicture.asset(
                        "assets/marker.svg",
                        color: selectCheckIcon("MAP"),
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
          ],
        )
      ],
    );
  }
}
