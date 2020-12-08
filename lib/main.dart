import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/todo_list.dart';
import 'package:todolist/todo_list_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoListModel(),
      child: MaterialApp(
        title: 'DedoList',
        home: TodoList(),
      ),
    );
  }
}
