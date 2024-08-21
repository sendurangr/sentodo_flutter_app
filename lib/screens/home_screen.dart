import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(provider).tasks;
    final doneTasks = ref.watch(provider).doneTasks;
    final undoneTasks = ref.watch(provider).undoneTasks;

    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'All',
                icon: Icon(Icons.home),
              ),
              Tab(
                text: 'Not Done',
                icon: Icon(Icons.report),
              ),
              Tab(
                text: 'Done',
                icon: Icon(Icons.task_alt),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Delete all tasks?'),
                    content: const Text(
                        'This action cannot be undone. And all tasks will be deleted permanently.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(provider.notifier).deleteAllTasks();
                          Navigator.pop(context, 'OK');
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
          scrolledUnderElevation: 10,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('SenTodo'),
        ),
        body: TabBarView(
          children: <Widget>[
            bodyWidget(tasks, context),
            bodyWidget(undoneTasks, context),
            bodyWidget(doneTasks, context),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Add Task'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const AddTaskScreen();
            }));
          },
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}

Widget bodyWidget(List<Task> tasks, BuildContext context) {
  return tasks.isEmpty
      ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sentiment_dissatisfied),
              Text('No tasks yet'),
            ],
          ),
        )
      : Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
          ),
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (ctx, index) {
              final task = tasks[index];
              return CardTile(task: task);
            },
          ),
        );
}