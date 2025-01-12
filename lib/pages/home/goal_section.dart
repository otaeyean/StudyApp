import 'dart:convert';  // JSON 인코딩 및 디코딩
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalSection extends StatefulWidget {
  @override
  _GoalSectionState createState() => _GoalSectionState();
}

class _GoalSectionState extends State<GoalSection> {
  List<Map<String, dynamic>> goals = [];
  int lastWeekCompletionRate = 0;
  int completedGoals = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // 데이터 불러오기 (목표 리스트와 지난주 달성률)
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // 목표 리스트 복원
    String? goalsJson = prefs.getString('goals');
    if (goalsJson != null) {
      setState(() {
        goals = List<Map<String, dynamic>>.from(jsonDecode(goalsJson));
      });
    }

    // 지난주 달성률 복원
    setState(() {
      lastWeekCompletionRate = prefs.getInt('lastWeekCompletionRate') ?? 0;
    });

    // 완료된 목표 수 업데이트
    completedGoals = goals.where((goal) => goal['completed'] == true).length;
  }

  // 목표 리스트와 달성률 저장
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // 목표 리스트 저장 (JSON 문자열로 변환)
    await prefs.setString('goals', jsonEncode(goals));

    // 현재 달성률 저장
    int currentCompletionRate = _calculateCompletionRate();
    await prefs.setInt('lastWeekCompletionRate', currentCompletionRate);
  }

  void _addGoal(BuildContext context) {
    TextEditingController goalController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('목표 추가'),
          content: TextField(
            controller: goalController,
            decoration: InputDecoration(hintText: '목표를 입력하세요'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                if (goalController.text.isNotEmpty) {
                  setState(() {
                    goals.add({'text': goalController.text, 'completed': false});
                    _saveData();  // 목표 리스트 저장
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('추가'),
            ),
          ],
        );
      },
    );
  }

  // 목표 삭제
  void _deleteGoal(int index) {
    setState(() {
      goals.removeAt(index);
      completedGoals = goals.where((goal) => goal['completed']).length;
      _saveData();
    });
  }
  void _toggleGoalCompletion(int index) {
    setState(() {
      goals[index]['completed'] = !goals[index]['completed'];
      completedGoals = goals.where((goal) => goal['completed'] == true).length;
      _saveData();  // 상태 변경 후 저장
    });
  }

  int _calculateCompletionRate() {
    if (goals.isEmpty) return 0;
    return ((completedGoals / goals.length) * 100).round();
  }

  String _getProgressMessage() {
    int currentCompletionRate = _calculateCompletionRate();
    int difference = currentCompletionRate - lastWeekCompletionRate;

    if (difference > 0) {
      return '지난주보다 달성률이 ${difference}% 상승했어요!';
    } else if (difference < 0) {
      return '지난주보다 달성률이 ${difference.abs()}% 감소했어요.';
    } else {
      return '지난주와 달성률이 동일해요.';
    }
  }

  @override
  Widget build(BuildContext context) {
    int completionRate = _calculateCompletionRate();
    String progressMessage = _getProgressMessage();

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.amber),
              SizedBox(width: 8),
              Text(
                '목표',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(child: Container()),
              Text(
                '"$progressMessage"',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '이번주 목표',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '달성률: $completionRate%',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ...goals.map((goal) {
                  int index = goals.indexOf(goal);
                  return Row(
                    children: [
                      Checkbox(
                        value: goal['completed'],
                        onChanged: (value) {
                          _toggleGoalCompletion(index);
                        },
                      ),
                      Expanded(
                        child: Text(
                          goal['text'],
                          style: TextStyle(
                            fontSize: 14,
                            decoration: goal['completed']
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                          IconButton(
                  icon: Icon(Icons.backspace, color: Colors.red),
                  onPressed: () => _deleteGoal(index),
                      ),
                    ],
                  );
                }).toList(),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _addGoal(context),
                  icon: Icon(Icons.add),
                  label: Text('추가'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
