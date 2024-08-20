import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(provider).tasks;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Delete all tasks?'),
                  content: const Text('This action cannot be undone.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: ()  {
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
        title: const Text('Todo List'),
      ),
      body: tasks.isEmpty
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
            ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Task'),
        onPressed: () {
          Navigator.of(context).pushNamed('/add-task');
        },
        icon: const Icon(Icons.add),
      ),
    );
  }
}