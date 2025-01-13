import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; 

class TodoListSection extends StatefulWidget {
  @override
  _TodoListSectionState createState() => _TodoListSectionState();
}

class _TodoListSectionState extends State<TodoListSection> with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, List<Map<String, dynamic>>> _subjectTodos = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
Future<void> _loadData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? data = prefs.getString('subjectTodos');
  if (data != null) {
    setState(() {
      _subjectTodos = Map<String, List<Map<String, dynamic>>>.from(
        json.decode(data).map((key, value) {
          return MapEntry(
            key,
            List<Map<String, dynamic>>.from(
                value.map((item) => Map<String, dynamic>.from(item))),
          );
        }),
      );
    });
  } else {
    print('No data found!');
  }

  // Ensure _tabController is updated after loading data
  setState(() {
    _tabController = TabController(
      length: _subjectTodos.keys.length,
      vsync: this,
    );
  });
}

@override
void dispose() {
  _saveData();
  _tabController.dispose();
  super.dispose();
}

// 데이터 저장 
Future<void> _saveData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String encodedData = json.encode(_subjectTodos);
  await prefs.setString('subjectTodos', encodedData);
  print('Data saved: $encodedData');
}

// todolist 과목 관련 함수

  // 과목 추가 함수
  void _addSubject() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('새 과목 추가'),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                if (newSubject.isNotEmpty && !_subjectTodos.containsKey(newSubject)) {
                  setState(() {
                    _subjectTodos[newSubject] = [];
                    _tabController = TabController(
                      length: _subjectTodos.keys.length,
                      vsync: this,
                    );
                    _saveData();
                  });
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


   // 과목 수정 함수
  void _editSubject(String oldSubject) {
    TextEditingController controller = TextEditingController(text: oldSubject);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('과목 수정'),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: '수정할 과목명을 입력하세요'),
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
                if (newSubject.isNotEmpty && !_subjectTodos.containsKey(newSubject)) {
                  setState(() {
                    _subjectTodos[newSubject] = _subjectTodos[oldSubject]!;
                    _subjectTodos.remove(oldSubject);
                    _tabController = TabController(
                      length: _subjectTodos.keys.length,
                      vsync: this,
                    );
                    _saveData();
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('저장'),
            ),
          ],
        );
      },
    );
  }

// 과목 삭제 함수
  void _deleteSubject(String subject) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: const Text('과목 삭제'),
          content: const Text('이 과목을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _subjectTodos.remove(subject);
                  _tabController = TabController(
                    length: _subjectTodos.keys.length,
                    vsync: this,
                  );
                  _saveData();
                });
                Navigator.pop(context);
              },
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  // 과목 메뉴 함수 (수정, 삭제)
void _subjectMenu(String subject) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text('과목 관리'),
        content: const Text('과목을 수정하거나 삭제할 수 있습니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
            },
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editSubject(subject); 
            },
            child: const Text('수정'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteSubject(subject); 
            },
            child: const Text('삭제'),
          ),
        ],
      );
    },
  );
}

// todolist 항목 관련 함수 시작 부분

 // 항목 수정 함수
  void _editTodo(int index, String subject) {
    TextEditingController controller = TextEditingController(
      text: _subjectTodos[subject]![index]['text'],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: const Text('항목 수정'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: '수정할 내용을 입력하세요'),
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
                setState(() {
                  _subjectTodos[subject]![index]['text'] = controller.text;
                  _saveData();
                });
                Navigator.pop(context);
              },
              child: const Text('저장'),
            ),
          ],
        );
      },
    );
  }

   // 항목 삭제 함수
  void _deleteTodo(int index, String subject) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: const Text('항목 삭제'),
          content: const Text('이 항목을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _subjectTodos[subject]!.removeAt(index);
                  _saveData();
                });
                Navigator.pop(context);
              },
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }

   // 항목 추가 함수
  void _addTodo(String subject) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: const Text('새 항목 추가'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: '새 항목을 입력하세요'),
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
                setState(() {
                  _subjectTodos[subject]!.add({'text': controller.text, 'isChecked': false});
                  _saveData();
                });
                Navigator.pop(context);
              },
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Todo List'),
      backgroundColor: Colors.white,
      leading: Icon(
        Icons.note, 
        color: Colors.amber, 
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _addSubject,
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: _subjectTodos.keys.map((subject) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onLongPress: () {
                print('꾹 누르기 확인 $subject');
                _subjectMenu(subject);
              },
              onDoubleTap: () {
                print('더블 클릭 확인 $subject');
                _subjectMenu(subject);
              },
              child: Tab(text: subject),
            ),
          );
        }).toList(),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicatorColor: const Color.fromARGB(255, 78, 169, 234),
        indicatorWeight: 3.0,
      ),
    ),
    body: _subjectTodos.isEmpty
        ? Center(
            child: Text(
              'TodoList를 작성하세요',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          )
        : TabBarView(
            controller: _tabController,
            children: _subjectTodos.entries.map((entry) {
              final subject = entry.key;
              final todos = entry.value;
              return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final todo = todos[index];
                          return Container(
                            color: Colors.grey[100], 
                            child: ListTile(
                              leading: Checkbox(
                                value: todo['isChecked'],
                                onChanged: (value) {
                                  setState(() {
                                    todo['isChecked'] = value;
                                    _saveData();
                                  });
                                },
                              ),
                              title: Text(
                                todo['text'],
                                style: TextStyle(
                                  decoration: todo['isChecked']
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: todo['isChecked'] ? Colors.grey : Colors.black,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _editTodo(index, subject),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteTodo(index, subject),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
    floatingActionButton: TextButton(
      onPressed: () => _addTodo(_subjectTodos.keys.elementAt(_tabController.index)),
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue[50], 
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), 
        ),
      ),
      child: Text(
        '항목 추가',
        style: TextStyle(
          color: Colors.blue, 
          fontSize: 16, 
        ),
      ),
    ),
    backgroundColor: Colors.white,
  );
}

}