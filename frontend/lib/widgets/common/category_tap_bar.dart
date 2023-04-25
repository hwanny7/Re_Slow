import 'package:flutter/material.dart';
// import 'package:buttons_tabbar/buttons_tabbar.dart';

class CategoryTapBar extends StatefulWidget {
  const CategoryTapBar({super.key});
  @override
  _CategoryTapBarState createState() => _CategoryTapBarState();
}

class _CategoryTapBarState extends State<CategoryTapBar> {
  final GlobalKey containerKey1 = GlobalKey();
  final GlobalKey containerKey2 = GlobalKey();
  final GlobalKey containerKey3 = GlobalKey();
  final GlobalKey containerKey4 = GlobalKey();
  final GlobalKey containerKey5 = GlobalKey();
  final GlobalKey containerKey6 = GlobalKey();
  final GlobalKey containerKey7 = GlobalKey();

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
        key: containerKey1,
        margin: const EdgeInsets.symmetric(
          vertical: 12.0,
        ),
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 10.0),
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xff555555)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      side:
                          const BorderSide(width: 2, color: Color(0xffE0E0E0)),
                    ),
                  ),
                ),
                child: Text('전체'),
                onPressed: () {
                  _scrollToButton(containerKey1);
                },
              ),
            ),
            Container(
              key: containerKey2,
              margin: const EdgeInsets.only(left: 10.0),
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xff555555)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      side:
                          const BorderSide(width: 2, color: Color(0xffE0E0E0)),
                    ),
                  ),
                ),
                child: Text('의류'),
                onPressed: () {
                  _scrollToButton(containerKey2);
                },
              ),
            ),
            Container(
              key: containerKey3,
              margin: const EdgeInsets.only(left: 10.0),
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xff555555)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      side:
                          const BorderSide(width: 2, color: Color(0xffE0E0E0)),
                    ),
                  ),
                ),
                child: Text('서적'),
                onPressed: () {
                  _scrollToButton(containerKey3);
                },
              ),
            ),
            Container(
              key: containerKey4,
              margin: const EdgeInsets.only(left: 10.0),
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xff555555)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      side:
                          const BorderSide(width: 2, color: Color(0xffE0E0E0)),
                    ),
                  ),
                ),
                child: Text('바나나welkfjelfewfjkefefj'),
                onPressed: () {
                  _scrollToButton(containerKey4);
                },
              ),
            ),
            Container(
              key: containerKey5,
              margin: const EdgeInsets.only(left: 10.0),
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xff555555)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      side:
                          const BorderSide(width: 2, color: Color(0xffE0E0E0)),
                    ),
                  ),
                ),
                child: Text('수영장'),
                onPressed: () {
                  _scrollToButton(containerKey5);
                },
              ),
            ),
            Container(
              key: containerKey6,
              margin: const EdgeInsets.only(left: 10.0),
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xff555555)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      side:
                          const BorderSide(width: 2, color: Color(0xffE0E0E0)),
                    ),
                  ),
                ),
                child: Text('전체'),
                onPressed: () {
                  _scrollToButton(containerKey6);
                },
              ),
            ),
            Container(
              key: containerKey7,
              margin: const EdgeInsets.only(left: 10.0),
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xff555555)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      side:
                          const BorderSide(width: 2, color: Color(0xffE0E0E0)),
                    ),
                  ),
                ),
                child: Text('전체'),
                onPressed: () {
                  _scrollToButton(containerKey7);
                },
              ),
            ),
          ],
        ));
  }

  void _scrollToButton(GlobalKey containerKey) {
    print(containerKey.currentContext);
    // double buttonWidth = 30; // Replace with your button width
    // double buttonOffset = index * buttonWidth;
    final RenderBox renderBox =
        containerKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    print(containerKey.currentContext);

    scrollController.animateTo(offset.dx,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }
}


  // Widget build(BuildContext context) {
  //   return const DefaultTabController(
  //     initialIndex: 1,
  //     length: 2,
  //     child: TabBar(
  //       isScrollable: true,
  //       // indicator: BoxDecoration(
  //       //   color: Colors.green,
  //       //   // borderRadius: BorderRadius
  //       // ),
  //       labelColor: Color.fromARGB(255, 56, 56, 56),
  //       // labelPadding: const EdgeInsets.symmetric(horizontal: 10),
  //       tabs: [
  //         Tab(
  //           icon: Icon(Icons.beach_access_sharp),
  //         ),
  //         Tab(
  //           icon: Icon(Icons.beach_access_sharp),
  //         ),
  //       ],
  //     ),
  //   );

  //   // body: const TabBarView(
  //   //   children: <Widget>[
  //   //     Center(
  //   //       child: Text("It's cloudy here"),
  //   //     ),
  //   //     Center(
  //   //       child: Text("It's rainy here"),
  //   //     ),
  //   //     Center(
  //   //       child: Text("It's sunny here"),
  //   //     ),
  //   //   ],
  //   // );
  // }



  // Widget build(BuildContext context) {
  //   return DefaultTabController(
  //       length: 10,
  //       child: ButtonsTabBar(
  //         // decoration: BoxDecoration(
  //         //   color: Colors.grey[200],
  //         //   borderRadius: BorderRadius.circular(8),
  //         // ),

  //         backgroundColor: Colors.blue[600],
  //         unselectedBackgroundColor: Colors.white,
  //         labelStyle:
  //             TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //         unselectedLabelStyle:
  //             TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold),
  //         borderWidth: 1,
  //         borderColor: const Color(0xffBABCBE),
  //         // unselectedBorderColor: Colors.blue,
  //         tabs: [
  //           Tab(
  //             text: "전체",
  //           ),
  //           Tab(
  //             text: "의류",
  //           ),
  //           Tab(
  //             text: "서적",
  //           ),
  //           Tab(text: "악세서리"),
  //           Tab(text: "가구"),
  //           Tab(text: "transit"),
  //           Tab(icon: Icon(Icons.directions_bike)),
  //           Tab(icon: Icon(Icons.directions_bike)),
  //           Tab(icon: Icon(Icons.directions_bike)),
  //           Tab(icon: Icon(Icons.directions_bike)),
  //         ],
  //       ));
  // }