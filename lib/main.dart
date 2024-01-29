import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:supabase_connect/view/supabase_login/login_integration.dart';
import 'package:supabase_connect/view/supabase_login/old/apple_login/supabase_apple_login.dart';
import 'package:supabase_connect/view/supabase_login/old/kakao_login/supabase_kakao_login.dart';
import 'package:supabase_connect/view/supabase_login/old/old_login.dart';
import 'package:supabase_connect/view/supabase_login/supabase_login_list.dart';
import 'package:supabase_connect/view/supabase_crud_view.dart';
import 'package:supabase_connect/view/supabase_realTime_view.dart';
import 'package:supabase_connect/view/supabase_subscribe_to_channel_view.dart';
import 'package:supabase_connect/view/supabase_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.get("SERVER_PROJECT_URL"),
    anonKey: dotenv.get("SERVER_API_KEY"),
  );

  KakaoSdk.init(
    nativeAppKey: dotenv.get("KAKAO_NATIVE_APP_KEY"),
    javaScriptAppKey: dotenv.get("KAKAO_JAVASCRIPT_APP_KEY"),
  );

  runApp(const SupabaseApp());
}

class SupabaseApp extends StatelessWidget {
  const SupabaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nuridal Class',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeState(),
        '/supabase_test': (context) => const SupabaseTest(),
        '/supabase_view': (context) => const SupabaseView(),
        '/supabase_realTime_view': (context) => SupabaseRealtimeView(),
        '/supabase_crud_view': (context) => SupabaseCRUDView(),
        '/supabase_subscription_view': (context) =>
            const SupabaseSubscribeView(),
        '/supabase_login_list': (context) => const SupabaseLogin(),
        '/supabase_login_integration': (context) => const LoginIntegration(),
        '/supabase_login_old': (context) => const SupabaseOldLogin(),
        '/supabase_kakao_login': (context) => KaKaoLogin(),
        '/supabase_apple_login': (context) => AppleLogin(),
      },
    );
  }
}

class HomeState extends StatefulWidget {
  const HomeState({super.key});

  @override
  State<HomeState> createState() => _HomesetStateState();
}

class _HomesetStateState extends State<HomeState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Nuridal Class: Supabase',
                style: TextStyle(fontSize: 20))),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/supabase_test');
                },
                child: const Text('supabase_test'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/supabase_login_list');
                },
                child: const Text('supabase_login_list'),
              ),
            ])));
  }
}

class SupabaseTest extends StatefulWidget {
  const SupabaseTest({super.key});

  @override
  State<SupabaseTest> createState() => _SupabaseTestState();
}

class _SupabaseTestState extends State<SupabaseTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Nuridal Class: Supabase_test',
                style: TextStyle(fontSize: 20))),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/supabase_view');
                },
                child: const Text('supabase_view'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/supabase_realTime_view');
                },
                child: const Text('supabase_realTime_view'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/supabase_crud_view');
                },
                child: const Text('supabase_crud_view'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/supabase_subscription_view');
                },
                child: const Text('supabase_subscription_view'),
              ),
            ])));
  }
}
