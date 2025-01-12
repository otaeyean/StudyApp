import 'package:flutter/material.dart';
import 'period_selector.dart';
import 'stats_summary.dart';
import 'date_chart.dart';
import 'subject_chart.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  DateTimeRange? selectedRange;

  void _onPeriodSelected(DateTimeRange range) {
    setState(() {
      selectedRange = range;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.bar_chart_rounded),
            SizedBox(width: 8),
            Text('통계'),
          ],
        ),
        backgroundColor: Colors.blue[200],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PeriodSelector(
              onPeriodSelected: _onPeriodSelected,
              selectedRange: selectedRange,
            ),
            SizedBox(height: 16),
            StatsSummary(),
            SizedBox(height: 16),
            DateChart(),
            SizedBox(height: 16),
            SubjectChart(),
          ],
        ),
      ),
    );
  }
}
