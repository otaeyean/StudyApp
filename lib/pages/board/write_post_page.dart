import 'package:flutter/material.dart';

class WritePostPage extends StatelessWidget {
  final Function(String, String) onSubmit;

  WritePostPage({required this.onSubmit});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 작성'),
        backgroundColor: Colors.blue, // 상단바 진한 파란색
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: '제목',
                labelStyle: TextStyle(color: Colors.blue[600]), // 라벨 파란색
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[800]!), // 포커스 시 테두리 진한 파란색
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: '내용',
                labelStyle: TextStyle(color: Colors.blue[600]), // 라벨 파란색
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[800]!), // 포커스 시 테두리 진한 파란색
                ),
              ),
              maxLines: 10,
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      contentController.text.isNotEmpty) {
                    onSubmit(titleController.text, contentController.text);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, // 버튼 배경 진한 파란색
                  foregroundColor: Colors.black, // 텍스트 색상 흰색
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // 버튼 모서리 둥글게
                  ),
                ),
                child: Text(
                  '저장',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
