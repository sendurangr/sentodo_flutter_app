import 'package:flutter/foundation.dart';
import 'package:sentodo_app/data/database_helper.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks {
    return [..._tasks];
  }

  Future<void> loadTasks() async {
    _tasks = await DatabaseHelper().fetchTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await DatabaseHelper().insertTask(task);
    notifyListeners();
  }

  Future<void> removeTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await DatabaseHelper().deleteTask(id);
    notifyListeners();
  }

  Future<void> updateIsDone(String id, bool isDone) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      _tasks[taskIndex].isDone = isDone;
      await DatabaseHelper().updateTask(_tasks[taskIndex]);
      notifyListeners();
    }
  }
}
