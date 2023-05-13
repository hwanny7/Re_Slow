import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/services/authModify.dart';
import 'package:reslow/utils/shared_preference.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';

class AccountRegister extends StatefulWidget {
  const AccountRegister({Key? key}) : super(key: key);

  @override
  _AccountRegisterState createState() => _AccountRegisterState();
}

class _AccountRegisterState extends State<AccountRegister> {
  String _selectedValue = "01";

  List<Map<String, String>> bankCompanies = [
    {"name": "입금은행을 선택해주세요.", "code": "01"},
    {'name': '한국은행', 'code': '001'},
    {'name': '산업은행', 'code': '002'},
    {'name': '기업은행', 'code': '003'},
    {'name': '국민은행', 'code': '004'},
    {'name': '외환은행', 'code': '005'},
    {'name': '수협은행', 'code': '007'},
    {'name': '수출입은행', 'code': '008'},
    {'name': '농협은행', 'code': '011'},
    {'name': '농협회원조합', 'code': '012'},
    {'name': '우리은행', 'code': '020'},
    {'name': 'SC제일은행', 'code': '023'},
    {'name': '서울은행', 'code': '026'},
    {'name': '한국씨티은행', 'code': '027'},
    {'name': '대구은행', 'code': '031'},
    {'name': '부산은행', 'code': '032'},
    {'name': '광주은행', 'code': '034'},
    {'name': '제주은행', 'code': '035'},
    {'name': '전북은행', 'code': '037'},
    {'name': '경남은행', 'code': '039'},
    {'name': '새마을금고연합회', 'code': '045'},
    {'name': '신협중앙회', 'code': '048'},
    {'name': '상호저축은행', 'code': '050'},
    {'name': '기타외국계은행', 'code': '051'},
    {'name': '모건스탠리은행', 'code': '052'},
    {'name': 'HSBC은행', 'code': '054'},
    {'name': '도이치은행', 'code': '055'},
    {'name': '알비에스피엘씨은행', 'code': '056'},
    {'name': '제이피모간체이스은행', 'code': '057'},
    {'name': '미즈호코퍼레이트은행', 'code': '058'},
    {'name': '미쓰비시도쿄UFJ은행', 'code': '059'},
    {'name': 'BOA', 'code': '060'},
    {'name': '비엔피파리바은행', 'code': '061'},
    {'name': '중국공상은행', 'code': '062'},
    {'name': '중국은행', 'code': '063'},
    {'name': '산림조합', 'code': '064'},
    {'name': '대화은행', 'code': '065'},
    {"name": "우체국", "code": "071"},
    {"name": "신용보증기금", "code": "076"},
    {"name": "기술신용보증기금", "code": "077"},
    {"name": "하나은행", "code": "081"},
    {"name": "신한은행", "code": "088"},
    {"name": "케이뱅크", "code": "089"},
    {"name": "카카오뱅크", "code": "090"},
    {"name": "토스뱅크", "code": "092"},
    {"name": "한국주택금융공사", "code": "093"},
    {"name": "서울보증보험", "code": "094"},
    {"name": "경찰청", "code": "095"},
    {"name": "금융결제원", "code": "099"},
    {"name": "동양종합금융증권", "code": "209"},
    {"name": "현대증권", "code": "218"},
    {"name": "미래에셋증권", "code": "230"},
    {"name": "대우증권", "code": "238"},
    {"name": "삼성증권", "code": "240"},
    {"name": "한국투자증권", "code": "243"},
    {"name": "NH투자증권", "code": "247"},
    {"name": "교보증권", "code": "261"},
    {"name": "하이투자증권", "code": "262"},
    {"name": "에이치엠씨투자증권", "code": "263"},
    {"name": "키움증권", "code": "264"},
    {"name": "이트레이드증권", "code": "265"},
    {"name": "SK증권", "code": "266"},
    {"name": "대신증권", "code": "267"},
    {"name": "솔로몬투자증권", "code": "268"},
    {"name": "한화증권", "code": "269"},
    {"name": "하나대투증권", "code": "270"},
    {"name": "신한금융투자", "code": "278"},
    {"name": "동부증권", "code": "279"},
    {"name": "유진투자증권", "code": "280"},
    {"name": "메리츠증권", "code": "287"},
    {"name": "엔에이치투자증권", "code": "289"},
    {"name": "부국증권", "code": "290"},
  ];

  String name = '';
  String accountNumber = '';
  void submit() async {
    final formData = {
      "accountHolder": name,
      "accountNumber": accountNumber,
      "bank": _selectedValue
    };

    Response response = await accountRegister(formData);
    if (response.statusCode == 200) {
      UserPreferences().setTrueAccount();
      if (context.mounted) Navigator.pop(context);
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(title: "계좌 등록"),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                      "입금·환불 처리를 위해 계좌 정보를 수집, 이용하며 입력하신 정보는 입금·환불 목적으로만 이용됩니다."),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: '예금주를 입력해 주세요',
                    ),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButton(
                      value: _selectedValue,
                      items: bankCompanies.map((bankCompany) {
                        return DropdownMenuItem(
                          value: bankCompany["code"]!,
                          child: Text(bankCompany["name"]!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value!;
                        });
                      },
                    ),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: '계좌번호를 입력해 주세요',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        accountNumber = value;
                      });
                    },
                  )
                ],
              ),
            ),
            bottomNavigationBar: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: SizedBox(
                    height: 50,
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(4),
                      color: (name.isNotEmpty &&
                              accountNumber.isNotEmpty &&
                              _selectedValue != "01")
                          ? const Color(0xFF165B40)
                          : Colors.grey,
                      child: MaterialButton(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: name.isNotEmpty &&
                                  accountNumber.isNotEmpty &&
                                  _selectedValue != "01"
                              ? () {
                                  submit();
                                }
                              : null,
                          child: const Text(
                            "등록하기",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    )))));
  }
}
