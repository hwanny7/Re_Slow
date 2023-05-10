class Msg {
  String roomId;
  String sender;
  String receiver;
  String message;

  Msg(
      {required this.roomId,
      required this.sender,
      required this.receiver,
      required this.message});
}
