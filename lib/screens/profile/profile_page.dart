import 'package:flutter/material.dart';
import 'package:sos/models/user.dart';
import 'package:sos/provider/user_provider.dart';
import 'package:sos/screens/Splash/index.dart';
import 'package:sos/screens/profile/screens/change_password.dart';
import 'package:sos/screens/profile/screens/my_create_post_page.dart';
import 'package:sos/screens/profile/screens/my_sector_post.dart';
import 'package:sos/screens/profile/screens/user_detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sos/widgets/colors.dart';
import 'package:after_layout/after_layout.dart';
import 'package:provider/provider.dart';
import 'package:sos/widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = "/profilepage";

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AfterLayoutMixin {
  User user = User();
  @override
  void afterFirstLayout(BuildContext context) async {
    await Provider.of<UserProvider>(context, listen: false).me(false);
  }

  logout() async {
    await Provider.of<UserProvider>(context, listen: false).logout();
    Navigator.of(context).pushReplacementNamed(SplashPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: dark),
        backgroundColor: primaryColor,
        elevation: 0.5,
        title: const Text(
          "Profile",
          style: TextStyle(color: dark, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 120,
                width: 120,
                child: user.avatar != null
                    ? CachedNetworkImage(
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
                          height: 120,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, size: 120, color: white),
                      )
                    : const Icon(
                        Icons.account_circle,
                        size: 120.0,
                        color: orange,
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(user.phone.toString()),
              Text(user.role.toString()),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(UserDetailPage.routeName);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Хэрэглэгчийн тохиргоо"),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(ChangePasswordPage.routeName);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Нууц үг солих"),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(MyCreatePostPage.routeName);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Миний илгээсэн эрсдэлүүд"),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
              user.role == "SECTOR"
                  ? GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(MySectorPost.routeName);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Надад хамааралтай"),
                            Icon(Icons.keyboard_arrow_right)
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
              CustomButton(
                width: MediaQuery.of(context).size.width,
                labelText: "Гарах",
                fontSize: 16,
                color: red,
                onClick: () async {
                  logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
