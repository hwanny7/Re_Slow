import 'package:flutter/material.dart';
import 'package:reslow/pages/market/create_article.dart';
import 'package:reslow/utils/navigator.dart';
import 'chat/chat.dart';
import 'home/home.dart';
import 'knowhow/knowhow.dart';
import 'market/market.dart';
import 'profile/profile.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> screens = [
    Home(),
    Market(),
    KnowHow(),
    Chat(),
    Profile(),
  ];

  // final PageStorageBucket bucket = PageStorageBucket();

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _pressedPlus() {
    print('시작!');
    switch (_currentIndex) {
      case 0:
        return;
      case 1:
        print('들어옴ㅋ');
        leftToRightNavigator(const CreateArticle(), context);
        return;
      case 2:
        return;
    }
    ;
    //   Navigator.push(
    // context,
    // MaterialPageRoute(
    //   builder: (context) => NotificationPage(),
    // ),
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: const Color(0xff555555),
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          showUnselectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: '홈',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_mall),
              label: '플리마켓',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_florist),
              label: '노하우',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.textsms),
              label: '채팅',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '프로필',
            ),
          ]),
      floatingActionButton:
          _currentIndex == 0 || _currentIndex == 1 || _currentIndex == 2
              ? FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    _pressedPlus();
                  })
              : null,
    ));
  }
}
