import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_connect/utils/login_button.dart';
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
                    try {
                      AuthResponse response = await signInWithApple();
                      if (response.user != null) {
                        final snackBarText = SnackBar(
                            content: Text('${response.user?.email}님 반갑습니다'));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBarText);
                      }
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
            ])));
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
