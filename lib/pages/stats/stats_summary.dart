import 'package:flutter/material.dart';

class StatsSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.4; // build 내부에서 context 사용

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatCard('총 누적', '1000분', Colors.blue, cardWidth),
          _buildStatCard('하루 평균', '100분', Colors.green, cardWidth),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, double width) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: width, // 여기에서 cardWidth 사용
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
