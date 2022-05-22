import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sos/api/general_api.dart';
import '../../../models/user.dart';
import '../../../widgets/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UploadImage extends StatefulWidget {
  final User? user;
  final Function? onChange;
  final bool isIdCard;
  final String? uploadType;

  const UploadImage({
    Key? key,
    this.user,
    this.onChange,
    this.isIdCard = false,
    this.uploadType,
  }) : super(key: key);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
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
      var image = await GeneralApi().upload(file);
      widget.onChange!(image);
      setState(() {
        loading = false;
      });
    }
  }

  changeImage() {
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
            width: 200,
            height: 200,
            child: Stack(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        changeImage();
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
          width: MediaQuery.of(context).size.width,
          height: 170,
          child: Stack(children: [
            Container(
              alignment: Alignment.center,
              child: () {
                if (user!.avatar != null) {
                  return CachedNetworkImage(
                    imageUrl: user.getAvatar(),
                    imageBuilder: (context, imageProvider) => Container(
                      height: 120.0,
                      decoration: BoxDecoration(
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
            InkWell(
              onTap: () {
                changeImage();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0x4ffEBEDF1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/image.png"),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Энд зургаа оруулна.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Хэмжээ: 1MB, Зурагны төрөл: PNG, JPG.",
                      style: TextStyle(color: Color(0x4ff9F9F9F), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            // Center(
            //   child: ElevatedButton(
            //     style: ButtonStyle(),
            //     child: const Icon(
            //       Icons.add_a_photo,
            //       color: dark,
            //       size: 22.0,
            //     ),
            //     onPressed: () {
            //       changeImage();
            //     },
            //   ),
            // ),
            ((() {
              if (loading == true) {
                return Container(
                    height: 150.0,
                    alignment: Alignment.center,
                    child: const SpinKitPulse(
                      color: grey,
                    ));
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
