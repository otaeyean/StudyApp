import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 형식을 다루기 위한 패키지

//기간 선택하는 페이지
class PeriodSelector extends StatelessWidget {
  final Function(DateTimeRange) onPeriodSelected;
  final DateTimeRange? selectedRange;

  PeriodSelector({required this.onPeriodSelected, this.selectedRange});

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: selectedRange,
      builder: (BuildContext context, Widget? child) {
        // 다이얼로그 스타일
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // 헤더 배경색
              onPrimary: Colors.white, // 헤더 텍스트 색상
              onSurface: Colors.black, // 일반 텍스트 색상
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // 버튼 텍스트 색상
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (result != null) {
      onPeriodSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 날짜 형식을 위한 formatter
    String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

    return Container(
      color: Colors.blue[200],
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () => _selectDateRange(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
          children: [
            Text(
              selectedRange == null
                  ? '기간을 선택 해주세요!'
                  : '${formatDate(selectedRange!.start)} - ${formatDate(selectedRange!.end)}',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(width: 8), // 텍스트와 아이콘 간격
            Icon(Icons.calendar_today, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
