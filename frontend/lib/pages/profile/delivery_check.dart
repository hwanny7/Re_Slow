import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';

class DeliveryCheck extends StatefulWidget {
  final String? tcode;
  final String? tinvoice;
  const DeliveryCheck({Key? key, required this.tcode, required this.tinvoice})
      : super(key: key);

  @override
  _DeliveryCheckState createState() => _DeliveryCheckState();
}

class _DeliveryCheckState extends State<DeliveryCheck> {
  Map<String, dynamic>? data;
  Map<String, String> deliveryCompanies = {
    "04": "CJ대한통운",
    "01": "우체국택배",
    "05": "한진택배",
    "06": "로젠택배",
    "22": "대신택배",
    "23": "경동택배",
    "32": "합동택배",
    "46": "CU편의점택배",
    "24": "GSPostbox택배",
    "16": "한의사랑택배",
    "17": "천일택배",
    "18": "건영택배",
    "53": "농협택배"
  };

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    print(widget.tcode);
    print(widget.tinvoice);

    // Response response = await get(Uri.parse(
    //     'http://info.sweettracker.co.kr/api/v1/trackingInfo?t_code=${widget.tcode}&t_invoice=${widget.tinvoice}&t_key=604N6oIERfVJqXggjzXyJg'));
    // print(response.statusCode);
    // if (response.statusCode == 200) {
    //   setState(() {
    //     data = jsonDecode(response.body);
    //   });
    //   // print(data);
    //   // DeliveryMan deliveryMan = DeliveryMan.fromJson(data);
    //   // print(deliveryMan.trackingDetails);
    // } else if (response.statusCode == 404) {
    //   // If the server did not find the requested resource, throw an error
    //   throw Exception('Not found');
    // } else {
    //   // If the server returned an error status code, throw an error
    //   throw Exception('Failed to load data');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(title: "배송 조회"),
            body: data == null
                ? Center(child: Text("배송 기록이 없습니다."))
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 150,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "운송장번호",
                                ),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  data?["invoiceNo"],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 150,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "택배사",
                                ),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  deliveryCompanies["04"] ?? "택배사 정보가 없습니다.",
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 150,
                                child: Text("시간",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                width: 100,
                                child: Text("현재 위치",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                width: 80,
                                child: Text("배송 상태",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            reverse: true,
                            itemCount: data?["trackingDetails"].length,
                            itemBuilder: (context, index) {
                              final detail = data?["trackingDetails"][index];
                              return Container(
                                  color:
                                      index % 2 == 1 ? Colors.blue[100] : null,
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(detail["timeString"],
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Text(detail["where"],
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Text(detail["kind"],
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ));
                            },
                          ),
                        )
                      ],
                    ))));
  }
}
