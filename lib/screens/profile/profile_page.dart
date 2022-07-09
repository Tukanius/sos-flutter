import 'package:flutter/material.dart';
import 'package:sos/api/user_api.dart';
import 'package:sos/models/user.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sos/provider/user_provider.dart';
import 'package:sos/screens/Splash/index.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sos/utils/http_handler.dart';
import '../../utils/firebase/index.dart';
import '../../widgets/form_textfield.dart';
import 'package:sos/screens/profile/screens/change_password.dart';
import 'package:sos/screens/profile/screens/depending_post.dart';
import 'package:sos/screens/profile/screens/my_create_post_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sos/screens/profile/screens/my_sector_post.dart';
import 'package:sos/screens/profile/screens/saved_post_page.dart';
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
  bool isSubmit = false;
  TextEditingController passwordController = TextEditingController();

  @override
  void afterFirstLayout(BuildContext context) async {
    await Provider.of<UserProvider>(context, listen: false).me(false);
  }

  logout() async {
    await Provider.of<UserProvider>(context, listen: false).logout();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SplashPage()),
        (Route<dynamic> route) => false);
  }

  removeAccount() async {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          height: 230,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Бүртгэл устгах',
                    style: TextStyle(
                      color: dark,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              FormTextField(
                name: "password",
                inputAction: TextInputAction.next,
                obscureText: true,
                controller: passwordController,
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
                  hintText: "Нууц үг",
                  fillColor: white,
                ),
                validators: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Нууц үгээ оруулна уу.')
                ]),
              ),
              const SizedBox(
                height: 15,
              ),
              CustomButton(
                width: double.infinity,
                onClick: () {
                  if (isSubmit == false) {
                    onSubmit();
                  }
                },
                color: red,
                fontSize: 16,
                textColor: white,
                labelText: "Устгах",
              ),
            ],
          ),
        );
      },
    );
  }

  onSubmit() async {
    if (passwordController.value.text != "") {
      try {
        setState(() {
          isSubmit = true;
        });
        await UserApi().removeAccount(User(password: passwordController.text));
        logout();
      } catch (err) {
        setState(() {
          isSubmit = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: true).user;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: dark),
        backgroundColor: primaryColor,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          "Хэрэглэгчийн хэсэг",
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
              const SizedBox(
                height: 5,
              ),
              user.phone != null
                  ? Text(
                      user.phone.toString(),
                    )
                  : const SizedBox(),
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
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/User.svg",
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Text("Миний мэдээлэл"),
                        ],
                      ),
                      const Icon(Icons.keyboard_arrow_right)
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
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/Folder.svg",
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Text("Миний илгээсэн эрсдэлүүд"),
                        ],
                      ),
                      const Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(ChangePasswordPage.routeName,
                      arguments: ChangePasswordPageArguments(type: "CHANGE"));
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
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/Setting.svg",
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Text("Нууц үг солих"),
                        ],
                      ),
                      const Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(SavedPostPage.routeName);
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
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/Love.svg",
                            width: 18,
                            height: 18,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Text("Хадгалсан"),
                        ],
                      ),
                      const Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
              if (user.role == "SECTOR")
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(MySectorPost.routeName);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Image.network(
                                user.sector!.getAvatar(),
                                width: 25,
                                height: 25,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  "${user.sector!.fullName}",
                                  style: const TextStyle(color: dark),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Text(
                              "${user.mySector}",
                              style: const TextStyle(
                                color: white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(Icons.keyboard_arrow_right)
                      ],
                    ),
                  ),
                ),
              if (user.role == "SECTOR")
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(DependingPostPage.routeName);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 2,
                              ),
                              SvgPicture.asset(
                                "assets/Folder.svg",
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Expanded(
                                child: Text(
                                  "Надад хамааралтай",
                                  style: TextStyle(color: dark),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Text(
                              "${user.referToMe}",
                              style: const TextStyle(
                                color: white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(Icons.keyboard_arrow_right)
                      ],
                    ),
                  ),
                ),
              CustomButton(
                width: MediaQuery.of(context).size.width,
                customWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Гарах",
                      style: TextStyle(color: red, fontSize: 16),
                    ),
                  ],
                ),
                color: white,
                onClick: () async {
                  logout();
                },
              ),
              const SizedBox(
                height: 15,
              ),
              CustomButton(
                width: MediaQuery.of(context).size.width,
                customWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Бүртгэл устгах",
                      style: TextStyle(color: red, fontSize: 16),
                    ),
                  ],
                ),
                color: white,
                onClick: () async {
                  removeAccount();
                },
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
