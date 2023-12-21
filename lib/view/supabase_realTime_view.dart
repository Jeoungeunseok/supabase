import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRealtimeView extends StatelessWidget {
  SupabaseRealtimeView({super.key});

  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Realtime'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: supabase.from('todo').stream(primaryKey: ['id']),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('데이터가 없습니다'),
                );
              }
            }
            final todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    Icons.check_circle,
                    color: todos[index]['check'] ?? true
                        ? Colors.green
                        : Colors.grey,
                    size: 20,
                  ),
                  title: Text(todos[index]['todo'],
                      style: const TextStyle(
                        fontSize: 20,
                      )),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
