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
      'username': 'User1',
      'title': '첫 번째 게시글',
      'commentCount': 5,
      'timestamp': '2025-01-09 10:00',
    },
    {
      'username': 'User2',
      'title': '두 번째 게시글',
      'commentCount': 3,
      'timestamp': '2025-01-08 11:00',
    },
  ];

  void _addNewPost(String title, String content) {
    setState(() {
      posts.insert(0, {
        'username': 'NewUser',
        'title': title,
        'commentCount': 0,
        'timestamp': DateTime.now().toString().substring(0, 16),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('자유게시판'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                title: Text(
                  posts[index]['title'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${posts[index]['username']} • 댓글 ${posts[index]['commentCount']}개 • ${posts[index]['timestamp']}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
        child: Icon(Icons.add),
      ),
    );
  }
}
