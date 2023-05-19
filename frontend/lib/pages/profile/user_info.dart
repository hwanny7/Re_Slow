import 'package:flutter/material.dart';
import 'package:reslow/pages/profile/account_register.dart';
import 'package:reslow/pages/profile/shipment_register.dart';
import 'package:reslow/utils/navigator.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        title: "내 정보 관리",
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  leftToRightNavigator(const ShipmentRegister(), context);
                },
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Row(children: [
                    Text("배송지 관리",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    Spacer(),
                    Icon(Icons.chevron_right)
                  ]),
                ),
              ),
              InkWell(
                onTap: () {
                  leftToRightNavigator(const AccountRegister(), context);
                },
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Row(children: [
                    Text("계좌 관리",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    Spacer(),
                    Icon(Icons.chevron_right)
                  ]),
                ),
              ),
              const Divider(
                color: Color(0xFFBDBDBD),
                thickness: 0.5,
              ),
            ],
          )),
    ));
  }
}
