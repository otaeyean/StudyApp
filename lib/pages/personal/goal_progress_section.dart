import 'package:flutter/material.dart';
import 'dart:async';

//필요 없을 것 같아서 주석 안 달겠음 오류날까봐 같이 올림림
class GoalProgressSection extends StatefulWidget {
  final Stopwatch stopwatch;
  final Function(Duration) onGoalUpdate;
  final String selectedSubject;

  GoalProgressSection({
    required this.stopwatch,
    required this.onGoalUpdate,
    required this.selectedSubject,
  });

  @override
  _GoalProgressSectionState createState() => _GoalProgressSectionState();
}

class _GoalProgressSectionState extends State<GoalProgressSection> {
  late Timer _timer;
  double _progress = 0;
  TimeOfDay _selectedTime = TimeOfDay.now();
  Duration _goalDuration = Duration.zero;
  Map<String, double> _savedProgress = {};

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), _updateProgress);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateProgress(Timer timer) {
    setState(() {
      _progress = _calculateProgress();
    });
  }

  double _calculateProgress() {
    if (_goalDuration.inSeconds == 0) return 0;
    return (widget.stopwatch.elapsed.inSeconds / _goalDuration.inSeconds).clamp(0.0, 1.0);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _updateGoalDuration();
      });
    }
  }

  void _updateGoalDuration() {
    final now = DateTime.now();
    final selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    
    if (selectedDateTime.isBefore(now)) {
      _goalDuration = selectedDateTime.add(Duration(days: 1)).difference(now);
    } else {
      _goalDuration = selectedDateTime.difference(now);
    }
    
    widget.onGoalUpdate(_goalDuration);
  }

  String _formatTime(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void _saveProgress() {
    setState(() {
      _savedProgress[widget.selectedSubject] = _progress;
    });
  }

  Widget _buildProgressBar(double progress, {bool isSaved = false}) {
    return Column(
      children: [
        Row(
          children: [
            Text('0%', style: TextStyle(fontSize: 12)),
            Expanded(
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                color: isSaved ? Colors.green : const Color.fromARGB(255, 0, 148, 253),
                minHeight: 20, 
              ),
            ),
            Text('100%', style: TextStyle(fontSize: 12)),
          ],
        ),
        SizedBox(height: 4),
        Text(
          '${(progress * 100).toStringAsFixed(1)}% 달성',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSavedProgressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '저장된 달성률',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ..._savedProgress.entries.map((entry) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.key, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              _buildProgressBar(entry.value, isSaved: true),
              SizedBox(height: 12),
            ],
          )).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${_selectedTime.format(context)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: Text('선택'),
                  ),
                ],
              ),
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
                    Icon(Icons.bar_chart, color: Colors.amber),
                    SizedBox(width: 8),
                    Text(
                      '${widget.selectedSubject} 목표 달성률',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildProgressBar(_progress),
                SizedBox(height: 16),
                Text(
                  '목표 기간: ${_formatTime(_goalDuration)}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  '경과 시간: ${_formatTime(widget.stopwatch.elapsed)}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: _saveProgress,
                    child: Text('저장하기'),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_savedProgress.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: _buildSavedProgressSection(),
          ),
      ],
    );
  }
}
