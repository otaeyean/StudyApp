import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TimerController {
  final Map<String, Stopwatch> _subjectTimers = {}; // 과목별 스톱워치
  final Map<String, Duration> _subjectTotalTimes = {}; // 과목별 누적 시간

  // 타이머 시작 및 멈춤 처리
void startStopTimer(String subject) {
  if (!_subjectTimers.containsKey(subject)) {
    _subjectTimers[subject] = Stopwatch();
  }
  if (!_subjectTotalTimes.containsKey(subject)) {
    _subjectTotalTimes[subject] = Duration();
  }

  if (_subjectTimers[subject]!.isRunning) {
    // 타이머를 멈추고 누적 시간을 업데이트
    _subjectTimers[subject]!.stop();
    _subjectTotalTimes[subject] =
        _subjectTotalTimes[subject]! + _subjectTimers[subject]!.elapsed;
    _subjectTimers[subject]!.reset();
    print("Updated total time for $subject: ${_subjectTotalTimes[subject]}");
    saveTimers(); // 저장 호출 추가
  } else {
    // 타이머를 시작
    _subjectTimers[subject]!.start();
    print("Timer started for $subject");
  }
}




  // 과목 추가
  void addSubject(String subject) {
    if (!_subjectTimers.containsKey(subject)) {
      _subjectTimers[subject] = Stopwatch();
      _subjectTotalTimes[subject] = Duration();
    }
  }

  // 과목 이름 변경
  void renameSubject(String oldSubject, String newSubject) {
    if (_subjectTimers.containsKey(oldSubject)) {
      _subjectTimers[newSubject] = _subjectTimers.remove(oldSubject)!;
      _subjectTotalTimes[newSubject] = _subjectTotalTimes.remove(oldSubject)!;
    }
  }
// 과목 삭제
void removeSubject(String subject) {
  _subjectTimers.remove(subject);
  _subjectTotalTimes.remove(subject);
  saveTimers(); // 과목 삭제 시 즉시 저장
}

// 데이터 저장
Future<void> saveTimers() async {
  print("saveTimers called");
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // 기존 데이터 로드
  String? savedData = prefs.getString('timersData');
  Map<String, dynamic> data = savedData != null ? jsonDecode(savedData) : {};

  // 현재 날짜
  String today = DateTime.now().toIso8601String().split('T').first;

  // 현재 날짜의 데이터를 가져오거나 초기화
  Map<String, int> todayData = {};

  // 현재 메모리 상태를 기반으로 데이터 업데이트
  _subjectTimers.forEach((subject, timer) {
    int totalTime = (_subjectTotalTimes[subject]?.inSeconds ?? 0) +
        (timer.isRunning ? timer.elapsed.inSeconds : 0);
    todayData[subject] = totalTime;
    print("Saving $subject: $totalTime seconds");
  });

  // 삭제된 과목 반영: 현재 메모리 상태에 없는 과목은 제거
  data[today] = todayData;

  // 업데이트된 데이터를 SharedPreferences에 저장
  await prefs.setString('timersData', jsonEncode(data));

  print("Data saved: $data");
}





  // 데이터 불러오기
  Future<void> loadTimers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 데이터 로드
    String? savedData = prefs.getString('timersData');
    if (savedData != null) {
      Map<String, dynamic> data = jsonDecode(savedData);

      // 오늘 날짜 기준으로 데이터 복원
      String today = DateTime.now().toIso8601String().split('T').first;
      if (data[today] != null) {
        Map<String, int> todayData = Map<String, int>.from(data[today]);
        todayData.forEach((subject, totalSeconds) {
          _subjectTimers[subject] = Stopwatch();
          _subjectTotalTimes[subject] = Duration(seconds: totalSeconds);
        });
      print("Timers loaded for today: $todayData");
      }
    }
  }

  // 시간 포맷 변환
  String formatTime(Duration elapsed) {
    final hours = elapsed.inHours.toString().padLeft(2, '0');
    final minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String formatElapsedTime(String subject) {
    if (_subjectTimers[subject]?.isRunning ?? false) {
      return formatTime(
        _subjectTimers[subject]!.elapsed + (_subjectTotalTimes[subject] ?? Duration()),
      );
    } else {
      return formatTime(_subjectTotalTimes[subject] ?? Duration());
    }
  }

  Map<String, Stopwatch> get subjectTimers => _subjectTimers;
  Map<String, Duration> get subjectTotalTimes => _subjectTotalTimes;

  // 저장된 데이터 확인
  Future<void> checkSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('timersData');

    if (savedData != null) {
      print("저장된 데이터: $savedData");
    } else {
      print("저장된 데이터가 없습니다.");
    }
  }
} 