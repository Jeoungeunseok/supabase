import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseSubscribeView extends StatefulWidget {
  const SupabaseSubscribeView({super.key});

  @override
  State<SupabaseSubscribeView> createState() =>
      _SupabaseSubscribeViewSetState();
}

class _SupabaseSubscribeViewSetState extends State<SupabaseSubscribeView> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> todoList = [];
  final TextEditingController todoTextController = TextEditingController();
  String? test;

  @override
  void initState() {
    todoSubscribe();
    super.initState();
  }

  @override
  void dispose() {
    todoTextController.dispose();
    super.dispose();
  }

  void todoSubscribe() {
    supabase
        .channel('todos')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'todo',
            callback: eventHandler)
        .subscribe();
  }

  void eventHandler(payload) {
    debugPrint('payload:${payload.toString()}');
    if (payload.eventType == PostgresChangeEvent.insert) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(' ${payload.newRecord['todo']}이 추가되었습니다')));
    } else if ((payload.eventType == PostgresChangeEvent.update)) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(' ${payload.newRecord['todo']}로 수정되었습니다')));
    } else if ((payload.eventType == PostgresChangeEvent.delete)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('삭제되었습니다')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Subscription'),
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: IconButton(
                          onPressed: () async {
                            actionTodoDialog(
                              context: context,
                              title: 'Edit a todo',
                              hintText: todos[index]['todo'],
                              textController: todoTextController,
                              onPressed: () async {
                                await supabase
                                    .from('todo')
                                    .update({'todo': todoTextController.text})
                                    .eq('id', todos[index]['id'])
                                    .then((value) async {
                                      todoTextController.clear();
                                      Navigator.pop(context);
                                    });
                              },
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                      Flexible(
                        child: IconButton(
                          onPressed: () async {
                            await supabase
                                .from('todo')
                                .delete()
                                .eq('id', todos[index]['id']);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          actionTodoDialog(
              context: context,
              title: 'Add a todo',
              hintText: 'new todo',
              textController: todoTextController,
              onPressed: () async {
                await supabase
                    .from('todo')
                    .insert({'todo': todoTextController.text}).then((value) {
                  todoTextController.clear();
                  Navigator.pop(context);
                });
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> actionTodoDialog({
    required BuildContext context,
    required String title,
    required String hintText,
    required TextEditingController textController,
    required void Function() onPressed,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(title),
              content: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: hintText,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: onPressed,
                  child: const Text('OK'),
                )
              ]);
        });
  }
}
