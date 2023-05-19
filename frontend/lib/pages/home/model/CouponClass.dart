import 'package:flutter/src/widgets/basic.dart';

class Coupon {
  String? src;
  int? key;

  var list;

  Coupon({this.src, this.key});

  Coupon.fromJson(Map<String, dynamic> json) {
    src = json['src'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['src'] = this.src;
    data['key'] = this.key;
    return data;
  }

  map(Builder Function(dynamic item) param0) {}
}
