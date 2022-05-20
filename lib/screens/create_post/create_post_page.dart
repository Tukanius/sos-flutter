import 'package:flutter/material.dart';
import 'package:sos/widgets/colors.dart';

import '../../api/post_api.dart';
import '../../models/post.dart';
import '../../widgets/custom_button.dart';

class CreatePostPage extends StatefulWidget {
  static const routeName = "/createpostpage";

  const CreatePostPage({Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  onSubmit() async {
    Post data = Post(
        text: "123", image: "/image/eb478655-6fe6-4391-bdb6-81b65d98ff60.jpeg");
    await PostApi().createPost(data);
  }

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
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
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Энд эрдслийг мэдэгдлээ бичнэ үү."),
                style: const TextStyle(fontSize: 12),
              ),
              CustomButton(
                onClick: () {
                  onSubmit();
                },
                labelText: "Мэдэгдэх",
                color: orange,
                textColor: white,
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
