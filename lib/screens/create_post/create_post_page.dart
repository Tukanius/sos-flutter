import 'package:flutter/material.dart';
import 'package:sos/models/general.dart';
import 'package:sos/models/user.dart';
import 'package:sos/provider/general_provider.dart';
import 'package:sos/provider/sector_provider.dart';
import 'package:sos/screens/home/index.dart';
import 'package:sos/utils/http_request.dart';
import 'package:sos/widgets/colors.dart';
import 'package:provider/provider.dart';
import '../../api/post_api.dart';
import '../../components/upload_image/form_upload_image.dart';
import '../../models/post.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../provider/user_provider.dart';
import '../../widgets/form_textfield.dart';

class CreatePostPage extends StatefulWidget {
  static const routeName = "/createpostpage";

  const CreatePostPage({Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  String? resultImage;
  User user = User();
  bool imageHasError = false;
  bool loading = false;
  GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();

  onSubmit() async {
    if (fbKey.currentState!.saveAndValidate() &&
        fbKey.currentState!.fields["image"]!.value != "") {
      try {
        setState(() {
          loading = true;
        });
        Post save = Post.fromJson(fbKey.currentState!.value);

        await PostApi().createPost(save);
        await Provider.of<SectorProvider>(context, listen: false).sector();

        Navigator.of(context).restorablePopAndPushNamed((HomePage.routeName));
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
      if (fbKey.currentState!.fields["image"]!.value == "") {
        setState(() {
          imageHasError = true;
        });
      }
    }
  }

  onChange(image) async {
    setState(() {
      resultImage = image;
    });
  }

  getImage() {
    return HttpRequest.s3host + resultImage.toString();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Create post",
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: FormBuilder(
            key: fbKey,
            initialValue: const {"image": "", "text": ""},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                resultImage == null
                    ? FormUploadImage(
                        onChange: onChange,
                        user: user,
                        name: "image",
                        hasError: imageHasError,
                        fbKey: fbKey,
                        setFieldValue: (value) {
                          fbKey.currentState!.fields["image"]!.didChange(value);
                          setState(() {
                            imageHasError = false;
                          });
                        },
                      )
                    : SizedBox(
                        height: 0,
                        width: 1,
                        child: FormUploadImage(
                          onChange: onChange,
                          user: user,
                          name: "image",
                          hasError: imageHasError,
                          fbKey: fbKey,
                          setFieldValue: (value) {
                            fbKey.currentState!.fields["image"]!
                                .didChange(value);
                            setState(() {
                              imageHasError = false;
                            });
                          },
                        ),
                      ),
                resultImage != null
                    ? Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              getImage(),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    imageHasError == true
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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: FormTextField(
                    name: "text",
                    inputType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    maxLines: null,
                    autoFocus: true,
                    decoration: InputDecoration(
                      hintMaxLines: null,
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
                      hintText: "Энд эрсдэлийн мэдээлэлийг оруулна уу.",
                      fillColor: grey.withOpacity(0.2),
                    ),
                    validators: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Заавал оруулна уу')
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (loading == false) {
                      onSubmit();
                    }
                  },
                  child: const Text(
                    "Илгээх",
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
