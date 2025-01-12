import 'package:flutter/material.dart';

class SubjectChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder for the chart
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text('과목별 차트 (Placeholder)'),
          ),
        ),
      ),
    );
  }
}
