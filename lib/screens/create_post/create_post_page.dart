import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sos/models/user.dart';
import 'package:sos/provider/sector_provider.dart';
import 'package:sos/screens/home/index.dart';
import 'package:sos/utils/http_request.dart';
import 'package:sos/widgets/colors.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:sos/widgets/custom_button.dart';
import 'package:geolocator/geolocator.dart';
import '../../api/post_api.dart';
import 'package:rxdart/rxdart.dart';
import '../../components/upload_image/form_upload_image.dart';
import '../../main.dart';
import '../../models/post.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../provider/user_provider.dart';
import '../../services/navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  bool visible = false;
  bool isMap = false;
  double lng = 0;
  double lat = 0;
  Offset position = const Offset(0, 0);

  GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(49.468256759865504, 105.96434477716684),
    zoom: 14.4746,
  );

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
                        initialCameraPosition: _kGooglePlex,
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
        // save.lat = position.latitude;
        // save.lng = position.longitude;

        save.lng = lng;
        save.lat = lat;

        await PostApi().createPost(save);
        await Provider.of<SectorProvider>(context, listen: false).sector();

        show(context);
        // Navigator.of(context).restorablePopAndPushNamed((HomePage.routeName));
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
          "Эрсдэл мэдэгдэх",
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
                  children: [
                    CustomButton(
                      onClick: () {
                        mapDialog(context);
                      },
                      width: MediaQuery.of(context).size.width,
                      labelText: "Байршил нэмэх",
                      fontSize: 16,
                      color: dark,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                CustomButton(
                  onClick: () {
                    if (loading == false) {
                      onSubmit();
                    }
                  },
                  width: MediaQuery.of(context).size.width,
                  labelText: "Илгээх",
                  fontSize: 16,
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
