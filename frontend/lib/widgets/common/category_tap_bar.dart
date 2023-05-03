import 'package:flutter/material.dart';
// import 'package:buttons_tabbar/buttons_tabbar.dart';

class CategoryTapBar extends StatefulWidget {
  final void Function(int) callback;
  final int? initNumber;

  const CategoryTapBar({
    required this.callback,
    this.initNumber,
  });

  @override
  _CategoryTapBarState createState() => _CategoryTapBarState();
}

class _CategoryTapBarState extends State<CategoryTapBar> {
  List<GlobalKey> containerKeys = [];
  final GlobalKey tabsContainerKey = GlobalKey();
  ScrollController? scrollController;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    containerKeys = generateContainerKeys();
    selectedIndex = widget.initNumber;
  }

  List<GlobalKey> generateContainerKeys() {
    List<GlobalKey> keys = [];
    for (int i = 0; i < categories.length; i++) {
      keys.add(GlobalKey());
    }
    return keys;
  }

  @override
  void dispose() {
    scrollController!.dispose();
    super.dispose();
  }

  final List<String> categories = [
    '전체',
    '가구/인테리어',
    '여성잡화',
    '여성의류',
    '남성잡화',
    '남성의류',
    '뷰티/미용',
    '반려동물용품',
    '생활용품',
    '기타',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      key: tabsContainerKey,
      padding: const EdgeInsets.all(10.0),
      height: 55,
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffF4F2F2), width: 2.0)),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            key: containerKeys[index],
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
                      color: selectedIndex == index
                          ? const Color(0xff165B40)
                          : const Color(0xffE0E0E0),
                    ),
                  ),
                ),
              ),
              child: Text(categories[index]),
              onPressed: () {
                _scrollToButton(containerKeys[index], index);
                widget.callback(index);
              },
            ),
          );
        },
      ),
    );
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
