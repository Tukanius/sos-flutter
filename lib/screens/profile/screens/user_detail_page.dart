import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sos/models/user.dart';
import 'package:sos/screens/profile/components/upload_avatar.dart';
import 'package:lottie/lottie.dart';
import 'package:sos/screens/profile/components/user_detail_form.dart';
import '../../../provider/user_provider.dart';
import '../../../widgets/colors.dart';

class UserDetailPage extends StatefulWidget {
  static const routeName = "/userdetailpage";

  const UserDetailPage({Key? key}) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  User user = User();
  bool? isLoading = false;

  onChange(image) async {
    setState(() {
      user.avatar = image;
    });
  }

  show(ctx) async {
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
                  margin: const EdgeInsets.only(top: 75),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.only(top: 90, left: 20, right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'Амжилттай',
                        style: TextStyle(
                            color: dark,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Таны сольсон мэдээлэл амжилттай хадгалагдлаа',
                        textAlign: TextAlign.center,
                      ),
                      ButtonBar(
                        buttonMinWidth: 100,
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          TextButton(
                            child: const Text(
                              "Ойлголоо",
                              style: TextStyle(color: dark),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Lottie.asset('assets/success.json', height: 150, repeat: false),
              ],
            ),
          );
        });
  }

  onSubmit() async {
    final form = user.fbKey.currentState!;
    if (form.saveAndValidate()) {
      user = User.fromJson(form.value);
      try {
        await Provider.of<UserProvider>(context, listen: false).update(user);
        await Provider.of<UserProvider>(context, listen: false).me(true);
        show(context);
      } catch (err) {
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: dark),
        backgroundColor: primaryColor,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          "Миний мэдээлэл",
          style: TextStyle(color: dark, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              UploadAvatar(
                user: user,
                onChange: onChange,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  user.lastName != null
                      ? Text(user.lastName.toString())
                      : const SizedBox(),
                  const SizedBox(
                    width: 5,
                  ),
                  user.firstName != null
                      ? Text(user.firstName.toString())
                      : const SizedBox(),
                ],
              ),
              // user.email == null
              //     ? const SizedBox()
              //     : Text(user.email.toString()),
              const SizedBox(
                height: 20,
              ),
              user.sector == null
                  ? Container()
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: white,
                              image: DecorationImage(
                                  image:
                                      NetworkImage(user.sector!.getAvatar())),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            user.sector!.fullName.toString(),
                            style: const TextStyle(color: dark, fontSize: 16),
                          )
                        ],
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              UserDetailForm(
                user: user,
                onSubmit: onSubmit,
                isLoading: isLoading,
              )
            ],
          ),
        ),
      ),
    );
  }
}
