import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; 
import 'create_room.dart';

class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<Map<String, dynamic>> _roomCards = []; 
  String _selectedFilter = '전체'; 

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedRooms = prefs.getString('roomCards');
    if (savedRooms != null) {
      setState(() {
        _roomCards = List<Map<String, dynamic>>.from(
          json.decode(savedRooms) as List,
        );
      });
    }
  }

  Future<void> _saveRooms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('roomCards', json.encode(_roomCards));
  }

  void _addRoom(Map<String, dynamic> roomData) {
    setState(() {
      _roomCards.add(roomData);
    });
    _saveRooms(); 
  }

  Color _getCardColor(int index) {
    List<Color> colors = [
      Colors.blue[100]!,
      Colors.green[100]!,
      Colors.red[100]!,
      Colors.orange[100]!,
    ];
    return colors[index % colors.length];
  }

  void _showPasswordDialog(BuildContext context, Map<String, dynamic> room) {
    final TextEditingController _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('암호를 입력하세요'),
        content: TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: '암호',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (_passwordController.text == room['password']) {
                Navigator.pop(context); 
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('입장이 승인되었습니다!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('암호가 틀렸습니다!')),
                );
              }
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredRooms() {
    if (_selectedFilter == '전체') {
      return _roomCards;
    } else {
      return _roomCards
          .where((room) => room['roomType'] == _selectedFilter)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          '그룹 회의방',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateRoomScreen(
                    onCreateRoom: _addRoom,
                  ),
                ),
              );
            },
            child: Text(
              '회의방 만들기',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
      
            Row(
              children: [
                DropdownButton<String>(
                  value: _selectedFilter,
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        _selectedFilter = value;
                      });
                    }
                  },
                  items: <String>['전체', '공개방', '비밀방']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '검색',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16), 
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: _getFilteredRooms().length,
                itemBuilder: (context, index) {
                  final room = _getFilteredRooms()[index];
                  return GestureDetector(
                    onTap: () {
                      if (room['roomType'] == '비밀방') {
                        _showPasswordDialog(context, room);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${room['name']}에 입장했습니다!')),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getCardColor(index),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.group,
                              size: 40,
                              color: Colors.black54,
                            ),
                            SizedBox(height: 8),
                            Text(
                              room['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '참여 인원: ${room['participants']}',
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '#${room['tags'].join(", ")}',
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                            SizedBox(height: 4),
                            Text(
                              room['roomType'], 
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: room['roomType'] == '공개방'
                                    ? Colors.blue
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
