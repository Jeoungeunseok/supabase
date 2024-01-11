import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KakaoInfo extends StatelessWidget {
  final Session session;
  final supabase = Supabase.instance.client;
  KakaoInfo({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kakao Info'),
        backgroundColor: Colors.yellow,
      ),
      body: Container(
        color: Colors.yellow,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(session.user.userMetadata!['avatar_url']),
                radius: 50,
              ),
              title: Text(
                session.user.userMetadata!['name'],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                session.user.userMetadata!['email'],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // ... 추가적으로 필요한 정보를 표시 ...

            ElevatedButton(
              onPressed: () async {
                await supabase.auth.signOut();
                Navigator.pop(context);
              },
              child: const Text('로그아웃'),
            ),
          ],
        ),
      ),
    );
  }
}
