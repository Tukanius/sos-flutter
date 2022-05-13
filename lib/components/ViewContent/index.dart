import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../BeforeAfter/index.dart';

class ViewContent extends StatefulWidget {
  ViewContent({Key? key}) : super(key: key);

  @override
  State<ViewContent> createState() => _ViewContentState();
}

class _ViewContentState extends State<ViewContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/tab/3.svg",
                width: 37,
                height: 37,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Хот тохижилт",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("2022.04.29"),
                      ],
                    ),
                  ),
                  const Text("Шийдвэрлэгдсэн."),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(),
              child: BeforeAfter(
                imageCornerRadius: 20,
                imageHeight: MediaQuery.of(context).size.height * 0.27,
                imageWidth: MediaQuery.of(context).size.width,
                beforeImage: NetworkImage(
                    "https://d5nunyagcicgy.cloudfront.net/external_assets/hero_examples/hair_beach_v391182663/original.jpeg"),
                afterImage: NetworkImage(
                    "https://love-shayari.co/wp-content/uploads/2021/10/sun-rise.jpg"),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        color: Color(0x4ffEBEDF1),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/heart.svg",
                            color: Color(0x4ffA7A7A7),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            "25",
                            style: TextStyle(
                              color: Color(0x4ffA7A7A7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        color: Color(0x4ffEBEDF1),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/location.svg",
                            color: Color(0x4ffA7A7A7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        card(),
        card(),
        card(),
        card(),
        card(),
      ],
    );
  }

  card() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0x4ffF1F1F1), width: 2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(180),
              color: Color(0x4ffEA4335),
            ),
          ),
          SizedBox(width: 7),
          Expanded(
            child: Column(
              children: [
                const Text(
                  "3-9-р байр 3-24-р байр хоёрын хоорондох явган хүний замын эвдрэл",
                  style: TextStyle(fontSize: 12),
                  maxLines: 4,
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Text(
                      "2022.04.15",
                      style: TextStyle(fontSize: 12, color: Color(0x4ffB4B4B4)),
                    ),
                    Container(
                      height: 6,
                      width: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: Color(0x4ff969696),
                      ),
                    ),
                    const Text(
                      "Amartuvshin Enkhbayar",
                      style: TextStyle(fontSize: 12, color: Color(0x4ffB4B4B4)),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
