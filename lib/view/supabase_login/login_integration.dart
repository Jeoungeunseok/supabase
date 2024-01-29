import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_connect/utils/login_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginIntegration extends StatefulWidget {
  const LoginIntegration({super.key});
  @override
  State<LoginIntegration> createState() => _LoginIntegrationState();
}

class _LoginIntegrationState extends State<LoginIntegration> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Nuridal Class: Login Integration',
              style: TextStyle(fontSize: 20))),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
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
                      final snackBarText = SnackBar(
                          content: Text(
                              '${data.session?.user.userMetadata!['email']}님 반갑습니다'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBarText);
                    }
                  });
                }),
            loginButton(
                text: 'APPLE 로그인',
                textColor: Colors.white,
                buttonColor: Colors.black,
                context: context,
                svgPath: 'assets/apple_logo.svg',
                width: 30,
                height: 30,
                onPressed: () async {
                  try {
                    AuthResponse response = await signInWithApple();
                    if (response.user != null) {
                      final snackBarText = SnackBar(
                          content: Text('${response.user?.email}님 반갑습니다'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBarText);
                    }
                  } catch (e) {
                    debugPrint('$e');
                  }
                }),
            loginButton(
                text: 'GOOGLE 로그인',
                textColor: Colors.black,
                buttonColor: Colors.white,
                context: context,
                svgPath: 'assets/google_logo.svg',
                width: 30,
                height: 30,
                onPressed: () async {
                  try {
                    await supabase.auth.signInWithOAuth(OAuthProvider.google);
                    supabase.auth.onAuthStateChange.listen((data) {
                      final AuthChangeEvent event = data.event;
                      if (event == AuthChangeEvent.signedIn) {
                        debugPrint('데이터 : $data');
                        debugPrint('세션 : ${data.session}');
                        final snackBarText = SnackBar(
                            content: Text(
                                '${data.session?.user.userMetadata!['full_name']}님 반갑습니다'));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBarText);
                      }
                    });
                  } catch (e) {
                    debugPrint('$e');
                  }
                }),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('back'),
            ),
          ])),
    );
  }

  /// Performs Apple sign in on iOS or macOS
  Future<AuthResponse> signInWithApple() async {
    final rawNonce = supabase.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
          'Could not find ID Token from generated credential.');
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }
}
