import 'package:flutter/material.dart';
import 'package:sos/api/post_api.dart';
import 'package:sos/api/suit_api.dart';
import 'package:sos/models/post.dart';
import 'package:sos/models/user.dart';
import 'package:sos/provider/user_provider.dart';
import 'package:sos/screens/login/login_page.dart';
import 'package:sos/widgets/colors.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NewsFeedPostCard extends StatefulWidget {
  final Post data;

  const NewsFeedPostCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<NewsFeedPostCard> createState() => _NewsFeedPostCardState();
}

class _NewsFeedPostCardState extends State<NewsFeedPostCard> {
  bool? likeLoading = false;
  Post share = Post();
  User user = User();
  bool? isLike = false;

  onPressShare() async {
    print("==============================");
    print(widget.data.toJson());
    print("==============================");
    share = await SuitApi().sharePost(widget.data.id.toString());
    print("res--------------------------");
    print(share.url);
    print("res--------------------------");
    await FlutterShare.share(
        title: widget.data.title != null && widget.data.title != ""
            ? '${widget.data.title}'
            : widget.data.text != null && widget.data.text != ""
                ? "${widget.data.text}"
                : "Ersdel Darkhan",
        text:
            widget.data.text != null ? '${widget.data.text}' : "Ersdel Darkhan",
        linkUrl: share.url,
        chooserTitle: widget.data.title != null ? '${widget.data.title}' : "");
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: false).user;

    return Container(
      child: Container(
        decoration: BoxDecoration(
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
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: AssetImage('assets/icon/darkhan.jpg'),
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
                        'Захирагчийн ажлын алба',
                        style: TextStyle(
                          color: dark,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        widget.data.postStatusDate != null
                            ? Text(
                                widget.data.getPostDate(),
                                style: const TextStyle(
                                  color: grey,
                                  fontSize: 10,
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          width: 5,
                        ),
                        // Icon(
                        //   Icons.public,
                        //   size: 12,
                        //   color: black,
                        // )
                      ],
                    )
                  ],
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(
                right: 20,
                left: 20,
                bottom: 10,
              ),
              child: ExpandableText(
                widget.data.text.toString(),
                collapseText: 'Хаах',
                expandText: 'Дэлгэрэнгүй',
                linkColor: Colors.blue,
                style: const TextStyle(fontSize: 12),
                maxLines: 4,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                child: Image(
                  image: NetworkImage(
                    widget.data.getImage(),
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if (user.id == null) {
                        Navigator.of(context).pushNamed(LoginPage.routeName);
                      } else {
                        setState(() {
                          likeLoading = true;
                        });
                        var res =
                            await PostApi().like(widget.data.id.toString());
                        setState(() {
                          likeLoading = false;
                          widget.data.likeCount = res.likeCount;
                          widget.data.liked = res.liked;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(),
                      height: 55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          likeLoading == false
                              ? Icon(
                                  Icons.favorite,
                                  color: widget.data.liked == true ? red : grey,
                                  size: 25,
                                )
                              : const SpinKitCircle(
                                  size: 25,
                                  color: orange,
                                ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (widget.data.likeCount != 0)
                            Text("${widget.data.likeCount}"),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onPressShare();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(18),
                      )
                          // color: black,
                          ),
                      height: 55,
                      child: Container(
                        height: 55,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Icon(
                              Icons.ios_share_outlined,
                              color: Colors.grey.shade500,
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
    );
  }
}
