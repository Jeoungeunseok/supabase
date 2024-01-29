import 'package:flutter/material.dart';

class SupabaseOldLogin extends StatelessWidget {
  const SupabaseOldLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Nuridal Class: Supabase Old Login',
                style: TextStyle(fontSize: 20))),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/supabase_kakao_login');
                },
                child: const Text('kakao'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/supabase_apple_login');
                },
                child: const Text('apple'),
              ),
            ])));
  }
}
