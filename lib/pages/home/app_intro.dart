import 'package:flutter/material.dart';

class AppIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[50], // 배경 색상 설정
      padding: EdgeInsets.all(16), // 전체 여백 설정
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: [
          Row(
            children: [
              Icon(Icons.computer, size: 40, color: Colors.blue), // 아이콘
              SizedBox(width: 8), // 아이콘과 텍스트 사이 간격
              Text(
                '위드유', // 제목
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8), // 제목과 설명 사이 간격
          Text(
            '친구들과 함께하는 스터디 화상앱!', // 설명
            style: TextStyle(color: Colors.blue, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
