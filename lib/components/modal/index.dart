import 'package:flutter/material.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:sos/components/add_content/index.dart';
import 'package:sos/components/view_content/index.dart';

import '../../provider/general_provider.dart';

class GeneralModal extends StatefulWidget {
  const GeneralModal({Key? key}) : super(key: key);

  @override
  State<GeneralModal> createState() => _GeneralModalState();
}

class _GeneralModalState extends State<GeneralModal> {
  BottomDrawerController bottomDrawerController = BottomDrawerController();
  String type = "";
  String id = "";
  bool drawerIsOpen = true;

  @override
  Widget build(BuildContext context) {
    bottomDrawerController = Provider.of<GeneralProvider>(context, listen: true)
        .bottomDrawerController;
    type = Provider.of<GeneralProvider>(context, listen: true).bottomDrawerType;
    id = Provider.of<GeneralProvider>(context, listen: true).id;
    return buildBottomDrawer(context, bottomDrawerController);
  }

  Widget buildBottomDrawer(BuildContext context, bottomDrawerController) {
    return BottomDrawer(
      header: Container(),
      headerHeight: 0.0,
      drawerHeight: MediaQuery.of(context).size.height * 0.76,
      color: Colors.white,
      callback: (opened) async => {
        await Provider.of<GeneralProvider>(context, listen: false)
            .closeBottomDrawer(opened)
      },
      controller: bottomDrawerController,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0x4ffd9d9d9), width: 1),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 6,
                  width: 47,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Color(0x4ffd9d9d9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: view(),
          ))
        ],
      ),
    );
  }

  view() {
    if (type == "VIEW") {
      return ViewContent(id: id);
    }
    return AddContent();
  }
}
