import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DateChart extends StatelessWidget {
  final Map<String, int> dateData; // 날짜별 데이터 (초 → 분 단위)

  const DateChart({required this.dateData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<_ChartData> chartData = dateData.entries
        .map((entry) => _ChartData(entry.key, entry.value))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.lightBlue[50], // 겉 배경색 하늘색
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(16.0),
          child: SfCartesianChart(
            backgroundColor: Colors.grey[200], // 그래프 내부 배경을 어두운 흰색
            primaryXAxis: CategoryAxis(
              labelRotation: 0, // X축 레이블을 가로로 표시
              title: AxisTitle(
                text: '날짜',
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold, // 텍스트 두껍게
                  color: Colors.black,
                ),
              ),
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold, // 텍스트 두껍게
                color: Colors.black,
              ),
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(
                text: '누적 시간 (분)',
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold, // 텍스트 두껍게
                  color: Colors.black,
                ),
              ),
              interval: 10, // Y축 간격
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold, // 텍스트 두껍게
                color: Colors.black,
              ),
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              header: '',
              canShowMarker: true,
              format: 'point.x: point.y 분',
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold, // 텍스트 두껍게
                color: Colors.white,
              ),
            ), // 툴팁 활성화
            series: <ChartSeries>[
              LineSeries<_ChartData, String>(
                dataSource: chartData,
                xValueMapper: (_ChartData data, _) => data.date,
                yValueMapper: (_ChartData data, _) => data.minutes,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold, // 텍스트 두껍게
                    color: Colors.black,
                  ),
                ),
                markerSettings: const MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  color: Colors.blue,
                ),
                color: Colors.deepPurple, // 그래프 선 색상 변경
                width: 3,
              ),
            ],
            borderColor: Colors.grey.shade300, // 그래프 테두리 색상
            borderWidth: 1,
          ),
        ),
      ),
    );
  }
}

class _ChartData {
  final String date; // 날짜
  final int minutes; // 분 단위 시간

  _ChartData(this.date, this.minutes);
}
