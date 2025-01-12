import 'package:flutter/material.dart';
import 'app_intro.dart';
import 'd_day_section.dart';
import 'group_section.dart';
import 'goal_section.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('홈', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppIntro(), // 앱 소개 섹션
            DDaySection(), // D-Day 섹션
            GroupSection(), // 내가 가입한 그룹 섹션
            GoalSection(), // 목표 섹션
          ],
        ),
      ),
    );
  }
}
