import 'package:flutter/material.dart';

class SupabaseViewState extends StatefulWidget {
  const SupabaseViewState({super.key});

  @override
  State<SupabaseViewState> createState() => _SupabaseViewSetState();
}

class _SupabaseViewSetState extends State<SupabaseViewState> {
  List<String> imageList = [];

  @override
  void initState() {
    super.initState();
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
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  itemCount: imageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: Image.asset(imageList[index]),
                    );
                  },
                ),
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
