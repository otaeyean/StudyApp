import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // JSON 디코딩 사용
import '../Personal/timer_controller.dart'; // TimerController import

class StatsSummary extends StatefulWidget {
  final TimerController timerController; // TimerController 주입

  StatsSummary({required this.timerController});

  @override
  _StatsSummaryState createState() => _StatsSummaryState();
}

class _StatsSummaryState extends State<StatsSummary> {
  int totalMinutes = 0; // 총 누적 시간
  int dayCount = 1; // 일수

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
     print("Loading statistics...");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedData = prefs.getString('timersData');
  print("저장된 데이터 확인: $savedData"); // 로그 추가

  if (savedData != null) {
    Map<String, dynamic> data = jsonDecode(savedData);

    // 총 시간 계산
    totalMinutes = data.values.fold(0, (sum, subjects) {
      Map<String, int> subjectTimes = Map<String, int>.from(subjects);
      return sum + subjectTimes.values.fold(0, (subjectSum, seconds) {
        return subjectSum + (seconds ~/ 60); // 초를 분으로 변환
      });
    });

    // 날짜의 개수 계산
    dayCount = data.keys.length;
  } else {
    print("저장된 데이터가 없습니다."); // 데이터 없을 때의 로그
    totalMinutes = 0;
    dayCount = 1; // 기본값 설정
  }

  // 계산된 결과 출력
  print("총 누적 시간: $totalMinutes 분");
  print("일수: $dayCount");

  setState(() {});
}


  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatCard('총 누적', '$totalMinutes분', Colors.blue, cardWidth),
          _buildStatCard(
            '하루 평균',
            '${(totalMinutes ~/ dayCount)}분',
            Colors.green,
            cardWidth,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, double width) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 20, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
