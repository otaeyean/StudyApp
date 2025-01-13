import 'package:flutter/material.dart';
import 'dart:async';
import 'timer_controller.dart'; 
import 'timer_detail_page.dart';

class TimerSection extends StatefulWidget {
  @override
  _TimerSectionState createState() => _TimerSectionState();
}

class _TimerSectionState extends State<TimerSection> {
  late TimerController _timerController;
  late Timer _timer;
  Map<String, Duration> _subjectTimeMap = {}; //과목별 멈춘 시간을 저장

  @override
  void initState() {
    super.initState();
    _timerController = TimerController(); // TimerController 초기화
    _subjectTimeMap = {}; //과목별 멈춘 시간 초기화
    _loadTimers();  
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimers);  
  }

  @override
  void dispose() {
    _timer.cancel(); 
    _timerController.saveTimers(); 
    super.dispose();
  }

  // 타이머 설정 관련 메소드들
  
  void _updateTimers(Timer timer) {
    setState(() {});
  }

  void _onTimeUpdate(String subject, Duration elapsed) {
    setState(() {
      _subjectTimeMap[subject] = elapsed; // 과목별 멈춘 시간 저장
    });
  }

  // 타이머 상태 불러오는 메소드
  Future<void> _loadTimers() async {
    await _timerController.loadTimers();
    setState(() {});
  }

  // 새로운 과목 추가
  void _addSubject() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('새 과목 추가'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: '새 과목을 입력하세요'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                String newSubject = controller.text.trim();
                if (newSubject.isNotEmpty && !_timerController.subjectTimers.containsKey(newSubject)) {
                  setState(() {
                    _timerController.addSubject(newSubject);
                  });
                  _timerController.saveTimers();
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

  // 과목 이름 수정
  void _editSubject(String oldSubject) {
    TextEditingController controller = TextEditingController(text: oldSubject);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('과목 이름 수정'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: '새 과목 이름을 입력하세요'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                String newSubject = controller.text.trim();
                if (newSubject.isNotEmpty && newSubject != oldSubject && !_timerController.subjectTimers.containsKey(newSubject)) {
                  setState(() {
                    _timerController.renameSubject(oldSubject, newSubject);
                  });
                  _timerController.saveTimers();
                  Navigator.pop(context);
                }
              },
              child: const Text('수정'),
            ),
          ],
        );
      },
    );
  }

  // 과목 삭제
  void _deleteSubject(String subject) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('과목 삭제'),
          content: const Text('이 과목을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _timerController.removeSubject(subject);
                });
                _timerController.saveTimers();
                Navigator.pop(context);
              },
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Duration totalTime = _subjectTimeMap.values.fold(Duration(), (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.access_time, color: Colors.amber),
            const SizedBox(width: 8),
            const Text('Timer'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addSubject,
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('하루 누적 시간:'),
                Text(_timerController.formatTime(totalTime)),
              ],
            ),
          ),
          ..._timerController.subjectTimers.keys.map((subject) {
            return ListTile(
              title: Text(subject),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      _timerController.subjectTimers[subject]!.isRunning
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed: () {
                      setState(() {
                        _timerController.startStopTimer(subject);
                      });

                      if (_timerController.subjectTimers[subject]!.isRunning) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TimerDetailPage(
                              subject: subject,
                              stopwatch: _timerController.subjectTimers[subject]!,
                              onTimeUpdate: (elapsed) {
                                _onTimeUpdate(subject, elapsed);
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  Text(
                    _subjectTimeMap[subject] != null
                        ? _timerController.formatTime(_subjectTimeMap[subject]!)
                        : _timerController.formatElapsedTime(subject),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editSubject(subject),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteSubject(subject),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
