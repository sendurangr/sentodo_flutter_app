import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/add_task_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Todo App',
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
      ),
        routes: {
          '/': (ctx) => const HomeScreen(),
          '/add-task': (ctx) => const AddTaskScreen(),
          '/edit-task': (ctx) => const AddTaskScreen(),
          // Add more routes if needed
        },
      ),
    );
  }
}