import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentodo_app/models/task.dart';

import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {

  AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskController = TextEditingController();

  final TextEditingController _subtitleController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  void _addTask(BuildContext context) {
    final taskText = _taskController.text;
    if (taskText.isNotEmpty) {
      Provider.of<TaskProvider>(context, listen: false).addTask(
        Task(
          id: DateTime.now().toString(),
          title: taskText,
          isDone: false,
          subtitle: _subtitleController.text,
          targetDate: DateTime.now(),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(labelText: 'Task'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _subtitleController,
              decoration: const InputDecoration(labelText: 'Subtitle'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickDate(context),
              child: const Text('Pick Target Date'),
            ),
            const SizedBox(height: 20),
            Text('Selected Date: ${_selectedDate.toIso8601String()}'),
            ElevatedButton(
              onPressed: () => _addTask(context),
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
