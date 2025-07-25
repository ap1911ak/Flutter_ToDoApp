import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/todo.dart';
import '../providers/todo_provider.dart';
import 'package:intl/intl.dart';

class AddEditTodoScreen extends StatefulWidget {
  final Todo? todo; // Nullable for adding, not null for editing
  const AddEditTodoScreen({super.key, this.todo});

  @override
  State<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late DateTime _selectedDueDate;
  late String _selectedRepeatType;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _selectedDueDate = widget.todo?.dueDate ?? DateTime.now();
    _selectedRepeatType = widget.todo?.repeatType ?? 'None';
    _selectedCategory = widget.todo?.category ?? 'General';
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newTodo = Todo(
        id: widget.todo?.id, // ID will be null for new, existing for edit
        title: _titleController.text,
        dueDate: _selectedDueDate,
        repeatType: _selectedRepeatType,
        category: _selectedCategory,
        isCompleted: widget.todo?.isCompleted ?? false,
      );

      if (widget.todo == null) {
        // Adding new todo
        Provider.of<TodoProvider>(context, listen: false).addTodo(newTodo);
      } else {
        // Editing existing todo
        Provider.of<TodoProvider>(context, listen: false).updateTodo(newTodo);
      }
      Navigator.pop(context);
    }
  }

  void _deleteTodo() {
    if (widget.todo != null && widget.todo!.id != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this To-Do?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<TodoProvider>(context, listen: false)
                    .deleteTodo(widget.todo!.id!);
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Pop back to home screen
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'Add New To-Do' : 'Edit To-Do'),
        actions: [
          if (widget.todo != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteTodo,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  'Due Date: ${DateFormat('MMM dd, yyyy').format(_selectedDueDate)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRepeatType,
                decoration: const InputDecoration(labelText: 'Repeat Type'),
                items: <String>['None', 'Weekly', 'Monthly', 'Yearly']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRepeatType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: <String>['General', 'Finance', 'Work', 'Study']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveTodo,
                child: Text(widget.todo == null ? 'Add To-Do' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
