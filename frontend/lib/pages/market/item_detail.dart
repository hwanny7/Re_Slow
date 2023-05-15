import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/models/user.dart';
import 'package:reslow/pages/chat/chatdetail.dart';
import 'package:reslow/pages/market/buy_item.dart';
import 'package:reslow/pages/profile/account_register.dart';
import 'package:reslow/utils/date.dart';
import 'package:reslow/utils/dio_client.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:reslow/utils/navigator.dart';
import 'package:reslow/utils/shared_preference.dart';

class ItemDetail extends StatefulWidget {
  final int itemPk;

  ItemDetail({required this.itemPk});

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  final DioClient dioClient = DioClient();
  MarketItemDetail? item;
  bool isLiked = false;
  final PageController _pageController = PageController();
  int _currentPicture = 0;
  String price = '';
  dynamic myinfo;
  bool isRoomId = false;
  String roomId = "";

  @override
  void initState() {
    super.initState();
    fetchItemDetail(widget.itemPk);
  }

  void fetchItemDetail(int itemPk) async {
    Response response = await dioClient.dio.get('/products/$itemPk');

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = response.data;
      jsonData['productNo'] = widget.itemPk;
      print(jsonData);

      setState(() {
        item = MarketItemDetail.fromJson(jsonData);
        print(item!.memberNo);
        price = priceDot(item!.price);
      });
    } else {
      // Handle any errors or display an error message
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  void changeHeart(bool status) async {
    if (status) {
      Response response =
          await dioClient.dio.delete('/products/${widget.itemPk}/like');
      if (response.statusCode == 200) {
        setState(() {
          item!.myHeart = false;
          item!.heartCount -= 1;
        });
      } else {
        // Handle any errors or display an error message
        print('HTTP request failed with status: ${response.statusCode}');
      }
    } else {
      Response response =
          await dioClient.dio.post('/products/${widget.itemPk}/like');
      if (response.statusCode == 200) {
        setState(() {
          item!.myHeart = true;
          item!.heartCount += 1;
        });
      } else {
        // Handle any errors or display an error message
        print('HTTP request failed with status: ${response.statusCode}');
      }
    }
  }

  Future<void> _requestMyInfo() async {
    try {
      await dioClient.dio.get('/members/info').then((res) {
        setState(() {
          myinfo = res.data;
        });
        print("정보 내놔 $myinfo");
      });
    } on DioError catch (e) {
      print('requestMyInfoerror: $e');
    }
  }

  Future<void> _requestCheckRoomId(String roomId) async {
    try {
      await dioClient.dio.get('/chat/check/$roomId').then((res) {
        setState(() {
          isRoomId = res.data["room"];
        });
      });
    } on DioError catch (e) {
      print('requestCheckRoomIderror: $e');
    }
  }

  Future<void> _requestCreateRoom(String roomId) async {
    try {
      Map data;
      if (myinfo["memberNo"] < item!.memberNo) {
        data = {"user1": myinfo["memberNo"], "user2": item!.memberNo};
      } else {
        data = {"user2": myinfo["memberNo"], "user1": item!.memberNo};
      }
      print(data);
      print(myinfo["memberNo"]);
      print(item!.memberNo);
      await dioClient.dio.post('/chat/$roomId', data: data);
    } on DioError catch (e) {
      print('requestCreateRoomerror: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FutureBuilder<User>(
            future: UserPreferences().getUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return item == null
                    ? const Center(child: CircularProgressIndicator())
                    : Scaffold(
                        appBar: AppBar(
                            backgroundColor: Colors.black.withOpacity(0.8)),
                        bottomNavigationBar: BottomAppBar(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Color(
                                      0xFFBDBDBD), // Set the top border color
                                  width: 0.5, // Set the top border thickness
                                ),
                              ),
                            ),
                            height: 60.0,
                            child: Row(children: [
                              Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Color(
                                          0xFFBDBDBD), // Set the top border color
                                      width:
                                          0.5, // Set the top border thickness
                                    ),
                                  ),
                                ),
                                height: 60.0,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: item!.myHeart
                                        ? Colors.red
                                        : Colors
                                            .grey, // Change color based on condition
                                  ),
                                  onPressed: () {
                                    changeHeart(item!.myHeart);
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              Text(
                                price,
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              if (snapshot.data?.nickname !=
                                  item!.nickname) ...[
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: MaterialButton(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 12, 12, 12),
                                      color: const Color(0xFF165B40),
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      onPressed: () {
                                        Future<bool> result =
                                            UserPreferences().getExistAccount();
                                        result.then((res) {
                                          if (res) {
                                            leftToRightNavigator(
                                                BuyItem(item: item), context);
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('계좌 등록 안내'),
                                                  content: const Text(
                                                      '계좌 등록이 필요한 서비스입니다. 거래 관련 입금·환불 처리를 위해 계좌를 등록해주세요'),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        10),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                leftToRightNavigator(
                                                                    const AccountRegister(),
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                '등록하기',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      22, // Set the font size to 24
                                                                  color: Colors
                                                                      .blue, // Set the font color to blue
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold, // Make the text bold
                                                                ),
                                                              ),
                                                            )),
                                                      ],
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        });
                                      },
                                      child: const Text(
                                        "구매",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: MaterialButton(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 12, 12, 12),
                                      color: const Color(0xFF165B40),
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      onPressed: () async {
                                        print("눌림");
                                        // 내 번호랑 닉네임 받아오기
                                        await _requestMyInfo();
                                        print("내 번호랑 닉네임 받아옴");
                                        print(myinfo);
                                        // /productNo/usernumber/othernumber(작은 숫자를 앞으로)라는 방 이름이 있나요?
                                        if (myinfo != null) {
                                          if (myinfo["memberNo"] <
                                              item!.memberNo) {
                                            roomId =
                                                "${item!.productNo}-${myinfo["memberNo"]}-${item!.memberNo}";
                                          } else {
                                            roomId =
                                                "${item!.productNo}-${item!.memberNo}-${myinfo["memberNo"]}";
                                          }
                                          await _requestCheckRoomId(roomId);
                                          print("방 아이디가 있나요? $isRoomId");
                                          if (isRoomId) {
                                            print("chatDetail 넘어갑니다");
                                            // 방 ID 있다면 그냥 push
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatDetail(
                                                  roomId: roomId,
                                                  otherNick: item!.nickname,
                                                  otherPic: item!.profileImg,
                                                ),
                                              ),
                                            );
                                          } else {
                                            print("방 생성 API 시작");
                                            // 없다면 방 생성 API 보낸 후 push
                                            await _requestCreateRoom(roomId);
                                            print("방 생성 후, chatDetail 넘어갑니다");
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatDetail(
                                                  roomId: roomId,
                                                  otherNick: item!.nickname,
                                                  otherPic: item!.profileImg,
                                                ),
                                              ),
                                            );
                                          }
                                        } else {
                                          print(myinfo);
                                        }
                                      },
                                      child: const Text(
                                        "채팅",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                              ]
                            ]),
                          ),
                        ),
                        body: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 300,
                                      child: PageView.builder(
                                        controller: _pageController,
                                        onPageChanged: (index) {
                                          setState(() {
                                            _currentPicture = index;
                                          });
                                        },
                                        itemCount: item!.images.length,
                                        itemBuilder: (context, index) {
                                          return Image.network(
                                            item!.images[index],
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 20,
                                        left: 0,
                                        right: 0,
                                        child: DotsIndicator(
                                          dotsCount: item!.images.length,
                                          position: _currentPicture.toDouble(),
                                          decorator: DotsDecorator(
                                            color: Colors
                                                .grey, // Color of the dots
                                            activeColor: Colors
                                                .blue, // Color of the active dot
                                            size: const Size.square(
                                                9.0), // Size of the dots
                                            activeSize: const Size(18.0,
                                                9.0), // Size of the active dot
                                            spacing: EdgeInsets.all(
                                                4.0), // Spacing between dots
                                            activeShape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  5.0), // Shape of the active dot
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                      item!.profileImg,
                                    ),
                                  ),
                                  title: Text(
                                    item!.nickname,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Divider(
                                  color: Color(0xFFBDBDBD),
                                  thickness: 0.5,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Text(
                                          item!.title,
                                          style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(item!.date),
                                      ]),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        item!.description,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('관심 ${item!.heartCount}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                              ]),
                        ));
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return const SafeArea(
                    child: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ));
              }
            }));
  }
}
