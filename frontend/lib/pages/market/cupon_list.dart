import 'package:flutter/material.dart';

class CuponList extends StatefulWidget {
  const CuponList({Key? key}) : super(key: key);

  @override
  _CuponListState createState() => _CuponListState();
}

class _CuponListState extends State<CuponList> {
  List<String> items = [];

  @override
  void initState() {
    super.initState();
    // Fetch list items when page initializes
    fetchItems();
  }

  void fetchItems() {
    // Fetch list items here
    // Example:
    setState(() {
      items = ['Item 1', 'Item 2', 'Item 3'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            '쿠폰',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          color: Colors.grey[200],
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: 150,
                width: double.infinity,
                child: Text(items[index]),
              );
            },
          ),
        ));
  }
}
