import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';
import 'package:reslow/models/user.dart';
import 'package:reslow/services/auth_modify.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';

class ShipmentRegister extends StatefulWidget {
  const ShipmentRegister({Key? key}) : super(key: key);

  @override
  _ShipmentRegisterState createState() => _ShipmentRegisterState();
}

class _ShipmentRegisterState extends State<ShipmentRegister> {
  Shipment shipment = Shipment();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    Response response = await getShipmentInfo();
    print(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = response.data;
      setState(() {
        shipment = Shipment.fromJson(jsonData);
      });
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  void submit() async {
    print(shipment.toJson());
    Response response = await registerShipmentInfo(shipment.toJson());
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = response.data;
      // setState(() {
      //   shipment = Shipment.fromJson(jsonData);
      // });
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: "배송지 등록"),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    shipment.recipient = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: '수령인',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    shipment.phoneNumber = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: '연락처',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 265,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      enabled: false,
                      hintText:
                          shipment.zipcode == "" ? '우편번호' : shipment.zipcode,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16.0),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                          vertical: 19.0, horizontal: 11.0),
                    ),
                    side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KpostalView(
                          // useLocalServer: false,
                          // localPort: 8080,
                          // kakaoKey: '{Add your KAKAO DEVELOPERS JS KEY}',
                          callback: (Kpostal result) {
                            setState(() {
                              shipment.zipcode = result.postCode;
                              shipment.address = result.address;
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text('주소 검색'),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: shipment.address == "" ? '주소' : shipment.address,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16.0),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    shipment.addressDetail = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: '상세주소',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 200,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    shipment.memo = value;
                  });
                },
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: '요청사항 (선택사항)',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
          ],
        )),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    submit();
                  },
                  child: const Text('등록하기',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))),
            )));
  }
}
