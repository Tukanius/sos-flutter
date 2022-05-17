import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sos/api/user_api.dart';
import '../../../models/user.dart';
import '../../../widgets/colors.dart';

class UploadAvatar extends StatefulWidget {
  final User? user;
  final Function? onChange;
  final bool isIdCard;
  final String? uploadType;

  const UploadAvatar({
    Key? key,
    this.user,
    this.onChange,
    this.isIdCard = false,
    this.uploadType,
  }) : super(key: key);

  @override
  _UploadAvatarState createState() => _UploadAvatarState();
}

class _UploadAvatarState extends State<UploadAvatar> {
  bool loading = false;

  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
  }

  pickImage(ImageSource imageSource) async {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
    XFile? file = await _picker.pickImage(source: imageSource);
    if (file != null) {
      setState(() {
        loading = true;
      });
      var image = await UserApi().uploadAvatar(file);
      widget.onChange!(image);
      setState(() {
        loading = false;
      });
    }
  }

  changeAvatar() {
    FocusScope.of(context).unfocus();
    showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      builder: (context) {
        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 24.0, top: 8.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (index == 0) {
              return ListTile(
                onTap: () => pickImage(ImageSource.camera),
                title: const Text(
                  'Зураг авах',
                  style: TextStyle(color: Color(0xff232323)),
                ),
                isThreeLine: false,
                dense: false,
                leading: const Icon(
                  Icons.camera_alt,
                  color: Color(0xff232323),
                ),
              );
            }
            return ListTile(
              onTap: () => pickImage(ImageSource.gallery),
              title: const Text('Зургийн цомог',
                  style: TextStyle(color: Color(0xff232323))),
              isThreeLine: false,
              dense: false,
              leading: const Icon(Icons.image, color: Color(0xff232323)),
            );
          },
          separatorBuilder: (context, i) {
            return const Divider();
          },
          itemCount: 2,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = widget.user;

    if (widget.isIdCard == true) {
      return Column(children: [
        Center(
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        changeAvatar();
                      },
                      icon: const Icon(
                        Icons.camera,
                        size: 50,
                        color: neonGreen,
                      )),
                ],
              ),
            ]),
          ),
        ),
      ]);
    }

    return Column(children: [
      Center(
        child: SizedBox(
          width: 150,
          height: 150,
          child: Stack(children: [
            Container(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60.0),
                child: () {
                  if (user!.avatar != null) {
                    return CachedNetworkImage(
                      imageUrl: user.getAvatar(),
                      imageBuilder: (context, imageProvider) => Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        height: 150,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error, size: 150, color: white),
                    );
                  } else {
                    return const Icon(
                      Icons.account_circle,
                      size: 120.0,
                      color: Colors.white,
                    );
                  }
                }(),
              ),
            ),
            Positioned(
              top: 95.0,
              left: 70.0,
              child: RawMaterialButton(
                elevation: 5,
                fillColor: pink,
                child: const Icon(
                  Icons.add_a_photo,
                  color: white,
                  size: 22.0,
                ),
                padding: const EdgeInsets.all(8.0),
                shape: const CircleBorder(),
                onPressed: () {
                  changeAvatar();
                },
              ),
            ),
            ((() {
              if (loading == true) {
                return const SizedBox();
                // Container(
                //     height: 150.0,
                //     alignment: Alignment.center,
                //     child: const SpinKitPulse(
                //       color: grey,
                //     ));
              } else {
                return const Text("");
              }
            }())),
          ]),
        ),
      ),
    ]);
  }
}
