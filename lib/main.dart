import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/add_task_screen.dart';
import 'providers/task_provider.dart';

void main() {
  runApp(MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        title: 'Todo App',
        initialRoute: '/',
        theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
        routes: {
          '/': (ctx) => HomeScreen(),
          '/add-task': (ctx) => AddTaskScreen(),
          // Add more routes if needed
        },
      ),
    );
  }
}