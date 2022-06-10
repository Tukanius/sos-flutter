import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:sos/api/post_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sos/models/post.dart';
import 'package:sos/models/result.dart';
import 'package:sos/models/user.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:sos/screens/home/index.dart';
import 'package:sos/utils/firebase/index.dart';
import 'package:sos/widgets/colors.dart';
import '../../../main.dart';
import '../../../provider/sector_provider.dart';
import '../../../provider/user_provider.dart';
import '../../../services/navigation.dart';
import '../../../widgets/custom_button.dart';
import '../../profile/screens/my_create_post_page.dart';
import '../screen/edit_post.dart';
import 'package:permission_handler/permission_handler.dart';
import '../screen/post_detail.dart';

class PostCard extends StatefulWidget {
  final Post? data;
  final String? type;

  const PostCard({
    Key? key,
    this.data,
    this.type,
  }) : super(key: key);

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
      return "Цуцалсан";
    default:
  }
}

icon(Post? data) {
  switch (data!.postStatus) {
    case "PENDING":
      return "assets/tab/2.svg";
    case "NEW":
      return "assets/tab/1.svg";
    case "SOLVED":
      return "assets/tab/3.svg";
    case "FAILED":
      return "assets/tab/5.svg";
    default:
  }
}

permissionAsk() async {
  await Permission.location.request();
  // try {
  //   var status = await Permission.location.status;
  //   if (status.isDenied) {
  //     debugPrint("=====================DENIED============");
  //   }
  //   if (await Permission.location.isRestricted) {
  //     debugPrint("=====================isRestricted============");
  //   }
  //   if (await Permission.contacts.request().isGranted) {}
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.location,
  //     Permission.storage,
  //   ].request();
  //   debugPrint(statuses[Permission.location].toString());
  // } catch (e) {}
}

class _PostCardState extends State<PostCard> with AfterLayoutMixin {
  User user = User();
  bool? likeLoading = false;
  bool? isDelete = false;
  bool? isHide = false;
  bool? isLoading = false;
  bool? loading = false;

  int page = 1;
  int limit = 1000;
  Filter filter = Filter();
  final List<Marker> _marker = [];
  late final Marker _list;

  boderColor() {
    switch (widget.data!.postStatus) {
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

  @override
  void afterFirstLayout(BuildContext context) async {
    setState(() {
      loading = true;
    });
    if (widget.data!.location!.lat != null) {
      _list = Marker(
        markerId: const MarkerId("1"),
        position:
            LatLng(widget.data!.location!.lat!, widget.data!.location!.lng!),
      );
      _marker.add(_list);
    }
    setState(() {
      loading = false;
    });
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
                      target: LatLng(widget.data!.location!.lat!,
                          widget.data!.location!.lng!),
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

  show(ctx, data) async {
    showDialog(
        barrierDismissible: false,
        context: context,
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
                              if (isLoading == false) {
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

  reportDialog(ctx, data) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomDialog(
            data: data,
            context: ctx,
          );
        });
  }

  click(context) async {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    locator<NavigationService>().pushReplacementNamed(
      routeName: MyCreatePostPage.routeName,
    );
  }

  deleteButton(context, data, ctx) async {
    setState(() {
      isLoading = true;
    });
    try {
      await PostApi().deletePost(data.id);
      await Provider.of<SectorProvider>(ctx, listen: false).sector();
      Navigator.of(context).pop();
      widget.type == "MYPOST"
          ? click(ctx)
          : locator<NavigationService>().restorablePopAndPushNamed(
              routeName: HomePage.routeName,
            );
    } catch (e) {
      setState(() {
        isLoading = false;
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
    } else if (value == 'hide') {
      if (isHide == false) {
        try {
          setState(() {
            isHide = true;
          });
          reportDialog(context, data);
          // await PostApi().reportPost(
          //     widget.data!.id.toString(), Post(reportType: "IRRELEVANT"));
          setState(() {
            isHide = false;
          });
        } catch (e) {
          dialogService.showErrorDialog("Нэвтрэн үү!");
          setState(() {
            isHide = false;
          });
        }
      }
    }
  }

  Widget get _customWidget => Container(width: 500, height: 250, color: white);

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: false).user;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListTile(
              leading: SvgPicture.asset(
                "${icon(widget.data)}",
                width: 37,
                height: 37,
              ),
              title: const Text('Эрсдэл'),
              subtitle: Text(
                '${type(widget.data)}',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.6), fontSize: 12),
              ),
              trailing: user.id != null
                  ? widget.data!.postStatus == "NEW"
                      ? user.id == widget.data!.user!.id
                          ? PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
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
                                  actionPopUpItemSelected(value, widget.data),
                            )
                          : PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (context) {
                                return [
                                  const PopupMenuItem(
                                    value: 'hide',
                                    child: Text('Мэдэгдэх'),
                                  ),
                                ];
                              },
                              onSelected: (String value) =>
                                  actionPopUpItemSelected(value, widget.data),
                            )
                      : const SizedBox()
                  : const SizedBox(),
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  Navigator.of(context).pushNamed(PostDetailPage.routeName,
                      arguments: PostDetailPageArguments(id: widget.data!.id!));
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: boderColor(),
                    width: 2,
                  )),
                  width: MediaQuery.of(context).size.width,
                  child: ProgressiveImage.custom(
                    placeholderBuilder: (BuildContext context) => _customWidget,
                    thumbnail:
                        NetworkImage('${widget.data!.getThumb()}'), // 64x43
                    image:
                        NetworkImage('${widget.data!.getImage()}'), // 3240x2160
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              width: double.infinity,
              child: Text(
                '${widget.data!.text}',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.6), fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if (user.id == null) {
                        dialogService.showErrorDialogListener("Нэвтрэн үү");
                      } else {
                        setState(() {
                          likeLoading = true;
                        });
                        var res =
                            await PostApi().like(widget.data!.id.toString());
                        setState(() {
                          likeLoading = false;
                          widget.data!.likeCount = res.likeCount;
                          widget.data!.liked = res.liked;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.3, color: grey)),
                      height: 55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          likeLoading == false
                              ? Icon(
                                  Icons.favorite,
                                  color:
                                      widget.data!.liked == true ? red : grey,
                                  size: 25,
                                )
                              : const SpinKitCircle(
                                  size: 25,
                                  color: orange,
                                ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (widget.data!.likeCount != 0)
                            Text("${widget.data!.likeCount}"),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if (widget.data!.isLocated == true) {
                        await permissionAsk();
                        mapDialog(context);
                      } else {
                        dialogService.showErrorDialog(
                            "Энэ эрсдэлд байршил өгөөгүй байна.");
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.3, color: grey)),
                      height: 55,
                      child: Center(
                        child: widget.data!.isLocated == true
                            ? SvgPicture.asset(
                                "assets/location.svg",
                                color: red,
                              )
                            : SvgPicture.asset(
                                "assets/location.svg",
                                color: Color(0x4ffa7a7a7),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomDialog extends StatefulWidget {
  final Post? data;
  final BuildContext? context;
  const CustomDialog({Key? key, this.data, this.context}) : super(key: key);

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
                    } else {
                      await PostApi().reportPost(widget.data!.id.toString(),
                          Post(reportType: "DUPLICATED"));
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
