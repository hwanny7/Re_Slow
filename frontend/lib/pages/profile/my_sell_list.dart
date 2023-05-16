import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/services/Market.dart';
import 'package:reslow/widgets/market/buy_item_info.dart';
import 'package:reslow/widgets/market/sell_item_info.dart';

class MySellList extends StatefulWidget {
  const MySellList({Key? key}) : super(key: key);

  @override
  _MySellListState createState() => _MySellListState();
}

class _MySellListState extends State<MySellList>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  List<bool> isLoading = [false, false, false, false];
  List<bool> isLast = [false, false, false, false];
  List<int> page = [0, 0, 0, 0];
  List<bool> firstLoading = [true, true, true, true];

  final List<List<MyBuyItem>> _data = [
    [],
    [],
    [],
    [],
  ];

  final List<ScrollController> _scrollControllers = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
    _controller.addListener(_onTabChanged);
    for (int i = 0; i < _scrollControllers.length; i++) {
      final scrollController = _scrollControllers[i];
      scrollController.addListener(() => _scrollListener(i));
    }
    fetchData(0, false);
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller.removeListener(_onTabChanged);
    for (final controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTabChanged() async {
    await fetchData(_controller.index, false);
  }

  void _scrollListener(int scrollIndex) async {
    if (_scrollControllers[scrollIndex].position.pixels >
            _scrollControllers[scrollIndex].position.maxScrollExtent * 0.8 &&
        !isLast[scrollIndex] &&
        !isLoading[scrollIndex]) {
      isLoading[scrollIndex] = true;
      page[scrollIndex] += 1;
      await fetchData(scrollIndex, true);
      isLoading[scrollIndex] = false;
    }
  }

  Future<void> fetchData(int tabIndex, bool isInfinite) async {
    if (!isInfinite) {
      page[tabIndex] = 0;
      isLast[tabIndex] = false;
    }
    Map<String, dynamic> queryParams = {
      'page': page[tabIndex],
      'size': 4,
      'status': tabIndex + 1,
    };

    Response response = await getSellItems(queryParams);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = response.data['content'];

      if (isInfinite) {
        if (jsonData.isEmpty) {
          isLast[tabIndex] = true;
        } else {
          setState(() {
            _data[tabIndex].addAll(List<MyBuyItem>.from(
                jsonData.map((itemJson) => MyBuyItem.fromJson(itemJson))));
          });
        }
      } else {
        setState(() {
          _data[tabIndex] = List<MyBuyItem>.from(
              jsonData.map((itemJson) => MyBuyItem.fromJson(itemJson)));
          firstLoading[tabIndex] = false;
        });
      }
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          '주문내역',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _controller,
          tabs: [
            GestureDetector(
              onTap: () => _controller.index = 0,
              child: const Tab(
                child: Text(
                  '주문 대기',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black), // Set the desired text color
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _controller.index = 1,
              child: const Tab(
                child: Text(
                  '배송 준비',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black), // Set the desired text color
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _controller.index = 2,
              child: const Tab(
                child: Text(
                  '배송 중',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black), // Set the desired text color
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _controller.index = 3,
              child: const Tab(
                child: Text(
                  '배송 완료',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black), // Set the desired text color
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          _buildTab(0),
          _buildTab(1),
          _buildTab(2),
          _buildTab(3),
        ],
      ),
    );
  }

  Widget _buildTab(int tabIndex) {
    final data = _data[tabIndex];

    void removeItem(int index, String choice) {
      setState(() {
        data.removeAt(index);
      });
    }

    if (firstLoading[tabIndex]) {
      return const Center(child: CircularProgressIndicator());
    } else if (data.isEmpty) {
      return const Center(child: Text("내역이 존재하지 않습니다."));
    } else {
      return RefreshIndicator(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView.builder(
              key: Key(tabIndex.toString()),
              // shrinkWrap: true,
              controller: _scrollControllers[tabIndex],
              itemCount: data.length,
              itemBuilder: (context, index) {
                return SellItemInfo(
                    removeItem: removeItem,
                    key: Key(data[index].orderNo.toString()),
                    item: data[index],
                    index: index);
              },
            ),
          ),
          onRefresh: () async {
            await fetchData(tabIndex, false);
          });
    }
  }
}
