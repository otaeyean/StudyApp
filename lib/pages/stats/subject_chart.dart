import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SubjectChart extends StatelessWidget {
  final Map<String, int> subjectData;

  const SubjectChart({required this.subjectData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<_SubjectChartData> chartData = subjectData.entries
        .map((entry) => _SubjectChartData(entry.key, entry.value))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        color: Colors.amber, // 카드의 배경색
        child: Container(
          height: 350,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.amber, // 테두리 색상
              width: 2, // 테두리 두께
            ),
            color: Colors.blue.shade50, // 차트 전체 배경색
          ),
          child: SfCircularChart(
            title: ChartTitle(
              text: '과목별 시간 분포',
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // 제목 텍스트 색상
              ),
            ),
            legend: Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap,
              position: LegendPosition.bottom, // 범례 위치를 아래로 변경
              textStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black87, // 범례 텍스트 색상
              ),
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              borderColor: Colors.grey.shade600, // 툴팁 테두리 색상
              borderWidth: 1,
              color: Colors.white, // 툴팁 배경색
              textStyle: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold, // 툴팁 텍스트 스타일
              ),
            ),
            series: <CircularSeries<_SubjectChartData, String>>[
              PieSeries<_SubjectChartData, String>(
                dataSource: chartData,
                xValueMapper: (_SubjectChartData data, _) => data.subject,
                yValueMapper: (_SubjectChartData data, _) => data.minutes,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.black, // 데이터 라벨 텍스트 색상
                    fontWeight: FontWeight.bold,
                  ),
                ),
                radius: '70%', // 파이 차트 크기 비율
                explode: true, // 특정 파이 조각 분리
                explodeIndex: 0, // 분리할 파이 조각 인덱스
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubjectChartData {
  final String subject;
  final int minutes;

  _SubjectChartData(this.subject, this.minutes);
}
