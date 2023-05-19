import 'package:flutter/material.dart';

class MySearchBar extends StatefulWidget {
  final void Function(String) searchcallback;

  const MySearchBar({Key? key, required this.searchcallback}) : super(key: key);

  @override
  _MySearchBarState createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      width: MediaQuery.of(context).size.width * 0.92,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        onSubmitted: (value) {
          widget.searchcallback(value);
        },
        decoration: const InputDecoration(
          hintText: '상품을 검색해보세요.',
          border: InputBorder.none,
          icon: Icon(Icons.search),
        ),
      ),
    );
  }
}
