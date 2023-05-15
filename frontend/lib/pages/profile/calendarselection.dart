import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/pages/market/order_detail.dart';
import 'package:reslow/services/Market.dart';
import 'package:reslow/utils/navigator.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';

class CalendarSelection extends StatefulWidget {
  final void Function(DateTime startDate, DateTime endDate) onDateRangeSelected;

  CalendarSelection({required this.onDateRangeSelected});

  @override
  _CalendarSelectionState createState() => _CalendarSelectionState();
}

class _CalendarSelectionState extends State<CalendarSelection> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool isLast = false;
  int page = 0;
  int amount = 0;
  List<SettlementList> itemList = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchList(false);
  }

  void fetchData() async {
    Map<String, dynamic> queryParams = {
      "startDate": _startDate.toString().substring(0, 10),
      "endDate": _endDate.toString().substring(0, 10),
    };

    Response response = await getTotalSettlement(queryParams);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = response.data;
      setState(() {
        amount = jsonData["amount"];
      });
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  Future<void> fetchList(bool isInfinite) async {
    if (!isInfinite) {
      page = 0;
      isLast = false;
      fetchData();
    }

    Map<String, dynamic> queryParams = {
      'page': page,
      'size': 4,
      "startDate": _startDate.toString().substring(0, 10),
      'endDate': _endDate.toString().substring(0, 10),
    };

    Response response = await getSettlementList(queryParams);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = response.data["content"];
      print(jsonData);
      if (isInfinite) {
        if (jsonData.isEmpty) {
          isLast = true;
        } else {
          setState(() {
            itemList.addAll(List<SettlementList>.from(
                jsonData.map((itemJson) => SettlementList.fromJson(itemJson))));
          });
        }
      } else {
        setState(() {
          itemList = List<SettlementList>.from(
              jsonData.map((itemJson) => SettlementList.fromJson(itemJson)));
        });
      }
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  void _scrollListener() async {
    if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent * 0.8 &&
        !isLast &&
        !isLoading) {
      isLoading = true;
      page += 1;
      await fetchList(true);
      isLoading = false;
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(start: _startDate, end: _endDate);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2024),
      initialDateRange: initialDateRange,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      fetchList(false);

      widget.onDateRangeSelected(_startDate, _endDate);
    }
  }

  void _filterToday() {
    final today = DateTime.now();
    setState(() {
      _startDate = today;
      _endDate = today;
    });
    fetchList(false);

    widget.onDateRangeSelected(_startDate, _endDate);
  }

  void _filterOneWeek() {
    final today = DateTime.now();
    final oneWeekAgo = today.subtract(Duration(days: 7));
    setState(() {
      _startDate = oneWeekAgo;
      _endDate = today;
    });
    fetchList(false);

    widget.onDateRangeSelected(_startDate, _endDate);
  }

  void _filterOneMonth() {
    final today = DateTime.now();
    final oneMonthAgo = DateTime(today.year, today.month - 1, today.day);
    setState(() {
      _startDate = oneMonthAgo;
      _endDate = today;
    });
    fetchList(false);

    widget.onDateRangeSelected(_startDate, _endDate);
  }

  void _filterOneYear() {
    final today = DateTime.now();
    final oneYearAgo = DateTime(today.year - 1, today.month, today.day);

    setState(() {
      _startDate = oneYearAgo;
      _endDate = today;
    });
    fetchList(false);

    widget.onDateRangeSelected(_startDate, _endDate);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(title: '정산 내역'),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _selectDateRange(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Text(
                            '${_startDate.toString().substring(0, 10)}',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      const Text(
                        '-',
                        style: TextStyle(fontSize: 30.0, color: Colors.black),
                      ),
                      const SizedBox(width: 10.0),
                      GestureDetector(
                        onTap: () => _selectDateRange(context),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Text(
                            '${_endDate.toString().substring(0, 10)}',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // 달력 부분 끝
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _filterToday,
                        child: Text('당일'),
                      ),
                      SizedBox(width: 10), // Add a 10 pixel space
                      ElevatedButton(
                        onPressed: _filterOneWeek,
                        child: Text('1주일'),
                      ),
                      SizedBox(width: 10), // Add a 10 pixel space
                      ElevatedButton(
                        onPressed: _filterOneMonth,
                        child: Text('1개월'),
                      ),
                      SizedBox(width: 10), // Add a 10 pixel space
                      ElevatedButton(
                        onPressed: _filterOneYear,
                        child: Text('1년'),
                      ),
                    ],
                  ),
                  Expanded(
                      child: ListView.builder(
                    controller: _scrollController,
                    itemCount: itemList.length,
                    itemBuilder: (context, idx) {
                      return GestureDetector(
                          onTap: () {
                            leftToRightNavigator(
                                OrderDetail(
                                  orderPk: itemList[idx].orderNo ?? 0,
                                ),
                                context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                                color: Colors.grey[200],
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    Text('주문번호: ${itemList[idx].orderNo}'),
                                    const SizedBox(height: 10),
                                    Text('정산 금액: ${itemList[idx].amount}'),
                                    const SizedBox(height: 35),
                                    Text(itemList[idx].settlementDt ?? ""),
                                  ],
                                )),
                          ));
                    },
                  )),
                ],
              ),
            )));
  }
}
