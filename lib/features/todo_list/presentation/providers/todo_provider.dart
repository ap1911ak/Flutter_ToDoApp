import 'package:flutter/material.dart';
import '../../domain/entities/todo.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/update_todo.dart';

class TodoProvider extends ChangeNotifier {
  final GetTodos getTodosUseCase;
  final AddTodo addTodoUseCase;
  final UpdateTodo updateTodoUseCase;
  final DeleteTodo deleteTodoUseCase;

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  String _currentView = 'Daily'; // Daily, Weekly, Monthly, Yearly
  String get currentView => _currentView;

  String _selectedCategory = 'All'; // All, Finance, Work, Study, General
  String get selectedCategory => _selectedCategory;

  TodoProvider({
    required this.getTodosUseCase,
    required this.addTodoUseCase,
    required this.updateTodoUseCase,
    required this.deleteTodoUseCase,
  });

  Future<void> fetchTodos() async {
    _todos = await getTodosUseCase.call();
    // TODO: Implement filtering logic based on currentView and selectedCategory
    // For now, just display all fetched todos.
    notifyListeners();
  }

  Future<void> addTodo(Todo todo) async {
    await addTodoUseCase.call(todo);
    await fetchTodos(); // Refresh list after adding
  }

  Future<void> updateTodo(Todo todo) async {
    await updateTodoUseCase.call(todo);
    await fetchTodos(); // Refresh list after updating
  }

  Future<void> deleteTodo(int id) async {
    await deleteTodoUseCase.call(id);
    await fetchTodos(); // Refresh list after deleting
  }

  void toggleTodoStatus(Todo todo) async {
    final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
    await updateTodo(updatedTodo);
  }

  void changeView(String view) {
    _currentView = view;
    fetchTodos(); // Refetch/filter based on new view
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    fetchTodos(); // Refetch/filter based on new category
  }
}
