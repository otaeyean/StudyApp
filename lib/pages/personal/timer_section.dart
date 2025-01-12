import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert'; 
import 'timer_detail_page.dart';

class TimerSection extends StatefulWidget {
  @override
  _TimerSectionState createState() => _TimerSectionState();
}

class _TimerSectionState extends State<TimerSection> {
  final Map<String, Stopwatch> _subjectTimers = {}; // 과목별 스톱워치
  final Map<String, Duration> _subjectTotalTimes = {}; // 과목별 누적 시간
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadTimers();
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimers);
  }

  // 타이머 업데이트하는 함수
  void _updateTimers(Timer timer) {
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    _saveTimers(); 
    super.dispose();
  }

  // 타이머 텍스트 표시
  String _formatTime(Duration elapsed) {
    final hours = elapsed.inHours.toString().padLeft(2, '0');
    final minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  // 타이머 시작, 멈춤 처리 함수 (수정 필요)
  void _startStopTimer(String subject) {
    setState(() {
      if (_subjectTimers[subject]!.isRunning) {
        _subjectTimers[subject]!.stop();
        // 타이머 멈출 때 경과 시간 누적
        _subjectTotalTimes[subject] = (_subjectTotalTimes[subject] ?? Duration()) + _subjectTimers[subject]!.elapsed;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TimerDetailPage(
              subject: subject,
              stopwatch: _subjectTimers[subject]!,
              onTimeUpdate: (elapsedTime) {
                // 디테일 페이지에서 타이머 업데이트 후 누적 시간 반영
                setState(() {
                  _subjectTotalTimes[subject] = (_subjectTotalTimes[subject] ?? Duration()) + elapsedTime;
                });
              },
            ),
          ),
        ).then((elapsedTime) {
        });
      }
    });
  }

  // 새 과목 추가 함수
  void _addSubject() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: const Text('새 과목 추가'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: '새 과목을 입력하세요'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                String newSubject = controller.text.trim();
                if (newSubject.isNotEmpty && !_subjectTimers.containsKey(newSubject)) {
                  setState(() {
                    _subjectTimers[newSubject] = Stopwatch();
                    _subjectTotalTimes[newSubject] = Duration(); // 새로운 과목의 누적 시간 0으로 초기화함
                  });
                  _saveTimers(); 
                  Navigator.pop(context);
                }
              },
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }

  // 타이머 상태 저장 함수
  Future<void> _saveTimers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> subjects = _subjectTimers.keys.toList();
    List<String> timers = [];
    List<String> totalTimes = [];

    for (var subject in subjects) {
      timers.add(_subjectTimers[subject]!.elapsed.inSeconds.toString()); //타이머의 경과 시간 설정
      totalTimes.add(_subjectTotalTimes[subject]!.inSeconds.toString()); 
    }

    prefs.setStringList('subjects', subjects);
    prefs.setStringList('timers', timers);
    prefs.setStringList('totalTimes', totalTimes);
  }

  // 타이머 상태 불러오기 함수 (수정 필요 현재 누적 반영됨)
  Future<void> _loadTimers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? subjects = prefs.getStringList('subjects');
    List<String>? timers = prefs.getStringList('timers');
    List<String>? totalTimes = prefs.getStringList('totalTimes');

    if (subjects != null && timers != null && totalTimes != null) {
      for (int i = 0; i < subjects.length; i++) {
        String subject = subjects[i];
        _subjectTimers[subject] = Stopwatch();
        
        _subjectTimers[subject]!.start();
        _subjectTimers[subject]!.reset();
        
        _subjectTimers[subject]!.start();  
        _subjectTotalTimes[subject] = Duration(seconds: int.parse(totalTimes[i]));  
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Divider(thickness: 1, color: Colors.grey); 
    Duration totalTime = _subjectTotalTimes.values.fold(Duration(), (a, b) => a + b); //누적 시간 계산

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.access_time, 
              color: Colors.amber, 
            ),
            const SizedBox(width: 8), 
            const Text('Timer'),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addSubject, 
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], 
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '하루 누적 시간 : ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _formatTime(totalTime),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ..._subjectTimers.keys.map((subject) {
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(subject),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _subjectTimers[subject]!.isRunning
                                ? Icons.stop
                                : Icons.play_arrow,
                          ),
                          onPressed: () => _startStopTimer(subject),
                        ),
                        Text(_formatTime(_subjectTimers[subject]!.elapsed)),
                      ],
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _subjectTimers.remove(subject);
                          _subjectTotalTimes.remove(subject);
                        });
                        _saveTimers(); 
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }
}
