import 'dart:async';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sos/api/post_api.dart';
import 'package:sos/screens/home/screen/post_detail.dart';
import 'package:sos/widgets/colors.dart';
import '../../models/result.dart';

class SearchPage extends StatefulWidget {
  static const routeName = "/searchpage";

  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AfterLayoutMixin {
  Timer? timer;
  Result result = Result(rows: [], count: 0);
  bool focused = true;
  bool isLoading = true;
  TextEditingController controller = TextEditingController();

  @override
  void afterFirstLayout(BuildContext context) {
    onChange(null);
  }

  onChange(value) async {
    setState(() {
      isLoading = true;
    });
    if (timer != null) timer!.cancel();
    timer = Timer(const Duration(milliseconds: 400), () async {
      Result res = await PostApi().list(
        ResultArguments(
          filter: Filter(query: value),
          offset: Offset(limit: 50, page: 1),
        ),
      );
      setState(() {
        result = res;
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) timer!.cancel();
  }

  postStatus(data) {
    switch (data) {
      case "NEW":
        return const Text(
          "Шинэ",
          style: TextStyle(color: red, fontSize: 12),
        );
      case "PENDING":
        return const Text(
          "Хүлээгдэж байгаа",
          style: TextStyle(color: orange, fontSize: 12),
        );
      case "SOLVED":
        return const Text(
          "Шийдэгдсэн",
          style: TextStyle(color: Color(0x4ff34a853), fontSize: 12),
        );
      case "FAILED":
        return const Text(
          "Цуцалсан",
          style: TextStyle(color: grey, fontSize: 12),
        );
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: const IconThemeData(color: dark),
        elevation: 0.0,
        title: SizedBox(
          height: 30,
          child: TextField(
            style: const TextStyle(fontSize: 14),
            autofocus: true,
            onChanged: onChange,
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Хайх',
              hintStyle: const TextStyle(fontSize: 14),
              suffixIcon: controller.text.isNotEmpty
                  ? InkWell(
                      onTap: () {
                        controller.clear();
                        onChange(null);
                      },
                      child: const Icon(
                        Icons.close,
                        color: dark,
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: isLoading == true
            ? const Center(
                child: SpinKitPulse(
                  color: grey,
                ),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  for (var i = 0; i < result.rows!.length; i++)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 50,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Material(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              PostDetailPage.routeName,
                              arguments: PostDetailPageArguments(
                                  id: result.rows![i].id),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 5, right: 10),
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          result.rows![i].getImage(),
                                        ),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    "${result.rows![i].text}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: dark,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                postStatus(result.rows![i].postStatus)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
