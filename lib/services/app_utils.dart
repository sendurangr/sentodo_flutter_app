import 'package:intl/intl.dart';

class AppUtils {
  static String formatDateFull(DateTime dateTime) {
    return DateFormat.yMd().format(DateTime.now());
  }

  static String formatDateMMMd(DateTime dateTime) {
    return '${DateFormat.MMMd().format(dateTime).toUpperCase()} at ${DateFormat.jm().format(dateTime).toUpperCase()}';
  }

  static String doneNotDoneString(bool isDone) {
    return isDone ? 'Done' : 'Not Done';
  }

  static String taskPriorityToString(int priority) {
    switch (priority) {
      case 0:
        return 'Low';
      case 1:
        return 'Medium';
      case 2:
        return 'High';
      default:
        return 'Low';
    }
  }
}
