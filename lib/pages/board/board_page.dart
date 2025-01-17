import 'package:flutter/material.dart';
import 'post_detail_page.dart';
import 'write_post_page.dart';

class BoardScreen extends StatefulWidget {
  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  List<Map<String, dynamic>> posts = [
    {
      'boardId': 1,
      'username': 'User1',
      'title': '첫 번째 게시글',
      'content': '첫 번째 게시글 내용입니다.',
      'commentCount': 5,
      'timestamp': '2025-01-09 10:00',
      'views': 100,
      'likes': 20,
    },
    {
      'boardId': 2,
      'username': 'User2',
      'title': '두 번째 게시글',
      'content': '두 번째 게시글 내용입니다.',
      'commentCount': 3,
      'timestamp': '2025-01-08 11:00',
      'views': 50,
      'likes': 10,
    },
  ];

  void _addNewPost(String title, String content) {
    setState(() {
      posts.insert(0, {
        'boardId': posts.length + 1,  // 새로운 boardId 생성
        'username': 'NewUser',
        'title': title,
        'content': content,
        'commentCount': 0,
        'timestamp': DateTime.now().toString().substring(0, 16),
        'views': 0,
        'likes': 0,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // AppBar 배경 색상
         foregroundColor: Colors.white,
        title: Text('자유게시판'),
        centerTitle: true, // 제목을 가운데 정렬
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Card(
              color: Colors.blue[50],  // 각 게시글의 배경 색상 설정
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                title: Text(
                  posts[index]['title'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${posts[index]['username']} • 댓글 ${posts[index]['commentCount']}개 • 조회수 ${posts[index]['views']} • 좋아요 ${posts[index]['likes']}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.amber),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailPage(post: posts[index]),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WritePostPage(onSubmit: _addNewPost),
            ),
          );
        },
        backgroundColor: Colors.amber,
        child: Icon(Icons.add),
      ),
    );
  }
}
