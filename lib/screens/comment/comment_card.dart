import 'package:flutter/material.dart';
import 'package:sos/models/user.dart';
import 'package:sos/provider/user_provider.dart';
import 'package:sos/screens/login/login_page.dart';
import 'package:sos/widgets/colors.dart';
import 'package:sos/widgets/form_textfield.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({Key? key}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  User user = User();
  bool? postLoading;
  bool? isLike = false;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: false).user;

    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 15),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15),
                height: 37,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                    image: AssetImage(
                      'assets/icon/appstore.png',
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), color: white),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10, top: 5),
                          child: Text(
                            'Захирагчийн Ажлын Алба',
                            style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, top: 5, bottom: 5),
                          child: Text(
                            'Залуучууд гоёээшдээ',
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 15, top: 5),
                        child: postLoading != true
                            ? Container(
                                margin: const EdgeInsets.only(left: 5, top: 4),
                                child: Row(
                                  children: [
                                    Text(
                                      'Нийтлэж байна',
                                      style:
                                          TextStyle(color: grey, fontSize: 11),
                                    ),
                                    SpinKitCircle(
                                      color: grey,
                                      size: 11,
                                    ),
                                  ],
                                ),
                              )
                            : Text(
                                "саяхан",
                                style: TextStyle(
                                  color: grey,
                                  fontSize: 11,
                                ),
                              ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, top: 4),
                        child: LikeButton(
                          size: 20,
                          likeCount: 0,
                          isLiked: isLike,
                          onTap: (liked) async {
                            if (user.id != null) {
                              if (liked == false) {
                                liked = true;
                              } else {
                                liked = false;
                              }
                            } else {
                              Navigator.of(context)
                                  .pushNamed(LoginPage.routeName);
                            }
                            return liked;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
