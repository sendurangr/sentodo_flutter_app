import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentodo_app/data/database_helper.dart';

import '../models/task.dart';

final provider = ChangeNotifierProvider<TaskProvider>((ref) {
  final taskProvider = TaskProvider();
  taskProvider.loadTasks();
  return taskProvider;
});

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _doneTasks = [];
  List<Task> _undoneTasks = [];

  List<Task> get tasks {
    return [..._tasks];
  }

  List<Task> get doneTasks {
    _doneTasks = _tasks.where((task) => task.isDone).toList();
    return [..._doneTasks];
  }

  List<Task> get undoneTasks {
    _undoneTasks = _tasks.where((task) => !task.isDone).toList();
    return [..._undoneTasks];
  }

  Future<void> loadTasks() async {
    _tasks = await DatabaseHelper().fetchTasks();
    _notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    await DatabaseHelper().deleteTask(id);
    _tasks.removeWhere((task) => task.id == id);
    _notifyListeners();
  }

  Future<void> completeTask(String id) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      _tasks[taskIndex].isDone = true;
      await DatabaseHelper().updateTask(_tasks[taskIndex]);
      _notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await DatabaseHelper().insertTask(task);
    _notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    final taskIndex = _tasks.indexWhere((t) => t.id == task.id);
    if (taskIndex >= 0) {
      _tasks[taskIndex] = task;
      await DatabaseHelper().updateTask(task);
      _notifyListeners();
    }
  }

  Future<void> removeTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await DatabaseHelper().deleteTask(id);
    _notifyListeners();
  }

  Future<void> updateIsDone(String id, bool isDone) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      _tasks[taskIndex].isDone = isDone;
      await DatabaseHelper().updateTask(_tasks[taskIndex]);
      _notifyListeners();
    }
  }

  Future<void> toggleTaskDone(String id) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      _tasks[taskIndex].isDone = !_tasks[taskIndex].isDone;
      _notifyListeners();
    }
  }

  void _notifyListeners() {
    updateTaskStatus();
    notifyListeners();
  }

  void updateTaskStatus() async {
    _doneTasks = _tasks.where((task) => task.isDone).toList();
    _undoneTasks = _tasks.where((task) => !task.isDone).toList();
  }

  Future<void> deleteAllTasks() async {
    await DatabaseHelper().deleteAllTasks();
    _tasks.clear();
    _notifyListeners();
  }
}
