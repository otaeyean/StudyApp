import 'package:flutter/material.dart';

class PostDetailPage extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostDetailPage({required this.post});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  List<Map<String, String>> comments = [
    {'username': 'User1', 'content': '첫 번째 댓글입니다.'},
    {'username': 'User2', 'content': '두 번째 댓글입니다.'},
  ];

  final TextEditingController commentController = TextEditingController();

  void _addNewComment(String comment) {
    setState(() {
      comments.add({'username': 'NewUser', 'content': comment});
      commentController.clear(); // 입력창 초기화
    });
  }

  void _incrementLike() {
    setState(() {
      widget.post['likes']++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // AppBar 색상 블루로 변경
        automaticallyImplyLeading: true, // 뒤로가기 화살표 유지, 제목 제거
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Text(
              widget.post['title'] ?? '제목 없음',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // 작성자와 작성 시간
            Text(
              '작성자: ${widget.post['username'] ?? '알 수 없음'} • ${widget.post['timestamp'] ?? '시간 없음'}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),

            // 내용 위의 회색 선
            Divider(color: Colors.grey, thickness: 1),

            // 내용
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                widget.post['content'] ?? '내용 없음',
                style: TextStyle(fontSize: 16),
              ),
            ),

            // 추천과 조회수
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: _incrementLike,
                ),
                Text(
                  '${widget.post['likes']}',
                  style: TextStyle(fontSize: 14), // 텍스트 크기 줄이기
                ),
                SizedBox(width: 20),
                Text(
                  '조회수: ${widget.post['views']}',
                  style: TextStyle(fontSize: 14), // 텍스트 크기 줄이기
                ),
              ],
            ),

            Divider(height: 32), // 댓글 리스트와의 구분

            // 댓글 리스트 제목
            Text(
              '댓글',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                          backgroundColor: Colors.grey[300],
                        ),
                        title: Text(
                          comments[index]['username'] ?? '익명',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(comments[index]['content'] ?? ''),
                      ),
                      Divider(), // 댓글 구분선
                    ],
                  );
                },
              ),
            ),

            // 댓글 작성 칸
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      labelText: '댓글 작성',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (commentController.text.isNotEmpty) {
                      _addNewComment(commentController.text);
                    }
                  },
                  child: Text('완료'),
                    style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, // 버튼 배경 진한 파란색
                  foregroundColor: Colors.black, // 텍스트 색상 흰색
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // 버튼 모서리 둥글게
                  ),
                ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
