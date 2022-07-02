import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sos/components/not_found_page.dart';
import 'package:sos/screens/home/components/post_card.dart';
import 'package:sos/screens/profile/screens/components/page_change_controller.dart';
import 'package:sos/widgets/colors.dart';
import 'package:skeletons/skeletons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../api/post_api.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../models/result.dart';

class Page1 extends StatefulWidget {
  final String? name;
  final Filter? filter;
  final double? height;
  final String? type;
  final bool? loading;
  final PageChangeController? pageChangeController;
  const Page1(
      {Key? key,
      this.name,
      this.filter,
      this.height,
      this.type,
      this.loading,
      this.pageChangeController})
      : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> with AfterLayoutMixin {
  bool loading = true;
  int page = 1;
  int limit = 10;
  Result? warningPost = Result(count: 0, rows: []);
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onLoading() async {
    setState(() {
      limit += 10;
    });
    await post(page, limit);
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      loading = true;
    });
    await post(page, limit);
    _refreshController.refreshCompleted();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    if (widget.pageChangeController != null) {
      widget.pageChangeController?.addListener(() async {
        await post(page, limit);
      });
    }

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
    return Scaffold(
      body: loading == true
          ? SingleChildScrollView(
              child: Column(
                children: [
                  for (var i = 0; i < 5; i++)
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
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
                                        shape: BoxShape.circle,
                                        width: 37,
                                        height: 37),
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
                                            borderRadius:
                                                BorderRadius.circular(1),
                                            minLength: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                6,
                                            maxLength: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
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
                                        border: Border.all(
                                            width: 0.2, color: grey)),
                                    height: 55,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                        border: Border.all(
                                            width: 0.2, color: grey)),
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
              ),
            )
          : warningPost!.rows!.isEmpty
              ? const NotFoundPage()
              : SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: const WaterDropHeader(),
                  footer: CustomFooter(
                    builder: (context, mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = const Text("");
                      } else if (mode == LoadStatus.loading) {
                        body = const CupertinoActivityIndicator();
                      } else if (mode == LoadStatus.failed) {
                        body = const Text("Алдаа гарлаа. Дахин үзнэ үү!");
                      } else {
                        body = const Text("Мэдээлэл алга байна");
                      }
                      return SizedBox(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: ListView.builder(
                    itemCount: warningPost!.rows!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromARGB(255, 226, 221, 221),
                              width: 1,
                            ),
                          ),
                        ),
                        child: PostCard(
                          data: warningPost!.rows![index],
                          type: widget.type,
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
