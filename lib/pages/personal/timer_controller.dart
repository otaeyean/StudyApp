import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class TimerController {
  final Map<String, Stopwatch> _subjectTimers = {}; 
  final Map<String, Duration> _subjectTotalTimes = {}; 
  final Set<String> _deletedSubjects = {}; // 이거 수정 필요함함

  // 타이머 시작 및 멈춤 처리 
  void startStopTimer(String subject) {
    if (_subjectTimers[subject]!.isRunning) {
      _subjectTimers[subject]!.stop();
      _subjectTotalTimes[subject] = 
        (_subjectTotalTimes[subject] ?? Duration()) + _subjectTimers[subject]!.elapsed;
      _subjectTimers[subject]!.reset();
    } else {
      _subjectTimers[subject]!.start();
    }
  }

  // 과목 추가
  void addSubject(String subject) {
    if (_deletedSubjects.contains(subject)) {
      _deletedSubjects.remove(subject); 
    }
    _subjectTimers[subject] = Stopwatch();
    _subjectTotalTimes[subject] = Duration();
  }

  // 과목 이름 수정
  void renameSubject(String oldSubject, String newSubject) {
    if (_subjectTimers.containsKey(oldSubject)) {
      _subjectTimers[newSubject] = _subjectTimers.remove(oldSubject)!;
      _subjectTotalTimes[newSubject] = _subjectTotalTimes.remove(oldSubject)!;
    }
  }

  // 과목 삭제
  void removeSubject(String subject) {
    if (_subjectTimers.containsKey(subject)) {
      _subjectTimers.remove(subject);
      _subjectTotalTimes.remove(subject);
      _deletedSubjects.add(subject); // 삭제된 과목을 별도로 관리 ( 수정 필요함함 )
    }
  }

  // 타이머 상태 저장
  Future<void> saveTimers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> subjects = _subjectTimers.keys.toList();
    List<int> elapsedTimes = [];
    List<int> totalTimes = [];

    for (var subject in subjects) {
      elapsedTimes.add(_subjectTimers[subject]!.elapsed.inSeconds);
      totalTimes.add(_subjectTotalTimes[subject]?.inSeconds ?? 0);
    }

    prefs.setStringList('subjects', subjects);
    prefs.setStringList('elapsedTimes', elapsedTimes.map((e) => e.toString()).toList());
    prefs.setStringList('totalTimes', totalTimes.map((e) => e.toString()).toList());
    prefs.setStringList('deletedSubjects', _deletedSubjects.toList()); // 삭제된 과목 저장 ( "" )
  }

  // 타이머 상태 불러오기
  Future<void> loadTimers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? subjects = prefs.getStringList('subjects');
    List<String>? elapsedTimes = prefs.getStringList('elapsedTimes');
    List<String>? totalTimes = prefs.getStringList('totalTimes');
    List<String>? deletedSubjects = prefs.getStringList('deletedSubjects');

    if (subjects != null && elapsedTimes != null && totalTimes != null) {
      for (int i = 0; i < subjects.length; i++) {
        String subject = subjects[i];
        int elapsed = int.parse(elapsedTimes[i]);
        int total = int.parse(totalTimes[i]);

        _subjectTimers[subject] = Stopwatch();
        _subjectTotalTimes[subject] = Duration(seconds: total);

        // 경과 시간을 따로 저장함함
        _subjectTimers[subject]!.stop(); 
        _subjectTotalTimes[subject] = Duration(seconds: elapsed);
      }
    }

    if (deletedSubjects != null) {
      _deletedSubjects.addAll(deletedSubjects); // 삭제된 과목 목록 불러오기 ( "" )
    }
  }

  // 시간 형식 변환
  String formatTime(Duration elapsed) {
    final hours = elapsed.inHours.toString().padLeft(2, '0');
    final minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String formatElapsedTime(String subject) {
    if (_subjectTimers[subject]!.isRunning) {
      //  현재 시간 + 저장된 시간
      return formatTime(
        _subjectTimers[subject]!.elapsed + (_subjectTotalTimes[subject] ?? Duration()),
      );
    } else {

      return formatTime(_subjectTotalTimes[subject] ?? Duration());
    }
  }

  Map<String, Stopwatch> get subjectTimers => _subjectTimers;
  Map<String, Duration> get subjectTotalTimes => _subjectTotalTimes;
  Set<String> get deletedSubjects => _deletedSubjects;
}
