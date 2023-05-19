// 홈에서 get 되는 쿠폰 정보

class CouponItem {
  final int couponNo;
  final String name;
  final String content;
  final int discountType;
  final int discountAmount;
  final int discountPercent;
  final int minimumOrderAmount;
  final int totalQuantity;
  final String startDate;
  final String endDate;

  CouponItem({
    required this.couponNo,
    required this.name,
    required this.content,
    required this.discountType,
    required this.discountAmount,
    required this.discountPercent,
    required this.minimumOrderAmount,
    required this.totalQuantity,
    required this.startDate,
    required this.endDate,
  });

  factory CouponItem.fromJson(Map<String, dynamic> json) {
    return CouponItem(
      couponNo: json['couponNo'],
      name: json['name'],
      content: json['content'],
      discountType: json['discountType'],
      discountAmount: json['discountAmount'],
      discountPercent: json['discountPercent'],
      minimumOrderAmount: json['minimumOrderAmount'],
      totalQuantity: json['totalQuantity'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }
}

// 쿠폰 다운로드 상세 페이지에서 get 되는 정보

class CouponDetail {
  final int couponNo;
  final String name;
  final String content;
  final int discountType;
  final int discountAmount;
  final int discountPercent;
  final int minimumOrderAmount;
  final int totalQuantity;
  final String startDate;
  final String endDate;

  CouponDetail({
    required this.couponNo,
    required this.name,
    required this.content,
    required this.discountType,
    required this.discountAmount,
    required this.discountPercent,
    required this.minimumOrderAmount,
    required this.totalQuantity,
    required this.startDate,
    required this.endDate,
  });

  factory CouponDetail.fromJson(Map<String, dynamic> json) {
    return CouponDetail(
      couponNo: json['couponNo'],
      name: json['name'],
      content: json['content'],
      discountType: json['discountType'],
      discountAmount: json['discountAmount'],
      discountPercent: json['discountPercent'],
      minimumOrderAmount: json['minimumOrderAmount'],
      totalQuantity: json['totalQuantity'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }
}

class MyCoupons {
  int? couponNo;
  String? name;
  String? content;
  int? discountType;
  int discountAmount;
  int discountPercent;
  int? minimumOrderAmount;
  int? totalQuantity;
  String? startDate;
  String? endDate;
  int? issuedCouponNo;

  MyCoupons(
      {this.couponNo,
      this.issuedCouponNo,
      this.name,
      this.content,
      this.discountType,
      required this.discountAmount,
      required this.discountPercent,
      this.minimumOrderAmount,
      this.totalQuantity,
      this.startDate,
      this.endDate});

  factory MyCoupons.fromJson(Map<String, dynamic> json) {
    return MyCoupons(
      couponNo: json['couponNo'],
      issuedCouponNo: json['issuedCouponNo'],
      name: json['name'],
      content: json['content'],
      discountType: json['discountType'],
      discountAmount: json['discountAmount'],
      discountPercent: json['discountPercent'],
      minimumOrderAmount: json['minimumOrderAmount'],
      totalQuantity: json['totalQuantity'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }
}
