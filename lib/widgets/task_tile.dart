import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentodo_app/models/task.dart';
import 'package:sentodo_app/screens/add_task_screen.dart';
import 'package:sentodo_app/services/app_utils.dart';
import 'package:sentodo_app/widgets/title_tile/chips.dart';

import '../providers/task_provider.dart';

class CardTile extends ConsumerWidget {
  final Task task;

  CardTile({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PersistentBottomSheetController? _bottomSheetController;

    List<Widget> buttonList = <Widget>[
      IconButton(
          onPressed: () {
            ref.read(provider.notifier).deleteTask(task.id);
            _bottomSheetController?.close();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🚀 Task deleted'),
              ),
            );
          },
          icon: const Icon(Icons.delete_outline)),
      IconButton(
        onPressed: () {
          ref.read(provider.notifier).toggleTaskDone(task.id);
          _bottomSheetController?.close();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(task.isDone ? 'Moved to done' : 'Move to not done'),
            ),
          );
        },
        icon: task.isDone ? const Icon(Icons.report) : const Icon(Icons.check),
      ),
      IconButton(
          onPressed: () {
            _bottomSheetController?.close();
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddTaskScreen(task: task);
            }));
          },
          icon: const Icon(Icons.edit)),
    ];
    List<Text> labelList = <Text>[
      const Text('Trash'),
      Text(task.isDone ? 'Not Done' : 'Done'),
      const Text('Edit'),
    ];

    buttonList = List.generate(
        buttonList.length,
        (index) => Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buttonList[index],
                  labelList[index],
                ],
              ),
            ));

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      task.title ?? '',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    IconButton(
                      onPressed: () {
                        _bottomSheetController = showBottomSheet(
                          showDragHandle: true,
                          context: context,
                          constraints: const BoxConstraints(maxWidth: 640),
                          builder: (context) {
                            return SizedBox(
                              height: 120,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0),
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: buttonList,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
                Text(task.subtitle ?? '',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14,
                    )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PriorityChip(priority: task.priority),
                    const SizedBox(
                      width: 10,
                    ),
                    IsDoneChip(isDone: task.isDone),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              verticalDirection: VerticalDirection.up,
              children: [
                Row(
                  children: [
                    const Icon(Icons.more_time, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      AppUtils.formatDateMMMd(task.createdDate),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.share_arrival_time_outlined, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      AppUtils.formatDateMMMd(task.targetDate),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
