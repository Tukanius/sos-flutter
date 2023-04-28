import 'package:flutter/material.dart';
import 'package:sos/models/post.dart';
import 'package:sos/models/user.dart';
import 'package:sos/screens/Home/index.dart';
import 'package:sos/screens/home/screen/edit_post.dart';
import 'package:sos/widgets/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:after_layout/after_layout.dart';
import 'package:provider/provider.dart';
import 'package:sos/widgets/custom_button.dart';
import 'package:sos/widgets/form_textfield.dart';
import '../../../api/post_api.dart';
import '../../../components/before_after/index.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../../components/not_found_page.dart';
import '../../../components/upload_image/form_upload_image.dart';
import '../../../main.dart';
import '../../../provider/sector_provider.dart';
import '../../../provider/user_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../services/navigation.dart';

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
  bool? deleteloading = true;
  Post data = Post();
  bool? visible = false;
  User user = User();
  bool? isConfirm = false;
  bool? isFailed = false;
  bool? likeLoading = false;
  bool? isDelete = false;
  bool? isReturn = false;
  bool? loading = false;
  bool resultImageHasError = false;

  GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();
  FormBuilderFieldState<FormBuilderField<dynamic>, dynamic> field =
      FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>();

  final List<Marker> _marker = [];
  late final Marker _list;

  permissionAsk() async {
    try {
      var status = await Permission.location.status;
      if (status.isDenied) {
        debugPrint("=====================DENIED============");
      }
      if (await Permission.location.isRestricted) {
        debugPrint("=====================isRestricted============");
      }
      if (await Permission.location.request().isGranted) {}
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
      ].request();
      debugPrint(statuses[Permission.location].toString());
    } catch (e) {}
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    Post res = await PostApi().getPost(widget.id);

    setState(() {
      data = res;
      isLoading = false;
      if (data.location!.lat != null) {
        _list = Marker(
          markerId: const MarkerId("1"),
          position: LatLng(data.location!.lat!, data.location!.lng!),
        );
        _marker.add(_list);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: true).user;

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Эрсдэлийн дэлгэрэнгүй",
          style: TextStyle(fontSize: 16, color: dark),
        ),
        actions: [
          data.postStatus == null
              ? const SizedBox()
              : SizedBox(
                  child: user.id != null &&
                          user.id == data.user!.id &&
                          data.postStatus == "NEW"
                      ? PopupMenuButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: dark,
                          ),
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
                              actionPopUpItemSelected(value, data),
                        )
                      : const SizedBox()),
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
                    color: black,
                  ),
                ),
              )
            : data.postStatus == null
                ? const NotFoundPage()
                : Column(
                    children: [
                      Column(
                        children: [
                          data.resultImage != null
                              ? BeforeAfter(
                                  imageCornerRadius: 0,
                                  imageHeight:
                                      MediaQuery.of(context).size.height * 0.45,
                                  imageWidth: MediaQuery.of(context).size.width,
                                  beforeImage:
                                      NetworkImage("${data.getImage()}"),
                                  afterImage:
                                      NetworkImage("${data.resImage()}"),
                                )
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.45,
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
                            height: 15,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                                color: color(),
                                border: Border.all(color: borderColor()),
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Row(
                              children: [
                                icon(),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.sector!.fullName == null
                                                ? "Эрсдэл"
                                                : "Эрсдэл",
                                            style: const TextStyle(
                                                color: black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          postStatus(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 0.5),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image(
                                  image: AssetImage(
                                    'assets/icon/darkhan.png',
                                  ),
                                  height: 50,
                                ),
                                Text(
                                  'Захирагчийн ажлын алба',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (data.postStatus == "PENDING" &&
                          user.sector != null &&
                          data.sector!.id == user.sector!.id)
                        actionButton(),
                      const SizedBox(
                        height: 5,
                      ),
                      card(),
                      data.sector!.id == null
                          ? const SizedBox()
                          : pendingCard(),
                      data.result == null ? const SizedBox() : resultCard(),
                    ],
                  ),
      ),
    );
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
    } else if (isFailed == true) {
      if (fbKey.currentState!.saveAndValidate()) {
        try {
          setState(() {
            loading = true;
          });
          Post save = Post.fromJson(fbKey.currentState!.value);
          save.postStatus = "FAILED";
          await PostApi().addResult(data.id, save);
          print(fbKey.currentState!.value);
          print(save.toJson());
          print(save.postStatus);
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
    } else if (isReturn == true) {
      if (fbKey.currentState!.saveAndValidate()) {
        try {
          setState(() {
            loading = true;
          });
          Post save = Post.fromJson(fbKey.currentState!.value);
          save.isRefused = true;
          await PostApi().assignPost(data.id, save);
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
          style: TextStyle(color: black, fontSize: 12),
        );
      case "PENDING":
        return const Text(
          "Хүлээгдэж байгаа",
          style: TextStyle(color: black, fontSize: 12),
        );
      case "SOLVED":
        return const Text(
          "Шийдэгдсэн",
          style: TextStyle(color: black, fontSize: 12),
        );
      case "FAILED":
        return const Text(
          "Цуцалсан",
          style: TextStyle(color: black, fontSize: 12),
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

  color() {
    switch (data.postStatus) {
      case "NEW":
        return red.withOpacity(0.3);
      case "PENDING":
        return orange.withOpacity(0.3);
      case "SOLVED":
        return green.withOpacity(0.3);
      case "FAILED":
        return grey.withOpacity(0.3);
      default:
    }
  }

  borderColor() {
    switch (data.postStatus) {
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

  mapDialog(ctx) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 500,
                  child: GoogleMap(
                    markers: Set<Marker>.of(_marker),
                    mapType: MapType.hybrid,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(data.location!.lat!, data.location!.lng!),
                      zoom: 17,
                    ),
                    myLocationEnabled: true,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomButton(
                  color: orange,
                  labelText: "Хаах",
                  textColor: white,
                  onClick: () {
                    Navigator.of(context).pop();
                  },
                  width: MediaQuery.of(context).size.width,
                )
              ],
            ),
          );
        });
  }

  actionButton() {
    if (data.sectorUser == user.id) {
      if (isConfirm == false && isFailed == false && isReturn == false) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  onPressed: () {
                    setState(() {
                      isFailed = true;
                    });
                  },
                  child: const Text(
                    "Цуцлах",
                    style: TextStyle(
                      color: white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  onPressed: () {
                    setState(() {
                      isConfirm = true;
                    });
                  },
                  child: const Text(
                    "Шийдвэрлэх",
                    style: TextStyle(
                      color: white,
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
    } else if (data.sectorUser == null && isReturn == false) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () {
                  setState(() {
                    isReturn = true;
                  });
                },
                child: const Text(
                  "Буцаах",
                  style: TextStyle(
                    color: white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                onPressed: () {
                  addAssign(context, data);
                },
                child: const Text(
                  "Хүлээн авах",
                  style: TextStyle(
                    color: white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (isReturn == true) {
      return hasReturn();
    } else {
      return const SizedBox();
    }
  }

  addAssign(ctx, data) async {
    showDialog(
        barrierDismissible: false,
        context: ctx,
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
                  padding: const EdgeInsets.only(top: 150, left: 20, right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'Хүлээн авах',
                        style: TextStyle(
                            color: dark,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Энэ эрсдэлийг та хүлээн авахдаа итгэлтэй байна уу?',
                        textAlign: TextAlign.center,
                      ),
                      ButtonBar(
                        buttonMinWidth: 100,
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          TextButton(
                            child: const Text(
                              "Үгүй",
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
                              "Тийм",
                              style: TextStyle(color: dark),
                            ),
                            onPressed: () async {
                              if (loading == false) {
                                assignButton(ctx, context);
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
                Positioned(
                  top: 25,
                  child: SvgPicture.asset(
                    "assets/file.svg",
                    height: 80,
                  ),
                )
                // Lottie.asset('assets/check.json', height: 120, repeat: true),
              ],
            ),
          );
        });
  }

  assignButton(ctx, context) async {
    setState(() {
      loading = true;
    });
    try {
      await PostApi().assignPost(data.id, Post(sectorUser: user.id));
      await Provider.of<SectorProvider>(ctx, listen: false).sector();
      locator<NavigationService>().pushReplacementNamed(
          routeName: PostDetailPage.routeName,
          arguments: PostDetailPageArguments(id: data.id!));
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  hasConfirm() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: FormBuilder(
        key: fbKey,
        initialValue: const {"resultImage": "", "result": ""},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            visible == false
                ? FormUploadImage(
                    onChange: onChange,
                    user: user,
                    name: "resultImage",
                    hasError: resultImageHasError,
                    fbKey: fbKey,
                    setFieldValue: (value) {
                      fbKey.currentState!.fields["resultImage"]!
                          .didChange(value);
                      setState(() {
                        resultImageHasError = false;
                        visible = true;
                      });
                    },
                  )
                : Stack(
                    children: [
                      SizedBox(
                        height: 0,
                        width: 1,
                        child: FormUploadImage(
                          onChange: onChange,
                          user: user,
                          name: "resultImage",
                          hasError: resultImageHasError,
                          fbKey: fbKey,
                          setFieldValue: (value) {
                            fbKey.currentState!.fields["resultImage"]!
                                .didChange(value);
                            setState(() {
                              resultImageHasError = false;
                              visible = true;
                            });
                          },
                        ),
                      ),
                      Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              data.resImage(),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(80),
                          onTap: () {
                            setState(() {
                              visible = false;
                              data.resultImage = "";
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(80),
                            ),
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.close,
                              color: white,
                            ),
                          ),
                        ),
                      )
                    ],
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
              color: green,
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
      margin: const EdgeInsets.only(top: 10),
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

  hasReturn() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: FormBuilder(
        key: fbKey,
        initialValue: const {"refuse": ""},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: white,
              width: MediaQuery.of(context).size.width,
              child: FormTextField(
                inputType: TextInputType.text,
                name: "refuse",
                autoFocus: true,
                inputAction: TextInputAction.next,
                controller: user.refuseController,
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
                  hintText: "Яагаад буцааж байгаа мэдэгдлээ энд бичнэ",
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
              labelText: "Буцаах",
              color: red,
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

  show(ctx, data) async {
    showDialog(
        barrierDismissible: false,
        context: ctx,
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
                              if (loading == false) {
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
                Positioned(
                  top: 25,
                  child: SvgPicture.asset(
                    "assets/garbage.svg",
                    height: 80,
                  ),
                )
              ],
            ),
          );
        });
  }

  deleteButton(context, data, ctx) async {
    setState(() {
      loading = true;
    });
    try {
      await PostApi().deletePost(data.id);
      await Provider.of<SectorProvider>(ctx, listen: false).sector();
      Navigator.of(context).pop();
      locator<NavigationService>().restorablePopAndPushNamed(
        routeName: HomePage.routeName,
      );
    } catch (e) {
      setState(() {
        loading = false;
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

  onChange(image) async {
    setState(() {
      data.resultImage = image;
    });
  }

  card() {
    return Container(
      margin: const EdgeInsets.only(right: 15, left: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: red, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Эрсдэл",
                    style: TextStyle(fontWeight: FontWeight.bold, color: red),
                  ),
                  Text(
                    data.getPostDate(),
                    style: const TextStyle(
                      color: greyDark,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                data.text.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ))
        ],
      ),
    );
  }

  pendingCard() {
    return Container(
      margin: const EdgeInsets.only(
        right: 15,
        left: 15,
        top: 10,
      ),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: orange, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Хариуцсан:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: orange),
                  ),
                  Text(
                    data.getPostStatusDate(),
                    style: const TextStyle(
                      color: greyDark,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${data.sector!.fullName}-д хуваарилагдсан",
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ))
        ],
      ),
    );
  }

  resultCard() {
    return Container(
        margin: const EdgeInsets.only(
          right: 15,
          left: 15,
          top: 10,
          bottom: 25,
        ),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color(), width: 1),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                data.postStatus == "SOLVED"
                    ? const Text(
                        "Шийдэл",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: green),
                      )
                    : const Text(
                        "Буцаалт",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: greyDark),
                      ),
                Text(
                  data.getReplyDate(),
                  style: const TextStyle(
                    color: greyDark,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    data.result.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
