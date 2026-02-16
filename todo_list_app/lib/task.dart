class Task {
  String id;
  String title;
  String description;
  String priority;
  DateTime? dueDate;
  bool isCompleted;
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = 'Medium',
    this.dueDate,
    this.isCompleted = false,
    required this.createdAt,
  });

  //convert Task to JSON for storage

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // create task from JSON

  factory Task.formJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      priority: json['priority'] ?? 'Medium',
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
