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

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
        key: tabsContainerKey,
        margin: const EdgeInsets.symmetric(
          vertical: 12.0,
        ),
        height: 40,
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
                child: Text('바나나'),
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
    final RenderBox tabsContainer =
        tabsContainerKey.currentContext!.findRenderObject() as RenderBox;
    double screenWidth = tabsContainer.size.width;
    final tabsContainerPosition = tabsContainer.localToGlobal(Offset.zero).dx;
    final tabsContainerOffset = Offset(-tabsContainerPosition, 0);
    print(tabsContainerOffset);

    final RenderBox renderBox =
        containerKey.currentContext!.findRenderObject() as RenderBox;
    double size = renderBox.size.width;
    double position = renderBox.localToGlobal(tabsContainerOffset).dx;

    double offset = (position + size / 2) - screenWidth / 2;

    scrollController.animateTo(offset,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }
}
