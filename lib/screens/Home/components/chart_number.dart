import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:sos/models/sector.dart';
import 'package:sos/widgets/colors.dart';

class ChartNumberCard extends StatefulWidget {
  final Sector? dashboard;
  final TabController tabController;
  final Function onChangeTap;
  final ScrollController scrollController;
  const ChartNumberCard({
    Key? key,
    this.dashboard,
    required this.scrollController,
    required this.onChangeTap,
    required this.tabController,
  }) : super(key: key);

  @override
  State<ChartNumberCard> createState() => _ChartNumberCardState();
}

class _ChartNumberCardState extends State<ChartNumberCard>
    with AfterLayoutMixin {
  @override
  void afterFirstLayout(BuildContext context) {}

  color() {
    switch (widget.dashboard!.statusString) {
      case "Хүлээгдэж буй":
        return red;
      case "Хуваарилагдсан":
        return orange;
      case "Шийдвэрлэгдсэн":
        return const Color(0xff34A853);
      case "Цуцалсан":
        return grey;
      default:
    }
  }

  click() {
    switch (widget.dashboard!.statusString) {
      case "Хүлээгдэж буй":
        return widget.tabController.index = 0;
      case "Хуваарилагдсан":
        return widget.tabController.index = 1;
      case "Шийдвэрлэгдсэн":
        return widget.tabController.index = 2;
      case "Цуцалсан":
        return widget.tabController.index = 3;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        click();
        widget.onChangeTap(widget.tabController.index);
        widget.scrollController.animateTo(0.0,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              color: color(),
            ),
            child: Center(
              child: Text(
                widget.dashboard!.total.toString(),
                style: const TextStyle(
                    color: white, fontSize: 25, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.dashboard!.statusString.toString(),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
          )
        ],
      ),
    );
  }
}
