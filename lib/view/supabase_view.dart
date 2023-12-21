import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseView extends StatefulWidget {
  const SupabaseView({super.key});

  @override
  State<SupabaseView> createState() => _SupabaseViewSetState();
}

class _SupabaseViewSetState extends State<SupabaseView> {
  List<dynamic> dataList = [];
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    readTodo();
  }

  void readTodo() async {
    var response = await supabase.from("todo").select();
    if (response.isNotEmpty) {
      setState(() {
        dataList = response;
      });
    } else {
      setState(() {
        dataList = [
          {"error": "데이터를 불러오는 데 실패했습니다"}
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Nuridal Class: Supabase Connect',
                style: TextStyle(fontSize: 20))),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              SizedBox(
                height: 300,
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: dataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return dataList[index].containsKey('error')
                          ? Center(child: Text(dataList[index]['error']))
                          : Table(
                              children: [
                                TableRow(children: [
                                  Text('ID: ${dataList[index]['id']}'),
                                  Text(
                                      'Created At: ${dataList[index]['created_at'].split('T')[0]}'),
                                ]),
                                TableRow(children: [
                                  Text('Todo: ${dataList[index]['todo']}'),
                                  Text('Check: ${dataList[index]['check']}'),
                                ]),
                              ],
                            );
                    }),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('back_page'),
              )
            ])));
  }
}
