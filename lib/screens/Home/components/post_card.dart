import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:sos/models/post.dart';
import 'package:sos/screens/home/screen/post_detail.dart';
import 'package:sos/widgets/colors.dart';

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
      return "assets/tab/1.svg";
    case "NEW":
      return "assets/tab/2.svg";
    case "SOLVED":
      return "assets/tab/3.svg";
    case "FAILED":
      return "assets/tab/4.svg";
    default:
  }
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
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
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          InkWell(
            onTap: () async {
              Navigator.of(context).pushNamed(PostDetailPage.routeName,
                  arguments: PostDetailPageArguments(id: widget.data!.id!));
            },
            child: Image.network(widget.data!.getImage()),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${widget.data!.text}',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {},
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
                          Text(widget.data!.likeCount.toString()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {},
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
              ),
            ],
          )
        ],
      ),
    );
  }
}
