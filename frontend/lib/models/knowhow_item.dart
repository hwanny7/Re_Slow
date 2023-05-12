import 'package:reslow/utils/date.dart';

class KnowhowItem {
  final int knowhowNo;
  final String title;
  final String writer;
  final String? profile;
  final List<String> pictureList;
  final int pictureCnt;
  int likeCnt;
  bool like;
  final int commentCnt;

  KnowhowItem({
    required this.knowhowNo,
    required this.title,
    required this.writer,
    required this.profile,
    required this.pictureList,
    required this.pictureCnt,
    required this.likeCnt,
    required this.like,
    required this.commentCnt,
  });

  factory KnowhowItem.fromJson(Map<String, dynamic> responseData) {
    return KnowhowItem(
        knowhowNo: responseData['knowhowNo'],
        pictureCnt: responseData['pictureCnt'],
        title: responseData['title'],
        writer: responseData['writer'],
        profile: responseData['profile'],
        pictureList: responseData['pictureList'],
        likeCnt: responseData['likeCnt'],
        like: responseData['like'],
        commentCnt: responseData['commentCnt']);
  }
}
