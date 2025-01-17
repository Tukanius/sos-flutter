import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sos/models/user.dart';
import 'package:sos/provider/sector_provider.dart';
import 'package:sos/screens/home/index.dart';
import 'package:after_layout/after_layout.dart';
import 'package:sos/utils/http_request.dart';
import 'package:sos/widgets/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:sos/widgets/custom_button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../api/post_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../components/upload_image/form_upload_image.dart';
import '../../../main.dart';
import '../../../models/post.dart';
import '../../../models/result.dart';
import '../../../provider/post_provider.dart';
import '../../../provider/user_provider.dart';
import '../../../services/navigation.dart';
import '../../../widgets/form_textfield.dart';

class EditPostPageArguments {
  Post? data;
  EditPostPageArguments({
    this.data,
  });
}

class EditPostPage extends StatefulWidget {
  static const routeName = "/EditPostPage";
  final Post? data;

  const EditPostPage({Key? key, this.data}) : super(key: key);

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> with AfterLayoutMixin {
  String? resultImage;
  User user = User();
  bool imageHasError = false;
  bool loading = false;
  String? image;
  GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();
  bool? visible = false;
  int page = 1;
  double lat = 49.468256759865504;
  double lng = 105.96434477716684;
  final Completer<GoogleMapController> _controller = Completer();
  int limit = 1000;
  bool hasLocation = false;
  CameraPosition? _kGooglePlex;
  Filter filter = Filter();

  @override
  void afterFirstLayout(BuildContext context) {
    _kGooglePlex = CameraPosition(
      target: LatLng(
        widget.data!.location!.lat != 0.0 ? widget.data!.location!.lat! : lat,
        widget.data!.location!.lng != 0.0 ? widget.data!.location!.lng! : lng,
      ),
      zoom: 14.4746,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 500,
                      child: GoogleMap(
                        mapType: MapType.hybrid,
                        initialCameraPosition: _kGooglePlex!,
                        myLocationEnabled: true,
                        onCameraMove: (cameraPosition) => setState(() {
                          lat = cameraPosition.target.latitude;
                          lng = cameraPosition.target.longitude;
                        }),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
                    Positioned.fill(
                      bottom: 20,
                      child: Align(
                        alignment: Alignment.center,
                        child: Lottie.asset(
                          'assets/pin.json',
                          height: 50,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomButton(
                  color: orange,
                  labelText: "Байршил илгээх",
                  textColor: white,
                  onClick: () {
                    setState(() {
                      hasLocation = true;
                    });
                    Navigator.of(context).pop();
                  },
                  width: MediaQuery.of(context).size.width,
                )
              ],
            ),
          );
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
                        'Таны эрсдэл амжилттай засагдлаа',
                        textAlign: TextAlign.center,
                      ),
                      ButtonBar(
                        buttonMinWidth: 100,
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          TextButton(
                            child: const Text(
                              "Үргэлжлүүлэх",
                              style: TextStyle(color: dark),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await Provider.of<PostProvider>(ctx,
                                      listen: false)
                                  .post(page, limit, filter);
                              locator<NavigationService>()
                                  .restorablePopAndPushNamed(
                                routeName: HomePage.routeName,
                              );
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
    if (fbKey.currentState!.saveAndValidate() &&
        fbKey.currentState!.fields["image"]!.value != "") {
      try {
        setState(() {
          loading = true;
        });
        Post save = Post.fromJson(fbKey.currentState!.value);
        if (hasLocation == true) {
          save = Post(
              location: Post(lat: lat, lng: lng),
              image: fbKey.currentState!.value["image"],
              text: fbKey.currentState!.value["text"]);
        }
        save.image = widget.data!.image;
        await PostApi().editPost(widget.data!.id, save);
        await Provider.of<SectorProvider>(context, listen: false).sector();
        show(context);
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
      widget.data!.image = image;
      image = widget.data!.image;
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
          "Эрсдэл засах",
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
            initialValue: const {"text": ""},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                visible == true
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormUploadImage(
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
                                visible = false;
                              });
                            },
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          SizedBox(
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
                                  imageHasError = true;
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
                                  widget.data!.getImage(),
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
                                  fbKey.currentState!.fields["image"]!
                                      .didChange("");
                                  visible = true;
                                  image = null;
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
                    initialValue: widget.data!.text.toString(),
                    maxLenght: 2000,
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
                  height: 25,
                ),
                hasLocation == true
                    ? CustomButton(
                        width: MediaQuery.of(context).size.width,
                        labelText: "Байршил илгээгдсэн",
                        fontSize: 16,
                        color: dark,
                      )
                    : CustomButton(
                        onClick: () async {
                          mapDialog(context);
                        },
                        width: MediaQuery.of(context).size.width,
                        customWidget: const Text(
                          "Байршил засах",
                          style: TextStyle(
                            color: white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        color: dark,
                      ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  onClick: () {
                    if (loading == false) {
                      imageHasError == false ? onSubmit() : {};
                    }
                  },
                  width: MediaQuery.of(context).size.width,
                  customWidget: loading == true
                      ? const Center(
                          child: SpinKitCircle(
                            size: 30,
                            color: white,
                          ),
                        )
                      : const Text(
                          "Эрсдэл илгээх",
                          style: TextStyle(
                            color: white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  color: orange,
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
