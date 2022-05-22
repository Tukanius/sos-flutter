import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:sos/api/post_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sos/models/post.dart';
import 'package:sos/provider/post_provider.dart';
import 'package:sos/widgets/colors.dart';
import 'package:like_button/like_button.dart';
import '../screen/post_detail.dart';

class PostCard extends StatefulWidget {
  final Post? data;

  const PostCard({Key? key, this.data}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

type(Post? data) {
  switch (data!.postStatus) {
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

icon(Post? data) {
  switch (data!.postStatus) {
    case "PENDING":
      return "assets/tab/2.svg";
    case "NEW":
      return "assets/tab/1.svg";
    case "SOLVED":
      return "assets/tab/3.svg";
    case "FAILED":
      return "assets/tab/5.svg";
    default:
  }
}

class _PostCardState extends State<PostCard> {
  bool? likeLoading = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListTile(
              leading: SvgPicture.asset(
                "${icon(widget.data)}",
                width: 37,
                height: 37,
              ),
              title: Text('${widget.data!.user!.firstName}'),
              subtitle: Text(
                '${type(widget.data)}',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.6), fontSize: 12),
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  Navigator.of(context).pushNamed(PostDetailPage.routeName,
                      arguments: PostDetailPageArguments(id: widget.data!.id!));
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    widget.data!.getImage(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              width: double.infinity,
              child: Text(
                '${widget.data!.text}',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.6), fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      await Provider.of<PostProvider>(context, listen: false)
                          .getLike(widget.data!.id);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.3, color: grey)),
                      height: 55,
                      child: LikeButton(
                        size: 35,
                        isLiked: widget.data!.liked,
                        circleColor: const CircleColor(
                            start: Color(0xff00ddff), end: Color(0xff0099cc)),
                        bubblesColor: const BubblesColor(
                          dotPrimaryColor: Color(0xff33b5e5),
                          dotSecondaryColor: Color(0xff0099cc),
                        ),
                        likeBuilder: (bool isLiked) {
                          return likeLoading == false
                              ? Icon(
                                  Icons.favorite,
                                  color:
                                      widget.data!.liked == true ? red : grey,
                                  size: 25,
                                )
                              : const SpinKitCircle(
                                  size: 25,
                                  color: orange,
                                );
                        },
                        onTap: (value) async {
                          if (widget.data!.liked == false) {
                            setState(() {
                              likeLoading = true;
                            });
                            try {
                              await Provider.of<PostProvider>(context,
                                      listen: false)
                                  .getLike(widget.data!.id);
                              setState(() {
                                widget.data!.liked = true;
                                likeLoading = false;
                              });
                            } catch (e) {
                              setState(() {
                                likeLoading = false;
                              });
                            }
                          } else {
                            setState(() {
                              likeLoading = true;
                            });
                            try {
                              await PostApi().like(widget.data!.id.toString());
                              setState(() {
                                widget.data!.liked = false;
                                likeLoading = false;
                              });
                            } catch (e) {
                              setState(() {
                                likeLoading = false;
                              });
                            }
                          }
                          return widget.data!.liked;
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.3, color: grey)),
                      height: 55,
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/location.svg",
                          color: Color(0x4ffA7A7A7),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
