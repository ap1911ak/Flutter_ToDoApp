import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/todo_list/data/datasources/todo_local_data_source.dart';
import 'features/todo_list/data/repositories/todo_repository_impl.dart';
import 'features/todo_list/domain/usecases/add_todo.dart';
import 'features/todo_list/domain/usecases/delete_todo.dart';
import 'features/todo_list/domain/usecases/get_todos.dart';
import 'features/todo_list/domain/usecases/update_todo.dart';
import 'features/todo_list/presentation/providers/todo_provider.dart';
import 'features/todo_list/presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize data source and repository
    final todoLocalDataSource = TodoLocalDataSource();
    final todoRepository = TodoRepositoryImpl(todoLocalDataSource);

    // Initialize use cases
    final getTodos = GetTodos(todoRepository);
    final addTodo = AddTodo(todoRepository);
    final updateTodo = UpdateTodo(todoRepository);
    final deleteTodo = DeleteTodo(todoRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TodoProvider(
            getTodosUseCase: getTodos,
            addTodoUseCase: addTodo,
            updateTodoUseCase: updateTodo,
            deleteTodoUseCase: deleteTodo,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'My To-Do App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
