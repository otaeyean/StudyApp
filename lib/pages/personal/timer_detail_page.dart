import 'package:flutter/material.dart';
import 'dart:async';

class TimerDetailPage extends StatefulWidget {
  final String subject;
  final Stopwatch stopwatch;
  final Function(Duration) onTimeUpdate; // 누적 시간을 업데이트 할 콜백 함수

  TimerDetailPage({
    required this.subject,
    required this.stopwatch,
    required this.onTimeUpdate,
  });

  @override
  _TimerDetailPageState createState() => _TimerDetailPageState();
}

class _TimerDetailPageState extends State<TimerDetailPage> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  late Duration _goalDuration;
  bool _isRunning = false;
  late double _progress; // 목표 시간 달성률
  late TextEditingController _goalController;

  @override
  void initState() {
    super.initState();
    _stopwatch = widget.stopwatch;
    _isRunning = _stopwatch.isRunning;
    _goalDuration = Duration(hours: 2); 
    _progress = 0; // 목표 달성률 초기화함
    _goalController = TextEditingController(text: '2'); 

    // 페이지가 로드되면 타이머 자동 시작
    if (!_isRunning) {
      _stopwatch.start();
      _isRunning = true;
    }
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
  }

  @override
  void dispose() {
    _timer.cancel();
    widget.onTimeUpdate(_stopwatch.elapsed); // 타이머 멈추고, 경과 시간 전달
    super.dispose();
  }

  void _updateTimer(Timer timer) {
    setState(() {
      _progress = _calculateProgress();
    });
  }

  // 타이머 포맷 함수
  String _formatTime(Duration elapsed) {
    final hours = elapsed.inHours.toString().padLeft(2, '0');
    final minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void _toggleStopwatch() {
    setState(() {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
      } else {
        _stopwatch.start();
      }
      _isRunning = _stopwatch.isRunning;
    });
  }

  // 목표 시간 설정 (회의 때 피드백 받은 후 수정)
  void _setGoal() {
    setState(() {
      int hours = int.parse(_goalController.text);
      _goalDuration = Duration(hours: hours);
      _progress = _calculateProgress();
    });
  }

  // 목표 달성률 계산 ("")
  double _calculateProgress() {
    if (_goalDuration.inSeconds == 0) {
      return 0;
    }
    return (_stopwatch.elapsed.inSeconds / _goalDuration.inSeconds).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = _stopwatch.elapsed;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.subject, // 어떤 과목인지 보여줌
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 타이머
            Container(
              color: Colors.blue[100],
              height: 300,
              width: double.infinity, 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, 
                children: [
                  SizedBox(height: 110), 
                  Text(
                    _formatTime(elapsed),
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: IconButton(
                        onPressed: _toggleStopwatch,
                        icon: Icon(
                          _isRunning ? Icons.pause : Icons.play_arrow,
                          color: _isRunning ? const Color.fromARGB(255, 1, 44, 75) : const Color.fromARGB(255, 0, 0, 0),
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 목표 시간 설정 섹션
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        '목표 시간 설정',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        child: TextField(
                          controller: _goalController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '시간',
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _setGoal,
                        child: Text('설정'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.book, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(
                          '목표 시간 달성률',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue[50]
                    ),
                    SizedBox(height: 16),
                    Text(
                      '목표 시간: ${_formatTime(_goalDuration)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '경과 시간: ${_formatTime(elapsed)}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }
}
