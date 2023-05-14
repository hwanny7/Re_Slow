import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';

class DeliveryCheck extends StatefulWidget {
  const DeliveryCheck({Key? key}) : super(key: key);

  @override
  _DeliveryCheckState createState() => _DeliveryCheckState();
}

class _DeliveryCheckState extends State<DeliveryCheck> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    Response response = await get(Uri.parse(
        'http://info.sweettracker.co.kr/api/v1/trackingInfo?t_code=04&t_invoice=573241164592&t_key=604N6oIERfVJqXggjzXyJg'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
      // print(data);
      // DeliveryMan deliveryMan = DeliveryMan.fromJson(data);
      // print(deliveryMan.trackingDetails);
    } else if (response.statusCode == 404) {
      // If the server did not find the requested resource, throw an error
      throw Exception('Not found');
    } else {
      // If the server returned an error status code, throw an error
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return data == null
        ? Text("null입니다")
        : SafeArea(
            child: Scaffold(
                appBar: CustomAppBar(title: "배송 조회"),
                body: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 6,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Text 1"),
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Text 2"),
                          ),
                        ),
                      ],
                    ))));
  }
}
