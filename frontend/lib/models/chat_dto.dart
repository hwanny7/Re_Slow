class Msg {
  String roomId;
  int sender;
  String dateTime;
  String message;

  Msg(
      {required this.roomId,
      required this.sender,
      required this.dateTime,
      required this.message});
}
