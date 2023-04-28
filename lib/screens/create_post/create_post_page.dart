// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sos/models/user.dart';
import 'package:sos/provider/sector_provider.dart';
import 'package:sos/screens/home/index.dart';
import 'package:sos/utils/http_request.dart';
import 'package:sos/widgets/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:sos/widgets/custom_button.dart';
import '../../api/post_api.dart';
import '../../components/upload_image/form_upload_image.dart';
import '../../main.dart';
import '../../models/post.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../provider/user_provider.dart';
import '../../services/navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../widgets/form_textfield.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool visible = false;
  bool isMap = false;
  late double lng;
  late double lat;
  Offset position = const Offset(0, 0);
  bool hasLocation = false;
  bool isLocationError = false;

  GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(49.468256759865504, 105.96434477716684),
    zoom: 14.4746,
  );

  permissionAsk() async {
    try {
      var status = await Permission.location.status;
      if (status.isDenied) {
        debugPrint("=====================DENIED============");
      }
      if (await Permission.location.isRestricted) {
        debugPrint("=====================isRestricted============");
      }
      if (await Permission.location.request().isGranted) {}
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
      ].request();
      debugPrint(statuses[Permission.location].toString());
    } catch (e) {}
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
                      initialCameraPosition: isMap == false
                          ? _kGooglePlex
                          : CameraPosition(
                              target: LatLng(lat, lng),
                              zoom: 14.4746,
                            ),
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
                    isMap = true;
                    isLocationError = false;
                  });
                  Navigator.of(context).pop();
                },
                width: MediaQuery.of(context).size.width,
              )
            ],
          ),
        );
      },
    );
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
                        'Таны оруулсан эрсдэл амжилттай нэмэгдлээ',
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

        await PostApi().createPost(save);
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
          "Захирагчийн ажлын алба",
          style: TextStyle(fontSize: 16, color: dark),
        ),
        centerTitle: true,
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
                visible == false
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
                            visible = true;
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
                visible == true
                    ? Stack(
                        children: [
                          Container(
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
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(80),
                              onTap: () {
                                setState(() {
                                  visible = false;
                                  resultImage = "";
                                  fbKey.currentState!.fields["image"]!
                                      .didChange("");
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    hasLocation == true
                        ? Row(
                            children: [
                              const Expanded(
                                child: CustomButton(
                                  labelText: "Байршил илгээгдсэн",
                                  fontSize: 16,
                                  color: dark,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  mapDialog(context);
                                },
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  child: const Icon(
                                    Icons.edit_location_sharp,
                                    color: white,
                                  ),
                                  decoration: BoxDecoration(
                                      color: dark,
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                              ),
                            ],
                          )
                        : CustomButton(
                            onClick: () async {
                              await permissionAsk();
                              mapDialog(context);
                            },
                            width: MediaQuery.of(context).size.width,
                            labelText: "Байршил нэмэх",
                            fontSize: 16,
                            color: dark,
                          ),
                    if (isLocationError == true)
                      Container(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: const Text(
                          "Байршил оруулна уу",
                          style: TextStyle(color: red, fontSize: 12),
                        ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                CustomButton(
                  onClick: () {
                    if (loading == false) {
                      if (hasLocation == false) {
                        setState(() {
                          isLocationError = true;
                        });
                      }
                      onSubmit();
                    }
                  },
                  width: MediaQuery.of(context).size.width,
                  customWidget: loading == false
                      ? const Text(
                          "Эрсдэл илгээх",
                          style: TextStyle(
                              fontSize: 14,
                              color: white,
                              fontWeight: FontWeight.w600),
                        )
                      : const Center(
                          child: SpinKitCircle(
                            size: 30,
                            color: white,
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
