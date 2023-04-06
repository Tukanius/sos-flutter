import 'package:flutter/material.dart';
import 'package:sos/widgets/colors.dart';

class Accordion extends StatefulWidget {
  final String title;
  final String content;

  const Accordion({Key? key, required this.title, required this.content})
      : super(key: key);
  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool _showContent = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        borderRadius: BorderRadius.circular(5),
        color: white,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {
            setState(() {
              _showContent = !_showContent;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    widget.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  trailing: IconButton(
                    icon: Icon(_showContent
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down),
                    onPressed: () {},
                  ),
                ),
                _showContent
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        child: Text(widget.content),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
