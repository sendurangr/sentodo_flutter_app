class Task {
  final String id;
  final String title;
  final String subtitle;
  bool isDone;
  final DateTime targetDate;
  final DateTime createdDate;
  int priority;

  Task({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.isDone,
    required this.targetDate,
    required this.createdDate,
    this.priority = 0,
  });

  // Convert a Task into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'isDone': isDone ? 1 : 0, // SQLite does not support boolean,
      'targetDate': targetDate.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'priority': priority
    };
  }

  // A method that retrieves a Task from a Map.
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        id: map['id'],
        title: map['title'],
        subtitle: map['subtitle'],
        isDone: map['isDone'] == 1,
        targetDate: DateTime.parse(map['targetDate']),
        createdDate: DateTime.parse(map['createdDate']),
        priority: map['priority']);
  }
}
