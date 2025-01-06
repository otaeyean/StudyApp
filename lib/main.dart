import 'package:flutter/material.dart';
import 'pages/home/home_page.dart'; // 홈 화면 import
import 'pages/personal/personal_page.dart'; // 개인 화면 import
import 'pages/group/group_page.dart'; // 그룹 화면 import
import 'pages/board/board_page.dart'; // 게시판 화면 import
import 'pages/stats/stats_page.dart'; // 통계 화면 import

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainPage(), // 메인 페이지
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),    // 홈 화면
    PersonalScreen(), // 개인 화면
    GroupScreen(),    // 그룹 화면
    BoardScreen(),    // 게시판 화면
    StatsScreen(),    // 통계 화면
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
          backgroundColor: Colors.blue[50], // 하단바 배경 색상
        selectedItemColor: Colors.blue, // 선택된 아이템 색상
        unselectedItemColor: Colors.grey, // 선택되지 않은 아이템 색상
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '개인'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: '그룹'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: '게시판'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '통계'),
        ],
      ),
    );
  }


}
