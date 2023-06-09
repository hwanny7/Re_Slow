import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:reslow/models/chat_dto.dart';
// import 'package:reslow/pages/knowhow/knowhowcomment.dart';
// import 'package:reslow/providers/socket_provider.dart';
import 'package:reslow/services/Market.dart';
import 'package:reslow/utils/date.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';
// import 'package:reslow/widgets/common/profile_small.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatDetail extends StatefulWidget {
  final String roomId; // 방 ID
  final String otherPic;
  final String otherNick;
  Function? refresh;

  ChatDetail(
      {Key? key,
      required this.roomId,
      required this.otherNick,
      required this.otherPic,
      this.refresh})
      : super(key: key);
  @override
  _ChatDetailState createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  List<dynamic> content = [];
  final ScrollController _scrollController = ScrollController();
  Dio dio = Dio();
  String chatMsg = "";
  TextEditingController _chatController = TextEditingController();
  // dynamic socketManager = SocketManager();
  StompClient? stompClient;
  int myId = -1;
  Map _product = {};

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    print("initState 시작");
    // TODO: implement initState
    //_requestChatDetail();
    _requestSubscribe();

    connect();
    // socketManager.setInitial(widget.roomId, myId);
    print("소켓 연결 되어있니? ${isConnect()}");
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _requestMyInfo().then((res) {
        Timer(Duration(milliseconds: 300), () {
          _scrollToBottom();
        });
      });
    });
    _requestProductInfo();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    stompClient!.deactivate();
    print("소켓 끊어졌나? ${isConnect()}");
    dioClient.dio.post('/chat/quit/${widget.roomId}');
    _scrollController.dispose();
  }

  // 소켓 연결되어 있는지 확인
  bool isConnect() {
    if (stompClient!.isActive) {
      return true;
    } else {
      return false;
    }
  }

  // 소켓 연결!
  void connect() {
    if (stompClient == null) {
      stompClient = StompClient(
          config: StompConfig.SockJS(
        url: "http://k8b306.p.ssafy.io:8080/ws",
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => print(error.toString()),
      ));
      stompClient!.activate();
    }
  }

  // 연결되면 실행할 함수 여기서 콜백이 메세지 오면 할 행동
  void onConnect(StompFrame frame) {
    stompClient!.subscribe(
        destination: "/sub/chat/room/${widget.roomId}",
        callback: (StompFrame frame) {
          if (frame.body != null) {
            Map<String, dynamic> obj = json.decode(frame.body!);
            print("obj 확인 ${obj}");
            Map<String, dynamic> message = {
              "roomId": obj["roomId"],
              "sender": obj["sender"],
              "dateTime": new DateTime.now().toString(),
              "content": obj["message"]
            };
            setState(() {
              content.insert(0, message);
            });
            print("넣자마자 확인 ${content}");
            Timer(Duration(milliseconds: 300), () {
              _scrollToBottom();
              print("300ms 후에 확인 ${content}");
            });
          }
        });
  }

  // 메세지 보내기
  void sendMessage(String message) async {
    print("sendMessage 시작");
    print(stompClient);
    Map data = {
      "roomId": widget.roomId,
      "sender": myId,
      "message": message,
      "dateTime": new DateTime.now().toString(),
      "senderProfilePic": widget.otherPic,
      "senderNickname": widget.otherNick,
    };
    if (!stompClient!.isActive) {
      stompClient!.activate();
    }
    stompClient!
        .send(destination: "/pub/chat/message", body: json.encode(data));

    Map obj = {
      "id": "kdsjlkghlkaf;l",
      "roomId": data["roomId"],
      "user": data["sender"],
      "content": data["message"],
      "dateTime": data["dateTime"]
    };
    setState(() {
      print("이게 왔어요${obj}");
      content.insert(0, obj);
      widget.refresh;
    });
    print("넣자마자 확인 ${content}");
    Timer(Duration(milliseconds: 300), () {
      _scrollToBottom();
      print("300ms 후에 확인 ${content}");
    });
  }

  Future<void> _requestMyInfo() async {
    try {
      await dioClient.dio.get('/members/info').then((res) {
        setState(() {
          myId = res.data["memberNo"].toInt();
        });

        _requestChatDetail();
      });
    } on DioError catch (e) {
      print('myinfoerror: $e');
    }
  }

  Future<void> _requestProductInfo() async {
    try {
      await dioClient.dio
          .get('/products/${widget.roomId.split("-")[0]}')
          .then((res) {
        setState(() {
          _product = res.data;
        });
        print("뭐가 날아오는 거야${_product}");
        print("사진 있잖아 ${_product["images"][0]}");
      });
    } on DioError catch (e) {
      print('productinfoerror: $e');
    }
  }

  Future<void> _requestSubscribe() async {
    try {
      await dioClient.dio.post('/chat/enter/${widget.roomId}');
      print("구독했음");
    } on DioError catch (e) {
      print('subscribeerror: $e');
    }
  }

  Future<void> _requestChatDetail() async {
    print("chatdetail요청 시작");
    try {
      final token = await _getTokenFromSharedPreferences();
      print("token $token");
      await dio
          .get('http://k8b306.p.ssafy.io:8080/chat/detail/${widget.roomId}',
              options: Options(headers: {
                'Authorization': 'Bearer $token',
              }),
              queryParameters: {
            "page": 0,
            "size": 30,
          }).then(
        (value) {
          setState(() {
            content = value.data["content"];
          });
          print(content);
        },
      );
    } on DioError catch (e) {
      print('chatdetailerror: $e');
    }
  }

  Future<String?> _getTokenFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Widget _chat(int index) {
    if (content[index]["user"] == myId) {
      return Container(
          margin: const EdgeInsets.all(4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                  child: Text(
                      "${DateTime.parse(content[index]["dateTime"]).hour}:${DateTime.parse(content[index]["dateTime"]).minute}")),
              Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffCDE8E8),
                          borderRadius: BorderRadius.circular(4)),
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(12),
                      child: RichText(
                          maxLines: 100,
                          text: TextSpan(
                              text: content[index]["content"],
                              style: const TextStyle(color: Colors.black)))))
            ],
          ));
    } else if (content[index]["user"] != -1) {
      print("타인의 메세지${content}");
      return Container(
          margin: const EdgeInsets.all(4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 50,
                    height: 50,
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/image/spin.gif",
                      image: widget.otherPic,
                      fit: BoxFit.cover,
                    ),
                  )),
              Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffF1F1F1),
                          borderRadius: BorderRadius.circular(4)),
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(12),
                      child: RichText(
                          maxLines: 100,
                          text: TextSpan(
                              text: content[index]["content"],
                              style: const TextStyle(color: Colors.black))))),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                  child: Text(
                      "${DateTime.parse(content[index]["dateTime"]).hour}:${DateTime.parse(content[index]["dateTime"]).minute}")),
            ],
          ));
    }
    return Text("");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(
              title: widget.otherNick,
            ),
            body: Column(children: [
              Row(
                children: [
                  _product["images"] == null
                      ? Image.asset(
                          width: 100, height: 100, "assets/image/spin.gif")
                      : Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/image/spin.gif",
                            image: _product["images"][0] ?? "",
                            fit: BoxFit.cover,
                          ),
                        ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _product["title"] ?? "",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            priceDot(_product["price"] ?? 0),
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ))
                ],
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: const Color(0xffDBDBDB)),
              Expanded(
                  child: Column(
                children: content.isNotEmpty
                    ? [
                        Expanded(
                            child: ListView.builder(
                                controller: _scrollController,
                                itemCount: content.length,
                                itemBuilder: (context, index) {
                                  return _chat(content.length - (index + 1));
                                })),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 1,
                            color: const Color(0xffDBDBDB)),
                      ]
                    : [
                        Expanded(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text("아직 채팅이 없습니다.")]))
                      ],
              )),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.838,
                    child: TextFormField(
                      onTap: () {
                        Timer(Duration(milliseconds: 200), () {
                          _scrollToBottom();
                        });
                      },
                      onChanged: (text) {
                        chatMsg = text;
                      },
                      validator: (value) {
                        if (value == "") {
                          return "내용은 한 글자 이상이어야 합니다.";
                        }
                        return null;
                      },
                      controller: _chatController,
                      decoration: const InputDecoration(
                        hintText: '',
                        labelStyle: TextStyle(color: Color(0xffDBDBDB)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xffDBDBDB)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xffDBDBDB)),
                        ),
                        border: OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                    )),
                Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey.withOpacity(0.4))),
                        height: 75,
                        child: TextButton(
                            onPressed: () async {
                              if (chatMsg != "") {
                                sendMessage(chatMsg);
                              }
                              print("눌리긴 했음");
                              print(chatMsg);
                              // print(socketManager.isConnect());
                              setState(() {
                                chatMsg = "";
                                _chatController.clear();
                              });
                              _requestChatDetail();
                            },
                            child: Text("완료"))))
              ])
            ])));
  }
}
