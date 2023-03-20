import 'package:flutter/material.dart';
import 'package:sos/widgets/colors.dart';
import 'package:sos/widgets/form_textfield.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({Key? key}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
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
                  InkWell(
                    onDoubleTap: () {},
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: white),
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
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          "саяхан",
                          style: TextStyle(
                            color: grey,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, top: 4),
                        child: Text(
                          "Таалагдлаа",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
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
