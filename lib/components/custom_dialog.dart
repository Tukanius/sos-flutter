import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:sos/api/post_api.dart';
import 'package:sos/components/custom_controller.dart';
import 'package:sos/models/post.dart';
import 'package:sos/widgets/colors.dart';

class CustomDialog extends StatefulWidget {
  final Post? data;
  final BuildContext? context;
  final CustomController customController;
  const CustomDialog(
      {Key? key, this.data, this.context, required this.customController})
      : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  bool? isDuplicate = false;
  bool? isReport = false;

  bool canUpload = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 25,
            ),
            SvgPicture.asset(
              "assets/report.svg",
              height: 80,
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Админд мэдэгдэх',
                  style: TextStyle(
                      color: dark, fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Яагаад нийтлэлийг админд мэдэгдэх болсон?",
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () {
                    if (isDuplicate == true) {
                      setState(() {
                        isDuplicate = false;
                      });
                    } else {
                      setState(() {
                        isDuplicate = true;
                        isReport = false;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: orange,
                        value: isDuplicate,
                        onChanged: (value) {
                          if (isDuplicate == true) {
                            setState(() {
                              isDuplicate = false;
                            });
                          } else {
                            setState(() {
                              isDuplicate = true;
                              isReport = false;
                            });
                          }
                        },
                      ),
                      const Expanded(
                        child: Text(
                          "Эрсдэлтэй хамааралгүй",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (isReport == true) {
                      setState(() {
                        isReport = false;
                      });
                    } else {
                      setState(() {
                        isReport = true;
                        isDuplicate = false;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: orange,
                        value: isReport,
                        onChanged: (value) {
                          if (isReport == true) {
                            setState(() {
                              isReport = false;
                            });
                          } else {
                            setState(() {
                              isReport = true;
                              isDuplicate = false;
                            });
                          }
                        },
                      ),
                      const Expanded(
                        child: Text(
                          "Давхардсан",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0.0,
              primary: orange, // Background color
            ),
            onPressed: isDuplicate == true || isReport == true
                ? () async {
                    if (isDuplicate == true) {
                      await PostApi().reportPost(widget.data!.id.toString(),
                          Post(reportType: "IRRELEVANT"));
                      widget.customController.changeVariable(true);
                    } else {
                      await PostApi().reportPost(widget.data!.id.toString(),
                          Post(reportType: "DUPLICATED"));
                      widget.customController.changeVariable(true);
                    }
                    Navigator.of(context).pop();
                    var snackBar = const SnackBar(
                        content: Text('Админд мэдэгдсэн баярлалаа'));
                    ScaffoldMessenger.of(widget.context!)
                        .showSnackBar(snackBar);
                  }
                : null,
            child: const Text('Мэдэгдэх'),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0.0,
              primary: dark, //
            ),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {});
            },
            child: Text('Болих'),
          ),
        ),
      ],
    );
  }
}
