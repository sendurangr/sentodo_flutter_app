import 'package:flutter/material.dart';

import '../../services/app_utils.dart';

class PriorityChip extends StatelessWidget {
  final int priority;

  const PriorityChip({
    super.key,
    required this.priority,
  });

  Color getPriorityBackgroundColor(int priority, BuildContext context) {
    switch (priority) {
      case 0:
        return Theme.of(context).colorScheme.secondaryFixed;
      case 1:
        return Theme.of(context).colorScheme.primaryFixed;
      case 2:
        return Theme.of(context).colorScheme.primary;
      default:
        return Colors.green;
    }
  }

  Color getPriorityTextColor(int priority, BuildContext context) {
    switch (priority) {
      case 0:
        return Theme.of(context).colorScheme.onSecondaryFixed;
      case 1:
        return Theme.of(context).colorScheme.onPrimaryFixed;
      case 2:
        return Theme.of(context).colorScheme.onPrimary;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      decoration: BoxDecoration(
        color: getPriorityBackgroundColor(priority, context),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Center(
        child: Text(
          AppUtils.taskPriorityToString(priority),
          style: TextStyle(
            fontSize: 11,
            color: getPriorityTextColor(priority, context),
          ),
        ),
      ),
    );
  }
}

class IsDoneChip extends StatelessWidget {
  final bool isDone;

  const IsDoneChip({super.key, required this.isDone});

  Color getIsDoneBackgroundColor(bool isDone, BuildContext context) {
    return isDone
        ? Theme.of(context).colorScheme.primaryFixedDim
        : Theme.of(context).colorScheme.errorContainer;
  }

  Color getIsDoneTextColor(bool isDone, BuildContext context) {
    return isDone
        ? Theme.of(context).colorScheme.onPrimaryFixedVariant
        : Theme.of(context).colorScheme.onErrorContainer;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      decoration: BoxDecoration(
        color: getIsDoneBackgroundColor(isDone, context),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Center(
        child: Text(
          AppUtils.doneNotDoneString(isDone),
          style: TextStyle(
            fontSize: 11,
            color: getIsDoneTextColor(isDone, context),
          ),
        ),
      ),
    );
  }
}
