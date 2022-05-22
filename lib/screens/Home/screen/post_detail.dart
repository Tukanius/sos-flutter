import 'package:flutter/material.dart';
import 'package:sos/models/post.dart';
import 'package:sos/models/user.dart';
import 'package:sos/screens/Home/index.dart';
import 'package:sos/widgets/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:after_layout/after_layout.dart';
import 'package:provider/provider.dart';
import 'package:sos/widgets/custom_button.dart';
import 'package:sos/widgets/form_textfield.dart';
import '../../../api/post_api.dart';
import '../../../components/before_after/index.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../../components/upload_image/form_upload_image.dart';
import '../../../provider/sector_provider.dart';
import '../../../provider/user_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PostDetailPageArguments {
  String id;
  PostDetailPageArguments({
    required this.id,
  });
}

class PostDetailPage extends StatefulWidget {
  final String id;
  static const routeName = "/postdetailpage";

  const PostDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> with AfterLayoutMixin {
  bool? isLoading = true;
  Post data = Post();
  User user = User();
  bool? isConfirm = false;
  bool? isFailed = false;
  bool? loading = false;
  bool resultImageHasError = false;
  GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();
  FormBuilderFieldState<FormBuilderField<dynamic>, dynamic> field =
      FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>();
  @override
  void afterFirstLayout(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    Post res = await PostApi().getPost(widget.id);
    setState(() {
      data = res;
      isLoading = false;
    });
  }

  onSubmit() async {
    if (isConfirm == true) {
      if (fbKey.currentState!.saveAndValidate() &&
          fbKey.currentState!.fields["resultImage"]!.value != "") {
        try {
          setState(() {
            loading = true;
          });
          Post save = Post.fromJson(fbKey.currentState!.value);
          save.postStatus = "SOLVED";
          await PostApi().addResult(data.id, save);
          await Provider.of<SectorProvider>(context, listen: false).sector();
          Navigator.of(context).restorablePopAndPushNamed(HomePage.routeName);
          setState(() {
            loading = false;
          });
        } catch (e) {
          debugPrint(e.toString());
          setState(() {
            loading = false;
          });
        }
      } else {
        if (fbKey.currentState!.fields["resultImage"]!.value == "") {
          setState(() {
            resultImageHasError = true;
          });
        }
      }
    } else {
      if (fbKey.currentState!.saveAndValidate()) {
        try {
          setState(() {
            loading = true;
          });
          Post save = Post.fromJson(fbKey.currentState!.value);
          save.postStatus = "FAILED";
          await PostApi().addResult(data.id, save);
          await Provider.of<SectorProvider>(context, listen: false).sector();
          Navigator.of(context).restorablePopAndPushNamed(HomePage.routeName);
          setState(() {
            loading = false;
          });
        } catch (e) {
          debugPrint(e.toString());
          setState(() {
            loading = false;
          });
        }
      }
      setState(() {
        loading = false;
      });
    }
  }

  postStatus() {
    switch (data.postStatus) {
      case "NEW":
        return const Text(
          "Шинэ",
          style: TextStyle(color: red),
        );
      case "PENDING":
        return const Text(
          "Хүлээгдэж байгаа",
          style: TextStyle(color: orange),
        );
      case "SOLVED":
        return const Text(
          "Шийдэгдсэн",
          style: TextStyle(color: Color(0x4ff34a853)),
        );
      case "FAILED":
        return const Text(
          "Шийдэгдээгүй",
          style: TextStyle(color: grey),
        );
      default:
    }
  }

  icon() {
    switch (data.postStatus) {
      case "NEW":
        return SvgPicture.asset(
          "assets/tab/1.svg",
          width: 37,
          height: 37,
        );
      case "PENDING":
        return SvgPicture.asset(
          "assets/tab/2.svg",
          width: 37,
          height: 37,
        );
      case "SOLVED":
        return SvgPicture.asset(
          "assets/tab/3.svg",
          width: 37,
          height: 37,
        );
      case "FAILED":
        return SvgPicture.asset(
          "assets/tab/5.svg",
          width: 37,
          height: 37,
        );
      default:
    }
  }

  actionButton() {
    if (isConfirm == false && isFailed == false) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isConfirm = true;
                  });
                },
                child: const Text(
                  "Шийдвэрлэсэн",
                  style: TextStyle(
                    color: green,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isFailed = true;
                  });
                },
                child: const Text(
                  "Шийдвэрлэж чадаагүй",
                  style: TextStyle(
                    color: red,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      if (isConfirm == true) {
        return hasConfirm();
      } else if (isFailed == true) {
        return hasFailed();
      }
    }
  }

  hasConfirm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: FormBuilder(
        key: fbKey,
        initialValue: const {"resultImage": "", "result": ""},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormUploadImage(
              onChange: onChange,
              user: user,
              name: "resultImage",
              hasError: resultImageHasError,
              fbKey: fbKey,
              setFieldValue: (value) {
                fbKey.currentState!.fields["resultImage"]!.didChange(value);
                setState(() {
                  resultImageHasError = false;
                });
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                resultImageHasError == true
                    ? const Text(
                        "Зураг заавал оруулна",
                        style: TextStyle(color: red, fontSize: 12),
                      )
                    : const SizedBox(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: white,
              width: MediaQuery.of(context).size.width,
              child: FormTextField(
                name: "result",
                inputType: TextInputType.text,
                maxLines: null,
                inputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.none,
                autoFocus: true,
                decoration: InputDecoration(
                  enabled: true,
                  prefixIconColor: primaryGreen,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  disabledBorder: InputBorder.none,
                  filled: true,
                  hintStyle:
                      const TextStyle(color: Colors.black54, fontSize: 14),
                  hintText: "Хэрхэн шийдвэрлэсэн эсэх.",
                  fillColor: grey.withOpacity(0.2),
                ),
                validators: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'Заавал оруулна уу')
                ]),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
              onClick: () {
                if (loading == false) {
                  onSubmit();
                }
              },
              width: MediaQuery.of(context).size.width,
              labelText: "Илгээх",
              fontSize: 16,
              color: orange,
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  hasFailed() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: FormBuilder(
        key: fbKey,
        initialValue: const {"result": ""},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: white,
              width: MediaQuery.of(context).size.width,
              child: FormTextField(
                name: "result",
                inputType: TextInputType.text,
                autoFocus: true,
                inputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.none,
                decoration: InputDecoration(
                  enabled: true,
                  prefixIconColor: primaryGreen,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  disabledBorder: InputBorder.none,
                  filled: true,
                  hintStyle:
                      const TextStyle(color: Colors.black54, fontSize: 14),
                  hintText: "Яагаад шийдвэрлэх боломжгүй эсэх",
                  fillColor: grey.withOpacity(0.2),
                ),
                validators: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'Заавал оруулна уу')
                ]),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
              width: MediaQuery.of(context).size.width,
              onClick: () {
                if (loading == false) {
                  onSubmit();
                }
              },
              labelText: "Илгээх",
              color: orange,
              fontSize: 16,
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  onChange(image) async {
    setState(() {
      data.resultImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Эрсдэлийг дэлгэрэнгүй",
          style: TextStyle(fontSize: 16, color: dark),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.close,
                color: dark,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: isLoading == true
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: const Center(
                  child: SpinKitCircle(
                    size: 30,
                    color: orange,
                  ),
                ),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        icon(),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.sector == null
                                        ? "Эрсдэл"
                                        : "${data.sector!.fullName}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  postStatus(),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "2022.04.29",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  data.postStatus == "NEW"
                                      ? user.id == data.user!.id
                                          ? InkWell(
                                              onTap: () {},
                                              child:
                                                  const Icon(Icons.more_vert),
                                            )
                                          : const SizedBox()
                                      : const SizedBox(),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      data.resultImage != null
                          ? BeforeAfter(
                              imageCornerRadius: 0,
                              imageHeight:
                                  MediaQuery.of(context).size.height * 0.45,
                              imageWidth: MediaQuery.of(context).size.width,
                              beforeImage: NetworkImage("${data.getImage()}"),
                              afterImage: NetworkImage("${data.resImage()}"),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.45,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    data.getImage(),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Material(
                                borderRadius: BorderRadius.circular(15),
                                color: white,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: () async {
                                    await PostApi().like(data.id.toString());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(width: 0.5, color: grey),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/heart.svg",
                                          color: dark.withOpacity(0.5),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "${data.likeCount}",
                                          style: TextStyle(
                                            color: dark.withOpacity(0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                decoration: BoxDecoration(
                                  color: white,
                                  border: Border.all(width: 0.5, color: grey),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/location.svg",
                                      color: dark.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  card(),
                  data.sector == null ? const SizedBox() : pendingCard(),
                  data.result == null ? const SizedBox() : resultCard(),
                  data.postStatus == "PENDING"
                      ? data.sector!.id == user.sector
                          ? actionButton()
                          : const SizedBox()
                      : const SizedBox(),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
      ),
    );
  }

  card() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: grey, width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(180),
              color: red,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data.text}",
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Text(
                      "${data.createdAt}",
                      style: const TextStyle(fontSize: 12, color: greyDark),
                    ),
                    Container(
                      height: 6,
                      width: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: greyDark,
                      ),
                    ),
                    Text(
                      "${data.user!.firstName} ${data.user!.lastName}",
                      style: const TextStyle(fontSize: 12, color: greyDark),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  pendingCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: grey, width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(180),
              color: orange,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data.sector!.fullName}-д хуваарилагдсан",
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 7),
                Text(
                  "${data.createdAt}",
                  style: const TextStyle(fontSize: 12, color: greyDark),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  resultCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: grey, width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(180),
              color: data.postStatus == "SOLVED" ? green : grey,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data.result}",
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Text(
                      "${data.createdAt}",
                      style: const TextStyle(fontSize: 12, color: greyDark),
                    ),
                    Container(
                      height: 6,
                      width: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: greyDark,
                      ),
                    ),
                    Text(
                      "${data.sector!.fullName}",
                      style: const TextStyle(fontSize: 12, color: greyDark),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
