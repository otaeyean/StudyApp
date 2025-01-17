import 'package:flutter/material.dart';
import 'dart:async';
import 'goal_progress_section.dart';
import 'timer_controller.dart';

class TimerDetailPage extends StatefulWidget {
  final String subject;
  final Stopwatch stopwatch;
  final Function(Duration) onTimeUpdate;
  final TimerController timerController;

  TimerDetailPage({
    required this.subject,
    required this.stopwatch,
    required this.onTimeUpdate,
    required this.timerController,
  });

  @override
  _TimerDetailPageState createState() => _TimerDetailPageState();
}

class _TimerDetailPageState extends State<TimerDetailPage> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  bool _isRunning = false;
  late Duration _goalDuration;
  late String _currentSubject;

  @override
  void initState() {
    super.initState();
    _stopwatch = widget.stopwatch;
    _isRunning = _stopwatch.isRunning;
    _goalDuration = Duration(hours: 2);
    _currentSubject = widget.subject;

    if (!_isRunning) {
      _stopwatch.start();
      _isRunning = true;
    }
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
  }
@override
void dispose() {
  print("TimerDetailPage disposed for subject: $_currentSubject");
  if (_timer.isActive) {
    _timer.cancel();
  }

  if (_isRunning) {
    _stopwatch.stop();
    widget.onTimeUpdate(_stopwatch.elapsed);
    widget.timerController.startStopTimer(_currentSubject);
    print("Calling saveTimers from dispose");
    widget.timerController.saveTimers();
  }

  super.dispose();
}



  void _updateTimer(Timer timer) {
    if (mounted) {
      setState(() {});
    }
  }

  String _formatTime(Duration elapsed) {
    return widget.timerController.formatTime(elapsed);
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

  void _updateGoalDuration(Duration newDuration) {
    setState(() {
      _goalDuration = newDuration;
    });
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = _stopwatch.elapsed;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          _currentSubject,
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          color: _isRunning
                              ? const Color.fromARGB(255, 1, 44, 75)
                              : Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GoalProgressSection(
              stopwatch: _stopwatch,
              onGoalUpdate: _updateGoalDuration,
              selectedSubject: _currentSubject,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
