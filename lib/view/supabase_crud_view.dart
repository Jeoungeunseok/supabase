import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseCRUDView extends StatelessWidget {
  SupabaseCRUDView({super.key});

  final supabase = Supabase.instance.client;
  final TextEditingController todoTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase CRUD'),
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
                                    .then((value) {
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
