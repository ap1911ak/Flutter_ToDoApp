class Todo {
  final int? id; // nullable for new todo
  final String title;
  final DateTime dueDate;
  final String repeatType; // 'None', 'Weekly', 'Monthly', 'Yearly'
  final String category; // 'Finance', 'Work', 'Study', 'General'
  final bool isCompleted;

  Todo({
    this.id,
    required this.title,
    required this.dueDate,
    required this.repeatType,
    required this.category,
    this.isCompleted = false,
  });

  // Methods for copyWith and toMap (for database operations)
  Todo copyWith({
    int? id,
    String? title,
    DateTime? dueDate,
    String? repeatType,
    String? category,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      repeatType: repeatType ?? this.repeatType,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate.toIso8601String(), // Store as string for SQLite
      'repeatType': repeatType,
      'category': category,
      'isCompleted': isCompleted ? 1 : 0, // SQLite stores bool as int
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      dueDate: DateTime.parse(map['dueDate']),
      repeatType: map['repeatType'],
      category: map['category'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
