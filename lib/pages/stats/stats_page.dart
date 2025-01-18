import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'period_selector.dart';
import 'stats_summary.dart';
import '../Personal/timer_controller.dart'; // TimerController import
import 'date_chart.dart'; // 날짜별 그래프

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  DateTimeRange? selectedRange;
  TimerController? timerController;
  Map<String, int> originalData = {}; // 원본 데이터
  Map<String, int> filteredData = {}; // 필터링된 데이터
  Map<String, int> subjectData = {}; // 과목별 데이터
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeTimerController();
  }

  Future<void> _initializeTimerController() async {
    TimerController controller = TimerController();
    await controller.loadTimers();
    setState(() {
      timerController = controller;
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final timersData = await timerController!.getTimersData();
      print('Timers Data Loaded: $timersData'); // 디버깅용 출력

      final parsedData = timersData.map((date, subjects) {
        final totalSeconds = subjects.values.fold(0, (sum, seconds) => sum + seconds);
        return MapEntry(date, totalSeconds ~/ 60); // 초 → 분 변환
      });

      setState(() {
        originalData = parsedData; // 원본 데이터를 저장
        filteredData = Map.from(originalData); // 초기에는 원본 데이터 전체를 사용
        subjectData = _calculateSubjectData(timersData); // 과목별 데이터 계산
      });

      print('Parsed Data: $originalData'); // 디버깅용 출력
      print('Subject Data: $subjectData'); // 디버깅용 출력
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Map<String, int> _calculateSubjectData(Map<String, Map<String, int>> timersData) {
    final subjectTotals = <String, int>{};

    for (final subjects in timersData.values) {
      subjects.forEach((subject, seconds) {
        subjectTotals[subject] = (subjectTotals[subject] ?? 0) + (seconds ~/ 60);
      });
    }

    return subjectTotals;
  }

  void _onPeriodSelected(DateTimeRange range) {
    setState(() {
      selectedRange = range;

      print('Applying Date Filter');
      print('Original Data: $originalData'); // 원본 데이터 확인
      print('Selected Range: ${range.start} - ${range.end}');

      // 날짜 범위 필터링
      final filtered = originalData.entries
          .where((entry) {
            final date = DateTime.parse(entry.key);
            final onlyDate = DateTime(date.year, date.month, date.day); // 시간 제거
            final startDate = DateTime(range.start.year, range.start.month, range.start.day);
            final endDate = DateTime(range.end.year, range.end.month, range.end.day);
            return onlyDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
                   onlyDate.isBefore(endDate.add(const Duration(days: 1)));
          })
          .toList();

      filteredData = Map.fromEntries(filtered);

      print('Filtered Data: $filteredData'); // 디버깅용 출력
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('통계'),
        backgroundColor: Colors.blue[200],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  PeriodSelector(
                    onPeriodSelected: _onPeriodSelected,
                    selectedRange: selectedRange,
                  ),
                  const SizedBox(height: 16),
                  if (timerController != null)
                    StatsSummary(timerController: timerController!),
                  const SizedBox(height: 16),
                  DateChart(dateData: filteredData), // 날짜별 그래프
                  const SizedBox(height: 16),
                  SubjectChart(subjectData: subjectData), // 과목별 차트
                ],
              ),
            ),
    );
  }
}

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(16.0),
          child: SfCircularChart(
            title: ChartTitle(
              text: '과목별 시간 분포',
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            legend: Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CircularSeries<_SubjectChartData, String>>[
              PieSeries<_SubjectChartData, String>(
                dataSource: chartData,
                xValueMapper: (_SubjectChartData data, _) => data.subject,
                yValueMapper: (_SubjectChartData data, _) => data.minutes,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
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
