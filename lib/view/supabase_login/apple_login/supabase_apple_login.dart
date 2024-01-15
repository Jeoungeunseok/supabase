import 'package:flutter/material.dart';
import 'package:supabase_connect/utils/login_button.dart';
import 'package:supabase_connect/view/supabase_login/kakao_login/kakao_login_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppleLogin extends StatelessWidget {
  AppleLogin({super.key});
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Nuridal Class: Apple login',
                style: TextStyle(fontSize: 20))),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              loginButton(
                  text: 'APPLE 로그인',
                  textColor: Colors.white,
                  buttonColor: Colors.black,
                  context: context,
                  svgPath: 'assets/apple_logo.svg',
                  width: 30,
                  height: 30,
                  onPressed: () async {
                    await supabase.auth.signInWithOAuth(OAuthProvider.apple);

                    // Listen to auth state changes in order to detect when ther OAuth login is complete.
                    supabase.auth.onAuthStateChange.listen((data) {
                      final AuthChangeEvent event = data.event;
                      if (event == AuthChangeEvent.signedIn) {
                        debugPrint('데이터 : $data');
                        debugPrint('세션 : ${data.session}');

                        // Do something when user sign in
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                KakaoInfo(session: data.session!)));
                      }
                    });
                  }),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('back'),
              ),
            ])));
  }
}
