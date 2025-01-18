import 'package:flutter/material.dart';

class CreateRoomScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onCreateRoom;

  CreateRoomScreen({required this.onCreateRoom});

  @override
  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final List<String> _tags = [];
  int _selectedRoomType = 0;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height; 
    final screenWidth = MediaQuery.of(context).size.width; 

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '회의방 만들기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.02), 
                  
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: '방 이름',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), 
                   
                    TextField(
                      controller: _tagController,
                      decoration: InputDecoration(
                        labelText: '태그',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.tag),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            if (_tagController.text.isNotEmpty) {
                              setState(() {
                                _tags.add(_tagController.text);
                                _tagController.clear();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01), 
                    
                    Wrap(
                      spacing: screenWidth * 0.02,
                      children: _tags
                          .map(
                            (tag) => Chip(
                              label: Text(tag),
                              deleteIcon: Icon(Icons.close),
                              onDeleted: () {
                                setState(() {
                                  _tags.remove(tag);
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: screenHeight * 0.02), 
                 
                    Column(
                      children: [
                        ListTile(
                          title: const Text('공개방'),
                          subtitle: Text(
                            '누구나 참여',
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: Radio(
                            value: 0,
                            groupValue: _selectedRoomType,
                            onChanged: (value) {
                              setState(() {
                                _selectedRoomType = value as int;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('비밀방'),
                          subtitle: Text(
                            '암호 입력',
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: Radio(
                            value: 1,
                            groupValue: _selectedRoomType,
                            onChanged: (value) {
                              setState(() {
                                _selectedRoomType = value as int;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
            
                    if (_selectedRoomType == 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: '암호',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                      ),
                  ],
                ),
              ),
            ),
         
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.04),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      final roomData = {
                        'name': _nameController.text,
                        'tags': _tags,
                        'roomType': _selectedRoomType == 0 ? '공개방' : '비밀방',
                        'participants': 0,
                        'password': _selectedRoomType == 1 ? _passwordController.text : null,
                      };
                      widget.onCreateRoom(roomData);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '생성',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
