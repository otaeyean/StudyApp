import 'package:flutter/material.dart';
import 'todo_list_section.dart';
import 'timer_section.dart';

class PersonalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       
        Expanded(
          child: Column(
            children: [
              // TodoListSection 불러오기
              Expanded(
                flex: 3,
                child: TodoListSection(),
              ),
              // TimerSection 불러오기
              Expanded(
                flex: 2,
                child: TimerSection(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
