import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Api Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade900),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter API Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List collectionOfProducts = [];

  @override
  void initState() {
    super.initState();
    getAllTodo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: collectionOfProducts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(collectionOfProducts[index]['title'] ?? "null"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await createNewTodo();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> getAllTodo() async {
    var url = Uri.https("be-todo-runtime-db.onrender.com", "/todos");

    // Get all products
    var response = await http.get(url);

    // print all products if api call is successfull
    print(response.body.runtimeType);

    var resultBody = jsonDecode(response.body);
    setState(() {
      collectionOfProducts = resultBody;
    });
    print(resultBody[0]['id'].runtimeType);
  }

  int ind = 1;
  Future<void> createNewTodo() async {
    try {
      var url = Uri.https("be-todo-runtime-db.onrender.com", "/todos");

      var data = {
        "title": "Created new from mobile $ind ",
        "description": "Hi there this is my first note from mobile!"
      };
      var dataToSend = jsonEncode(data);
      print(dataToSend);
      await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: dataToSend,
      );

      ind++;

      await getAllTodo();
    } catch (e) {
      print(e);
    }
  }
}
