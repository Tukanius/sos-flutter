import 'package:flutter/material.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:sos/components/ViewContent/index.dart';

import '../../provider/general_provider.dart';

class GeneralModal extends StatefulWidget {
  GeneralModal({Key? key}) : super(key: key);

  @override
  State<GeneralModal> createState() => _GeneralModalState();
}

class _GeneralModalState extends State<GeneralModal> {
  BottomDrawerController bottomDrawerController = BottomDrawerController();

  @override
  Widget build(BuildContext context) {
    bottomDrawerController =
        Provider.of<GeneralProvider>(context, listen: false)
            .bottomDrawerController;
    return Stack(
      children: [
        buildBottomDrawer(context, bottomDrawerController),
      ],
    );
  }

  Widget buildBottomDrawer(BuildContext context, bottomDrawerController) {
    // BottomDrawerController bottomDrawerController =
    // Provider.of<GeneralProvider>(context, listen: true)
    //     .bottomDrawerController;
    return BottomDrawer(
      /// your customized drawer header.
      header: Container(),

      /// your customized drawer body.
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 6,
                width: 37,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Color(0x4ff707070),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
          Expanded(
              child: SingleChildScrollView(
            child: ViewContent(),
          ))
        ],
      ),
      headerHeight: 0.0,
      drawerHeight: MediaQuery.of(context).size.height * 0.75,
      color: Colors.white,
      controller: bottomDrawerController,
    );
  }
}
