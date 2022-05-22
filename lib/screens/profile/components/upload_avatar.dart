import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sos/widgets/colors.dart';

import '../../../api/user_api.dart';
import '../../../models/user.dart';

class UploadAvatar extends StatefulWidget {
  final User? user;
  final Function(String?)? onChange;

  const UploadAvatar({
    Key? key,
    this.user,
    this.onChange,
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

      debugPrint("**************UPLOAD url IMAGE*************");
      widget.onChange!(image);

      setState(() {
        loading = false;
      });
    }
  }

  changeAvatar() {
    FocusScope.of(context).unfocus();
    final ThemeData themeData = Theme.of(context);
    // ignore: unused_local_variable
    final TextStyle textStyle =
        TextStyle(color: themeData.colorScheme.secondary);

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
                    return Image.network("${user.getAvatar()}",
                        width: 120.0, height: 120.0, fit: BoxFit.cover);
                  } else {
                    return const Icon(
                      Icons.account_circle,
                      size: 120.0,
                      color: Colors.orange,
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
                fillColor: Colors.orange,
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
