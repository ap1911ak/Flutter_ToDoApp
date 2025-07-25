import '../../domain/repositories/todo_repository.dart';
import '../../domain/entities/todo.dart';
import '../../data/datasources/todo_local_data_source.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl(this.localDataSource);

  @override
  Future<void> addTodo(Todo todo) async {
    await localDataSource.insertTodo(todo);
  }

  @override
  Future<void> deleteTodo(int id) async {
    await localDataSource.deleteTodo(id);
  }

  @override
  Future<List<Todo>> getTodos() async {
    return await localDataSource.getTodos();
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    await localDataSource.updateTodo(todo);
  }
}
