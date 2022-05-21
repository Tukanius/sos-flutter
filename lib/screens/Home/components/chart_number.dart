import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:sos/models/sector.dart';
import 'package:sos/widgets/colors.dart';
import 'package:skeletons/skeletons.dart';

class ChartNumberCard extends StatefulWidget {
  final Sector? dashboard;
  const ChartNumberCard({
    Key? key,
    this.dashboard,
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
      case "Хянагдаж буй":
        return orange;
      case "Шийдвэрлэгдсэн":
        return const Color(0xff34A853);
      case "Шийдвэрлэгдээгүй":
        return grey;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
