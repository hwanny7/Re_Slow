import 'package:flutter/material.dart';

class MyBottomSheet extends StatefulWidget {
  final Function(String, String) gotDeliveryMan;
  const MyBottomSheet({Key? key, required this.gotDeliveryMan})
      : super(key: key);

  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  String _selectedValue = "04";
  int? _number;
  List<Map<String, String>> deliveryCompanies = [
    {"name": "CJ대한통운", "code": "04"},
    {"name": "우체국택배", "code": "01"},
    {"name": "한진택배", "code": "05"},
    {"name": "로젠택배", "code": "06"},
    {"name": "대신택배", "code": "22"},
    {"name": "경동택배", "code": "23"},
    {"name": "합동택배", "code": "32"},
    {"name": "CU편의점택배", "code": "46"},
    {"name": "GSPostbox택배", "code": "24"},
    {"name": "한의사랑택배", "code": "16"},
    {"name": "천일택배", "code": "17"},
    {"name": "건영택배", "code": "18"},
    {"name": "농협택배", "code": "53"},
  ];

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.5,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  if (_number != null) {
                    widget.gotDeliveryMan(_selectedValue, _number.toString());
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  '완료',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton(
                value: _selectedValue,
                items: deliveryCompanies.map((deliveryCompany) {
                  return DropdownMenuItem(
                    value: deliveryCompany["code"]!,
                    child: Text(deliveryCompany["name"]!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value!;
                  });
                },
              ),
              const SizedBox(height: 10.0),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '운송장 번호',
                ),
                onChanged: (value) {
                  _number = int.tryParse(value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
