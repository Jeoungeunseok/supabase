import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:supabase_connect/utils/login_button.dart';
import 'package:supabase_connect/view/supabase_login/old/kakao_login/kakao_login_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KaKaoLogin extends StatelessWidget {
  KaKaoLogin({super.key});
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Nuridal Class: Kakao login',
                style: TextStyle(fontSize: 20))),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  hashKeyCheck().then((value) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Kakao Hash Key'),
                              content: Text('$value'),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('back'),
                                ),
                              ],
                            ));
                  });
                },
                child: const Text('Hash Key check'),
              ),
              loginButton(
                  text: '카카오 로그인',
                  textColor: Colors.black,
                  buttonColor: Colors.yellow,
                  context: context,
                  svgPath: 'assets/kakao_logo.svg',
                  width: 15,
                  height: 15,
                  onPressed: () async {
                    await supabase.auth.signInWithOAuth(OAuthProvider.kakao);

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

Future hashKeyCheck() async {
  var hash = await KakaoSdk.origin;
  if (hash.isNotEmpty) {
    return "해시 키 존재";
  } else {
    return "해시 키 없음";
  }
}
