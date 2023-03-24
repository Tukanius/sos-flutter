import 'package:flutter/material.dart';
import 'package:sos/components/not_found_page.dart';
import 'package:sos/screens/comment/comment_card.dart';
import 'package:sos/widgets/colors.dart';
import 'package:sos/widgets/form_textfield.dart';
import 'package:sos/provider/sector_provider.dart';
import 'package:sos/models/sector.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({Key? key}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  List<Sector> response = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0.0,
        iconTheme: IconThemeData(color: greyDark),
        title: Text(
          'Сэтгэгдэлүүд',
          style: TextStyle(
            color: greyDark,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  response.isNotEmpty ? CommentCard() : NotFoundPage(),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: white,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: Form(
                            child: FormTextField(
                              name: 'commenttext',
                              hintText: 'Сэтгэгдэл бичих...',
                              autoFocus: true,
                              maxLines: null,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.send_rounded,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
