import 'package:flutter/material.dart';

class GroupSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row를 사용해서 아이콘과 텍스트를 나란히 배치
          Row(
            children: [
              Icon(Icons.group, color:  Colors.amber, size: 24), // 그룹 아이콘
              SizedBox(width: 8), // 아이콘과 텍스트 사이 간격
              Text('내가 가입한 그룹', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 150,
            color: Colors.grey[200], // 임시 공간
            child: Center(
              child: Text('그룹 리스트 공간'),
            ),
          ),
        ],
      ),
    );
  }
}
