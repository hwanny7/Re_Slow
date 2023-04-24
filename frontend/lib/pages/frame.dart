import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '홈',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.call),
                label: '플리마켓',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.camera),
                label: '노하우',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: '채팅',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: '프로필',
                backgroundColor: Colors.green),
          ]),
      floatingActionButton: _currentIndex == 0 ||
              _currentIndex == 1 ||
              _currentIndex == 2
          ? FloatingActionButton(child: const Icon(Icons.add), onPressed: () {})
          : null,
    ));
  }
}
