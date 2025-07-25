import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_list_item.dart';
import 'add_edit_todo_screen.dart'; // Create this later

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch todos when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoProvider>(context, listen: false).fetchTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My To-Do List'),
        actions: [
          // View Toggle Button (Daily/Weekly/Monthly/Yearly)
          Consumer<TodoProvider>(
            builder: (context, todoProvider, child) {
              return DropdownButton<String>(
                value: todoProvider.currentView,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    todoProvider.changeView(newValue);
                  }
                },
                items: <String>['Daily', 'Weekly', 'Monthly', 'Yearly']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              );
            },
          ),
          // Category Filter Button
          Consumer<TodoProvider>(
            builder: (context, todoProvider, child) {
              return DropdownButton<String>(
                value: todoProvider.selectedCategory,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    todoProvider.filterByCategory(newValue);
                  }
                },
                items: <String>['All', 'Finance', 'Work', 'Study', 'General']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          if (todoProvider.todos.isEmpty) {
            return const Center(child: Text('No To-Dos yet! Add one!'));
          }
          return ListView.builder(
            itemCount: todoProvider.todos.length,
            itemBuilder: (context, index) {
              final todo = todoProvider.todos[index];
              return TodoListItem(
                todo: todo,
                onToggle: () => todoProvider.toggleTodoStatus(todo),
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditTodoScreen(todo: todo),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditTodoScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
