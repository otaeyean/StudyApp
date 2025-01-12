import 'package:flutter/material.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();  // 이메일 입력
  final TextEditingController _passwordController = TextEditingController();  // 비밀번호 입력
  final TextEditingController _nicknameController = TextEditingController(); // 닉네임 입력

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  // 회원가입 처리 함수 (Firebase 로직 제외했음)
  void _signUp() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final nickname = _nicknameController.text.trim(); 
    if (email.isEmpty || password.isEmpty || nickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일, 비밀번호, 닉네임을 입력해주세요')),
      );
      return;
    }
    // Firebase 빼고 그냥 성공으로 넘김
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('회원가입 성공!')),
    );

    // 로그인 페이지로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입', style: TextStyle(fontFamily: "GmarketBold")),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 60),
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                style: TextStyle(fontSize: 30, color: Colors.black, fontFamily: "GmarketBold",),
                children: [
                  TextSpan(text: ' 회원님의\n '),
                  TextSpan(
                    text: '계정',
                    style: TextStyle(color: Colors.deepPurple, fontFamily: "GmarketBold"),
                  ),
                  TextSpan(text: '을 만들어주세요.\n\n', style: TextStyle(fontFamily: "GmarketBold")),
                ],
              ),
            ),
      
            Text('Email', style: TextStyle(fontSize: 16, fontFamily: "GmarketBold")),
            SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: '이메일',
                hintStyle: TextStyle(fontFamily: "GmarketMedium"),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            Text('PW', style: TextStyle(fontSize: 16, fontFamily: "GmarketBold")),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: '비밀번호',
                hintStyle: TextStyle(fontFamily: "GmarketMedium"),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Text('닉네임', style: TextStyle(fontSize: 16, fontFamily: "GmarketBold")),
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                hintText: '닉네임',
                hintStyle: TextStyle(fontFamily: "GmarketMedium"),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 30),
          
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signUp,
                  child: Text('회원가입 하기', style: TextStyle(color: Colors.white, fontFamily: "GmarketBold")),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF37003C),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
