import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Make sure you have intl in pubspec.yaml
import '../../domain/entities/todo.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  const TodoListItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (bool? newValue) {
            onToggle();
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          'Due: ${DateFormat('MMM dd, yyyy').format(todo.dueDate)} - ${todo.category} (${todo.repeatType})',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
        ),
      ),
    );
  }
}
