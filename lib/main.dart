import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_connect/view/supabase_crud_view.dart';
import 'package:supabase_connect/view/supabase_realTime_view.dart';
import 'package:supabase_connect/view/supabase_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.get("PROJECT_URL"),
    anonKey: dotenv.get("PROJECT_API_KEY"),
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
        '/supabase_view': (context) => const SupabaseView(),
        '/supabase_realTime_view': (context) => SupabaseRealtimeView(),
        '/supabase_crud_view': (context) => SupabaseCRUDView(),
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
            ])));
  }
}
