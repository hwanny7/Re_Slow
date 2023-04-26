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
  final GlobalKey tabsContainerKey = GlobalKey();

  ScrollController? scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController!.dispose();
    super.dispose();
  }

  // final scrollController = ScrollController();

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        key: tabsContainerKey,
        padding: EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(
          top: 12.0,
        ),
        height: 55,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffF4F2F2), width: 2.0)),
        child: ListView(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          children: <Widget>[
            Container(
              key: containerKey1,
              margin: const EdgeInsets.only(left: 10.0),
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xff555555)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      side: BorderSide(
                          width: 2,
                          color: selectedIndex == 0
                              ? const Color(0xff165B40)
                              : const Color(0xffE0E0E0)),
                    ),
                  ),
                ),
                child: Text('전체'),
                onPressed: () {
                  _scrollToButton(containerKey1, 0);
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
                      side: BorderSide(
                          width: 2,
                          color: selectedIndex == 1
                              ? const Color(0xff165B40)
                              : const Color(0xffE0E0E0)),
                    ),
                  ),
                ),
                child: Text('의류'),
                onPressed: () {
                  _scrollToButton(containerKey2, 1);
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
                      side: BorderSide(
                          width: 2,
                          color: selectedIndex == 2
                              ? const Color(0xff165B40)
                              : const Color(0xffE0E0E0)),
                    ),
                  ),
                ),
                child: Text('서적'),
                onPressed: () {
                  _scrollToButton(containerKey3, 2);
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
                      side: BorderSide(
                          width: 2,
                          color: selectedIndex == 3
                              ? const Color(0xff165B40)
                              : const Color(0xffE0E0E0)),
                    ),
                  ),
                ),
                child: Text('바나나'),
                onPressed: () {
                  _scrollToButton(containerKey4, 3);
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
                      side: BorderSide(
                          width: 2,
                          color: selectedIndex == 4
                              ? const Color(0xff165B40)
                              : const Color(0xffE0E0E0)),
                    ),
                  ),
                ),
                child: Text('수영장'),
                onPressed: () {
                  _scrollToButton(containerKey5, 4);
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
                      side: BorderSide(
                          width: 2,
                          color: selectedIndex == 5
                              ? const Color(0xff165B40)
                              : const Color(0xffE0E0E0)),
                    ),
                  ),
                ),
                child: Text('전체'),
                onPressed: () {
                  _scrollToButton(containerKey6, 5);
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
                      side: BorderSide(
                          width: 2,
                          color: selectedIndex == 6
                              ? const Color(0xff165B40)
                              : const Color(0xffE0E0E0)),
                    ),
                  ),
                ),
                child: Text('전체'),
                onPressed: () {
                  _scrollToButton(containerKey7, 6);
                },
              ),
            ),
          ],
        ));
  }

  void _scrollToButton(GlobalKey containerKey, int index) {
    setState(() {
      selectedIndex = index;
    });
    final RenderBox tabsContainer =
        tabsContainerKey.currentContext!.findRenderObject() as RenderBox;
    double screenWidth = tabsContainer.size.width;
    final tabsContainerPosition = tabsContainer.localToGlobal(Offset.zero).dx;
    final tabsContainerOffset = Offset(-tabsContainerPosition, 0);

    final RenderBox renderBox =
        containerKey.currentContext!.findRenderObject() as RenderBox;
    print(RenderBox);
    double size = renderBox.size.width;
    double position = renderBox.localToGlobal(tabsContainerOffset).dx;

    double offset = (position + size / 2) - screenWidth / 2;

    scrollController!.animateTo(offset,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }
}
