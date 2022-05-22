import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:sos/screens/home/components/post_card.dart';
import 'package:sos/widgets/colors.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../api/post_api.dart';
import '../../../../models/result.dart';

class Page1 extends StatefulWidget {
  final String? name;
  final Filter? filter;
  const Page1({Key? key, this.name, this.filter}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> with AfterLayoutMixin {
  bool loading = true;
  int page = 1;
  int limit = 1000;
  Result? warningPost = Result(count: 0, rows: []);

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await post(page, limit);
  }

  post(int page, int limit) async {
    Offset offset = Offset(limit: limit, page: page);
    Result res = await PostApi()
        .list(ResultArguments(filter: widget.filter, offset: offset));
    setState(() {
      warningPost = res;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      return Column(
        children: [
          for (var i = 0; i < 10; i++)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: SkeletonItem(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          left: 15, top: 15, bottom: 15, right: 25),
                      child: Row(
                        children: [
                          const SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                                shape: BoxShape.circle, width: 37, height: 37),
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
                                    borderRadius: BorderRadius.circular(1),
                                    minLength:
                                        MediaQuery.of(context).size.width / 6,
                                    maxLength:
                                        MediaQuery.of(context).size.width / 3,
                                  )),
                            ),
                          ),
                          const Icon(Icons.more_vert),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                          width: double.infinity, height: 200),
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
            ),
        ],
      );
    }
    return Container(
        padding: const EdgeInsets.only(
          right: 10,
          left: 10,
          top: 5,
        ),
        child: Column(
          children: [
            if (warningPost!.rows!.isEmpty)
              Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Image.asset(
                    "assets/empty.png",
                    height: 250,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Хоосон байна",
                    style: TextStyle(
                        color: orange,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            Column(
              children: [
                for (int i = 0; i < warningPost!.rows!.length; i++)
                  PostCard(
                    data: warningPost!.rows![i],
                  ),
              ],
            ),
          ],
        ));
  }
}
