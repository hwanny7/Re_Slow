String formatTimeDifference(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  if (difference < const Duration(minutes: 1)) {
    return '${difference.inSeconds}초 전';
  } else if (difference < const Duration(hours: 1)) {
    return '${difference.inMinutes}분 전';
  } else if (difference < const Duration(days: 1)) {
    return '${difference.inHours}시간 전';
  } else if (difference < const Duration(days: 30)) {
    return '${difference.inDays}일 전';
  } else if (difference < const Duration(days: 365)) {
    int months = difference.inDays ~/ 30;
    return '$months달 전';
  } else {
    int years = difference.inDays ~/ 365;
    return '$years년 전';
  }
}

String priceDot(int? price) {
  String priceString = price.toString();

  String formattedPrice = '';
  int length = priceString.length - 1;
  for (int i = length; i >= 0; i--) {
    formattedPrice += priceString[length - i];

    if (i % 3 == 0 && i > 0) {
      formattedPrice += ',';
    }
  }
  formattedPrice += '원';
  return formattedPrice;
}
