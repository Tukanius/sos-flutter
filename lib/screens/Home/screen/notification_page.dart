import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sos/screens/home/screen/post_detail.dart';
import 'package:sos/widgets/colors.dart';

class NotificationPage extends StatefulWidget {
  static const routeName = "/notificationpage";

  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<String> _tabs = ['One', 'Two', 'Three'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: black,
      ),
      body: DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  elevation: 0.0,
                  backgroundColor: grey2,
                  pinned: true,
                  floating: true,
                  snap: false,
                  toolbarHeight: 250,
                  expandedHeight: 300,
                  excludeHeaderSemantics: false,
                  automaticallyImplyLeading: false,
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    labelColor: black,
                    indicatorColor: orange,
                    automaticIndicatorColorAdjustment: false,
                    tabs: _tabs
                        .map(
                          (String name) => Tab(text: name),
                        )
                        .toList(),
                  ),
                  flexibleSpace: Container(
                    color: white,
                    child: Text("123"),
                  ),
                ),
              ),
              // SliverOverlapAbsorber(
              //   handle:
              //       NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              //   sliver: SliverAppBar(
              //     pinned: true,
              //     floating: true,
              //     snap: false,
              //     excludeHeaderSemantics: false,
              //     automaticallyImplyLeading: false,
              //     forceElevated: innerBoxIsScrolled,
              //     bottom: TabBar(
              //       labelColor: black,
              //       indicatorColor: orange,
              //       automaticIndicatorColorAdjustment: false,
              //       tabs: _tabs
              //           .map(
              //             (String name) => Tab(text: name),
              //           )
              //           .toList(),
              //     ),
              //   ),
              // ),
            ];
          },
          body: TabBarView(
            children: _tabs.map((String name) {
              return SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      key: PageStorageKey<String>(name),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(8.0),
                          sliver: SliverFixedExtentList(
                            itemExtent: 340.0,
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: SvgPicture.asset(
                                          "assets/facebook.svg",
                                          width: 37,
                                          height: 37,
                                        ),
                                        title: Text(
                                            '{widget.data!.user!.firstName}'),
                                        subtitle: Text(
                                          '{type(widget.data)}',
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          // Navigator.of(context).pushNamed(
                                          //     PostDetailPage.routeName,
                                          //     arguments:
                                          //         PostDetailPageArguments(
                                          //             id: widget.data!.id!));
                                        },
                                        child: Image.network(
                                            'https://helpx.adobe.com/content/dam/help/en/photoshop/using/convert-color-image-black-white/jcr_content/main-pars/before_and_after/image-before/Landscape-Color.jpg'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          '{widget.data!.text}',
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {},
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 0.2,
                                                        color: grey)),
                                                height: 55,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/heart.svg",
                                                      ),
                                                      const SizedBox(width: 7),
                                                      Text('123'),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {},
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 0.2,
                                                        color: grey)),
                                                height: 55,
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/location.svg",
                                                    color: Color(0x4ffA7A7A7),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                              childCount: 30,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
