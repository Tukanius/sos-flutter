import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sos/api/post_api.dart';
import 'package:sos/components/Header/index.dart';
import 'package:sos/models/post.dart';
import 'package:sos/models/result.dart';
import 'package:sos/models/user.dart';
import 'package:sos/provider/user_provider.dart';
import 'package:sos/screens/comment/comment_page.dart';
import 'package:sos/screens/login/login_page.dart';
import 'package:sos/screens/profile/screens/components/page_change_controller.dart';
import 'package:sos/screens/search/search_page.dart';
import 'package:sos/widgets/colors.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:after_layout/after_layout.dart';
import 'package:provider/provider.dart';

class NewsFeedPostCard extends StatefulWidget {
  final Filter? filter;
  final PageChangeController? pageChangeController;
  const NewsFeedPostCard({
    Key? key,
    this.filter,
    this.pageChangeController,
  }) : super(key: key);

  @override
  State<NewsFeedPostCard> createState() => _NewsFeedPostCardState();
}

class _NewsFeedPostCardState extends State<NewsFeedPostCard>
    with AfterLayoutMixin {
  User user = User();
  bool? isLike = false;
  int likeCount = 0;
  bool loading = true;
  int page = 1;
  int limit = 1000;
  Result? warningPost = Result(count: 0, rows: []);
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(const Duration(microseconds: 1000));
    setState(() {
      loading = true;
    });
    await post(page, limit);
    _refreshController.refreshCompleted();
    setState(() {
      loading = false;
    });
  }

  void _onLoading() async {
    setState(() {
      limit += 10;
    });
    await post(page, limit);
    await Future.delayed(const Duration(microseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    if (widget.pageChangeController != null) {
      widget.pageChangeController?.addListener(() async {
        await post(page, limit);
      });
    }
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
    user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          child:
              // SmartRefresher(
              //   header: const WaterDropHeader(),
              //   footer: CustomFooter(
              //     builder: (context, mode) {
              //       Widget body;
              //       if (mode == LoadStatus.idle) {
              //         body = const Text("");
              //       } else if (mode == LoadStatus.loading) {
              //         body = const CupertinoActivityIndicator();
              //       } else if (mode == LoadStatus.failed) {
              //         body = const Text("Алдаа гарлаа. Дахин үзнэ үү!");
              //       } else {
              //         body = const Text("Мэдээлэл алга байна");
              //       }
              //       return SizedBox(
              //         height: 55,
              //         child: Center(
              //           child: body,
              //         ),
              //       );
              //     },
              //   ),
              //   onRefresh: _onRefresh,
              //   onLoading: _onLoading,
              //   enablePullDown: true,
              //   enablePullUp: true,
              //   controller: _refreshController,
              //   child:
              Column(
            children: [
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 15),
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   width: MediaQuery.of(context).size.width,
              //   height: 50,
              //   decoration: BoxDecoration(
              //     color: white,
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.of(context).pushNamed(SearchPage.routeName);
              //     },
              //     borderRadius: BorderRadius.circular(15),
              //     child: Row(
              //       children: const [
              //         Icon(
              //           Icons.manage_search_sharp,
              //           color: dark,
              //         ),
              //         SizedBox(
              //           width: 8,
              //         ),
              //         Text(
              //           "Хайх...",
              //           style: TextStyle(fontSize: 12),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              for (var i = 0; i < 10; i++)
                Container(
                  margin:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  decoration: BoxDecoration(
                    // border: Border.all(color: black, width: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    color: white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            // color: black,
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: black,
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/icon/darkhan.jpg',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(
                                  'Захирагчын Ажлын Алба',
                                  style: TextStyle(
                                    color: dark,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '2023-03-15',
                                    style: const TextStyle(
                                      color: grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.public,
                                    size: 12,
                                    color: black,
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: ClipRRect(
                          child: Image(
                            image: NetworkImage(
                                "https://wallpapercave.com/wp/wp5921946.jpg"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: ExpandableText(
                          'МУЗЕЙН НЭЭЛТТЭЙ ӨДРҮҮД ҮРГЭЛЖИЛЖ БАЙНА. Эх орныхоо өв соёлыг түгээн дэлгэрүүлэх, бахархах, үндэсний нэгдмэл үнэт зүйлийг бэхжүүлэх зорилготой, Монгол орон даяар өрнө буй МУЗЕЙН НЭЭЛТТЭЙ ӨДРҮҮД.',
                          collapseText: 'Хаах',
                          expandText: 'Дэлгэрэнгүй',
                          linkColor: Colors.blue,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                // border: Border.all(color: greyDark, width: 0.3),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(18),
                                  bottomRight: Radius.circular(18),
                                ),
                              ),
                              child: LikeButton(
                                  size: 25,
                                  likeCount: 0,
                                  isLiked: isLike,
                                  onTap: (like) async {
                                    if (user.id != null) {
                                      if (like == false) {
                                        like = true;
                                      } else {
                                        like = false;
                                      }
                                    } else {
                                      Navigator.of(context)
                                          .pushNamed(LoginPage.routeName);
                                    }
                                    return like;
                                  }),
                              height: 55,
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                    // border:
                                    // Border.all(color: greyDark, width: 0.3),
                                    borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(18),
                                )
                                    // color: black,
                                    ),
                                height: 55,
                                child: Container(
                                  decoration: BoxDecoration(
                                      // border: Border.all(width: 0.3, color: grey),
                                      ),
                                  height: 55,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => CommentPage(),
                                        ),
                                      );
                                    },
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        child: Icon(
                                          Icons.comment_outlined,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                    // border:
                                    // Border.all(color: greyDark, width: 0.3),
                                    borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(18),
                                )
                                    // color: black,
                                    ),
                                height: 55,
                                child: Container(
                                  decoration: BoxDecoration(
                                      // border: Border.all(width: 0.3, color: grey),
                                      ),
                                  height: 55,
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Icon(
                                        Icons.share_outlined,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
          // ),
        ),
      ),
    );
  }
}
