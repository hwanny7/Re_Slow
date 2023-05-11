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
    fetchData(0);
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
    if (firstLoading[_controller.index] == true) {
      await fetchData(_controller.index);
    }
    print('여기!');
    // 페이지 + 시키는 거 옮겨야함. 안 그러면 다시 돌아왔을 때 또 실행됨
  }

  void _scrollListener(int scrollIndex) async {
    if (_scrollControllers[scrollIndex].position.pixels >
            _scrollControllers[scrollIndex].position.maxScrollExtent * 0.8 &&
        !isLast[scrollIndex] &&
        !isLoading[scrollIndex]) {
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
    print(queryParams);

    Response response = await getSellItems(queryParams);
    if (firstLoading[tabIndex]) {
      setState(() {
        firstLoading[tabIndex] = false;
      });
    }

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
          tabs: [
            GestureDetector(
              onTap: () => _controller.index = 0,
              child: const Tab(
                text: '결제 완료',
              ),
            ),
            GestureDetector(
              onTap: () => _controller.index = 1,
              child: const Tab(
                text: '배송 준비',
              ),
            ),
            GestureDetector(
              onTap: () => _controller.index = 2,
              child: const Tab(
                text: '배송 중',
              ),
            ),
            GestureDetector(
              onTap: () => _controller.index = 3,
              child: const Tab(
                text: '배송 완료',
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
    if (firstLoading[tabIndex]) {
      return const Center(child: CircularProgressIndicator());
    } else if (data.isEmpty) {
      return const Center(child: Text("데이터가 없습니다."));
    } else {
      return ListView.builder(
        key: Key(tabIndex.toString()),
        // shrinkWrap: true,
        controller: _scrollControllers[tabIndex],
        itemCount: data.length,
        itemBuilder: (context, index) {
          return SellItemInfo(
              key: Key(data[index].orderNo.toString()), item: data[index]);
        },
      );
    }
  }
}
