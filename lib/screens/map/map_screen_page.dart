import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:after_layout/after_layout.dart';
import 'package:sos/screens/home/screen/post_detail.dart';
import 'package:sos/widgets/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../api/post_api.dart';
import '../../models/result.dart';

class MapScreenPage extends StatefulWidget {
  static const routeName = "/mapscreenpage";

  const MapScreenPage({Key? key}) : super(key: key);

  @override
  State<MapScreenPage> createState() => _MapScreenPageState();
}

class _MapScreenPageState extends State<MapScreenPage> with AfterLayoutMixin {
  final Completer<GoogleMapController> _controller = Completer();
  bool? isLoading = true;
  Result? mapList = Result(count: 0, rows: []);
  int page = 1;
  int limit = 1000;

  final List<Marker> _marker = [];

  @override
  void afterFirstLayout(BuildContext context) async {
    await permissionAsk();
    setState(() {
      isLoading = true;
    });
    await map(page, limit);
    for (var i = 0; i < mapList!.rows!.length; i++) {
      _marker.add(Marker(
        markerId: MarkerId(i.toString()),
        position: LatLng(
            mapList!.rows![i].location.lat, mapList!.rows![i].location.lng),
        icon: BitmapDescriptor.defaultMarker,
        onTap: () {
          Navigator.of(context).pushNamed(
            PostDetailPage.routeName,
            arguments: PostDetailPageArguments(id: mapList!.rows![i].id),
          );
        },
      ));
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<List<dynamic>?> map(int page, int limit) async {
    Filter filter = Filter();
    Offset offset = Offset(limit: limit, page: page);
    Result res = await PostApi()
        .mapList(ResultArguments(filter: filter, offset: offset));
    setState(() {
      mapList = res;
    });
    return res.rows;
  }

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

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(49.468256759865504, 105.96434477716684),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: dark),
        title: const Text(
          "Эрсдэл",
          style: TextStyle(color: dark, fontSize: 16),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            markers: Set<Marker>.of(_marker),
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          if (isLoading == true)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: white.withOpacity(0.7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SpinKitFadingFour(
                    color: Colors.black,
                    size: 50.0,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Эрсдэлийг шалгаж байна"),
                ],
              ),
            )
        ],
      ),
    );
  }
}
