import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:sos/models/notification.dart';
import 'package:provider/provider.dart';
import '../../api/notify_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../provider/user_provider.dart';
import '../../widgets/colors.dart';

class NotificationDetailPageArguments {
  String id;
  NotificationDetailPageArguments({
    required this.id,
  });
}

class NotificationDetailPage extends StatefulWidget {
  static const routeName = "/NotificationDetailPage";

  final String? id;
  const NotificationDetailPage({Key? key, this.id}) : super(key: key);

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage>
    with AfterLayoutMixin {
  Notify? data;
  bool isLoading = true;

  @override
  void afterFirstLayout(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    data = await NotifyApi().getNotify(widget.id!);
    await Provider.of<UserProvider>(context, listen: false).me(true);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(color: dark),
        backgroundColor: primaryColor,
        title: const Text(
          "Мэдэгдэл",
          style: TextStyle(
            color: dark,
            fontSize: 16,
          ),
        ),
      ),
      body: isLoading == true
          ? const Center(
              child: SpinKitCircle(
                size: 30,
                color: black,
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data!.title.toString(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    data!.getDate().toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  data!.image == null
                      ? const SizedBox()
                      : Container(
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(
                                  data!.getImage(),
                                ),
                                fit: BoxFit.cover),
                          ),
                          width: MediaQuery.of(context).size.width,
                        ),
                  data!.image == null
                      ? const SizedBox()
                      : const SizedBox(
                          height: 10,
                        ),
                  Text(data!.body.toString()),
                ],
              ),
            ),
    );
  }
}
