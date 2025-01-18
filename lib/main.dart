import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 로케일 관련 패키지 추가
import 'pages/home/home_page.dart';
import 'pages/personal/personal_page.dart';
import 'pages/group/group_page.dart';
import 'pages/board/board_page.dart';
import 'pages/stats/stats_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      title: 'Study App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // 기본 테마 색상
        scaffoldBackgroundColor: Colors.white, // 기본 배경 흰색
      ),
      // 한국어 로케일 설정
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', ''), // 한국어 로케일 추가
        // 다른 로케일을 추가할 수 있음
      ],
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // 각 페이지를 리스트로 관리
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
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // 인덱스 변경
          });
        },
      ),
    );
  }
}

// 하단 네비게이션 바를 별도 위젯으로 분리
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: Colors.blue[50],
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '개인'),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: '그룹'),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: '게시판'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '통계'),
      ],
    );
  }
}
