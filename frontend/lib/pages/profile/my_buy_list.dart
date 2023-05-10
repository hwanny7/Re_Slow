import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/services/Market.dart';
import 'package:reslow/widgets/market/buy_item_info.dart';

class MyBuyList extends StatefulWidget {
  const MyBuyList({Key? key}) : super(key: key);

  @override
  _MyBuyListState createState() => _MyBuyListState();
}

class _MyBuyListState extends State<MyBuyList>
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
    fetchData(0);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTabChanged);
    _controller.dispose();
    for (final controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTabChanged() {
    final int tabNumber = _controller.index;
    if (page[tabNumber] == 0 && isLast[tabNumber] == false) {
      fetchData(tabNumber);
    }
  }

  void _scrollListener(int scrollIndex) async {
    if (!isLast[scrollIndex] &&
        !isLoading[scrollIndex] &&
        _scrollControllers[scrollIndex].position.pixels >
            _scrollControllers[scrollIndex].position.maxScrollExtent * 0.8) {
      isLoading[scrollIndex] = true;
      page[scrollIndex] += 1;
      await fetchData(scrollIndex);
      isLoading[scrollIndex] = false;
    }
  }

  Future<void> fetchData(int tabIndex) async {
    Map<String, dynamic> queryParams = {
      'page': page[tabIndex],
      'size': 4,
      'status': tabIndex + 1,
    };

    Response response = await getBuyItems(queryParams);
    if (page[tabIndex] == 0) {
      setState(() {
        firstLoading[tabIndex] = false;
      });
    }
    print(response);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = response.data['content'];
      if (jsonData.isEmpty) {
        isLast[tabIndex] = true;
      } else {
        setState(() {
          _data[tabIndex].addAll(List<MyBuyItem>.from(
              jsonData.map((itemJson) => MyBuyItem.fromJson(itemJson))));
          // 높이를 처음으로 변경하기
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
        title: Text('주문내역'),
        bottom: TabBar(
          controller: _controller,
          tabs: const [
            Tab(text: '결제 완료'),
            Tab(text: '배송 준비'),
            Tab(text: '배송 중'),
            Tab(text: '배송 완료'),
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
    if (firstLoading[tabIndex]) {
      return const Center(child: CircularProgressIndicator());
    } else if (data.isEmpty) {
      return const Center(child: Text("데이터가 없습니다."));
    } else {
      return ListView.builder(
        shrinkWrap: true,
        controller: _scrollControllers[tabIndex],
        itemCount: data.length,
        itemBuilder: (context, index) {
          return BuyItemInfo(
              key: Key(data[index].orderNo.toString()), item: data[index]);
        },
      );
    }
  }
}
