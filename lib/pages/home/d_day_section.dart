import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷
import 'package:shared_preferences/shared_preferences.dart'; // 데이터 저장

class DDaySection extends StatefulWidget {
  @override
  _DDaySectionState createState() => _DDaySectionState();
}

class _DDaySectionState extends State<DDaySection> {
  String dDayMessage = 'D-Day를 설정해주세요.';
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _loadDDay();
  }

  // D-Day 데이터 불러오기
  Future<void> _loadDDay() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedDate = prefs.getString('dDayDate');
    if (storedDate != null) {
      selectedDate = DateTime.parse(storedDate);
      _updateDDayMessage();
    }
  }

  // D-Day 데이터 저장
  Future<void> _saveDDay() async {
    if (selectedDate != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('dDayDate', selectedDate!.toIso8601String());
    }
  }

  // D-Day 메시지 업데이트
  void _updateDDayMessage() {
    if (selectedDate != null) {
      final difference = selectedDate!.difference(DateTime.now()).inDays;
      final formattedDate = DateFormat('yyyy년 M월 d일').format(selectedDate!);
      setState(() {
        dDayMessage = '$formattedDate까지 ${difference.abs()}일 남았습니다!';
      });
    }
  }

  // 날짜 선택 메서드
  void _selectDate(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
        _updateDDayMessage();
        _saveDDay();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dDayMessage,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text('설정'),
          ),
        ],
      ),
    );
  }
}
