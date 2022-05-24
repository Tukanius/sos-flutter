import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:sos/api/post_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:sos/models/post.dart';
import 'package:sos/models/result.dart';
import 'package:sos/models/user.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:sos/provider/post_provider.dart';
import 'package:sos/screens/home/index.dart';
import 'package:sos/screens/splash/index.dart';
import 'package:sos/widgets/colors.dart';
import 'package:like_button/like_button.dart';
import '../../../main.dart';
import '../../../provider/sector_provider.dart';
import '../../../provider/user_provider.dart';
import '../../../services/dialog.dart';
import '../../../services/navigation.dart';
import '../../profile/screens/my_create_post_page.dart';
import '../screen/edit_post.dart';
import '../screen/post_detail.dart';

class PostCard extends StatefulWidget {
  final Post? data;
  final String? type;

  const PostCard({
    Key? key,
    this.data,
    this.type,
  }) : super(key: key);

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
      return "Цуцалсан";
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
  User user = User();
  bool? likeLoading = false;
  bool? isDelete = false;
  bool? isLoading = false;
  int page = 1;
  int limit = 1000;
  Filter filter = Filter();

  boderColor() {
    switch (widget.data!.postStatus) {
      case "NEW":
        return red;
      case "PENDING":
        return orange;
      case "SOLVED":
        return green;
      case "FAILED":
        return grey;
      default:
    }
  }

  show(ctx, data) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'Устгах',
                        style: TextStyle(
                            color: dark,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Та энэ эрсдэлийг устгахдаа итгэлтэй байна уу?',
                        textAlign: TextAlign.center,
                      ),
                      ButtonBar(
                        buttonMinWidth: 100,
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          TextButton(
                            child: const Text(
                              "Болих",
                              style: TextStyle(color: dark),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              setState(() {
                                isDelete = false;
                              });
                            },
                          ),
                          TextButton(
                            child: const Text(
                              "Устгах",
                              style: TextStyle(color: dark),
                            ),
                            onPressed: () async {
                              if (isLoading == false) {
                                deleteButton(context, data, ctx);
                              }
                              setState(() {
                                isDelete = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Lottie.asset('assets/garbage.json', height: 150, repeat: false),
              ],
            ),
          );
        });
  }

  click(context) async {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    locator<NavigationService>().pushReplacementNamed(
      routeName: MyCreatePostPage.routeName,
    );
  }

  deleteButton(context, data, ctx) async {
    setState(() {
      isLoading = true;
    });
    try {
      await PostApi().deletePost(data.id);
      await Provider.of<SectorProvider>(ctx, listen: false).sector();
      Navigator.of(context).pop();
      widget.type == "MYPOST"
          ? click(ctx)
          : locator<NavigationService>().restorablePopAndPushNamed(
              routeName: HomePage.routeName,
            );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  actionPopUpItemSelected(String value, data) async {
    if (value == 'edit') {
      Navigator.of(context).pushNamed(EditPostPage.routeName,
          arguments: EditPostPageArguments(data: data));
    } else if (value == 'delete') {
      if (isDelete == false) {
        setState(() {
          isDelete = true;
        });
        show(context, data);
      }
    } else {}
  }

  Widget get _customWidget => Container(width: 500, height: 250, color: white);

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: false).user;
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
              title: const Text('Эрсдэл'),
              subtitle: Text(
                '${type(widget.data)}',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.6), fontSize: 12),
              ),
              trailing: widget.data!.postStatus == "NEW"
                  ? user.id == widget.data!.user!.id
                      ? PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) {
                            return [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Засах'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Устгах'),
                              )
                            ];
                          },
                          onSelected: (String value) =>
                              actionPopUpItemSelected(value, widget.data),
                        )
                      : const SizedBox()
                  : const SizedBox(),
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  Navigator.of(context).pushNamed(PostDetailPage.routeName,
                      arguments: PostDetailPageArguments(id: widget.data!.id!));
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: boderColor(),
                    width: 2,
                  )),
                  width: MediaQuery.of(context).size.width,
                  child: ProgressiveImage.custom(
                    placeholderBuilder: (BuildContext context) => _customWidget,
                    thumbnail: const NetworkImage(
                        'https://i.imgur.com/4WRfwXm.jpg'), // 64x43
                    image:
                        NetworkImage('${widget.data!.getImage()}'), // 3240x2160
                    height: 500,
                    width: MediaQuery.of(context).size.width,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LikeButton(
                              size: 35,
                              isLiked: widget.data!.liked,
                              circleColor: const CircleColor(
                                  start: Color(0xff00ddff),
                                  end: Color(0xff0099cc)),
                              bubblesColor: const BubblesColor(
                                dotPrimaryColor: Color(0xff33b5e5),
                                dotSecondaryColor: Color(0xff0099cc),
                              ),
                              likeBuilder: (bool isLiked) {
                                return likeLoading == false
                                    ? Icon(
                                        Icons.favorite,
                                        color: widget.data!.liked == true
                                            ? red
                                            : grey,
                                        size: 25,
                                      )
                                    : const SpinKitCircle(
                                        size: 25,
                                        color: orange,
                                      );
                              },
                              onTap: (value) async {
                                if (user.id != null) {
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
                                      await PostApi()
                                          .like(widget.data!.id.toString());
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
                                } else {
                                  locator<DialogService>()
                                      .showErrorDialogListener("Нэвтрэн үү");
                                }
                              },
                            ),
                            if (widget.data!.likeCount != 0)
                              Text("${widget.data!.likeCount}"),
                          ],
                        )),
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
