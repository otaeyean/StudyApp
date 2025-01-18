import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class PeriodSelector extends StatefulWidget {
  final Function(DateTimeRange) onPeriodSelected;
  final DateTimeRange? selectedRange;

  const PeriodSelector({
    Key? key,
    required this.onPeriodSelected,
    this.selectedRange,
  }) : super(key: key);

  @override
  _PeriodSelectorState createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<PeriodSelector> {
  DateTimeRange? selectedRange;

  @override
  void initState() {
    super.initState();
    selectedRange = widget.selectedRange;
    _loadSelectedDateRange(); // 앱 시작 시 날짜 범위 불러오기
  }

  // SharedPreferences에서 날짜 범위를 불러오는 함수
  Future<void> _loadSelectedDateRange() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? startDateStr = prefs.getString('startDate');
    String? endDateStr = prefs.getString('endDate');

    if (startDateStr != null && endDateStr != null) {
      DateTime startDate = DateTime.parse(startDateStr);
      DateTime endDate = DateTime.parse(endDateStr);
      setState(() {
        selectedRange = DateTimeRange(start: startDate, end: endDate);
      });
    }
  }

  // 날짜 범위를 선택하는 함수
  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? selected = await showDateRangePicker(
      context: context,
      initialDateRange: selectedRange,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: Locale('ko'), // 달력 한글화 설정
    );

    if (selected != null) {
      setState(() {
        selectedRange = selected;
        widget.onPeriodSelected(selectedRange!); // 선택된 날짜 범위 전달
      });
      _saveSelectedDateRange(); // 선택된 날짜 범위를 SharedPreferences에 저장
    }
  }

  // 선택된 날짜 범위를 SharedPreferences에 저장하는 함수
  Future<void> _saveSelectedDateRange() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('startDate', selectedRange!.start.toIso8601String());
    prefs.setString('endDate', selectedRange!.end.toIso8601String());
  }

  @override
  Widget build(BuildContext context) {
    String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

    return Container(
      color: Colors.blue[200],
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () => _selectDateRange(context), // 날짜 범위 선택으로 변경
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedRange == null
                  ? '기간을 선택 해주세요!'
                  : '${formatDate(selectedRange!.start)} - ${formatDate(selectedRange!.end)}',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(width: 8),
            Icon(Icons.calendar_today, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
