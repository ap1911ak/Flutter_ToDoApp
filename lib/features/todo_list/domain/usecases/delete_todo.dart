import '../repositories/todo_repository.dart';

class DeleteTodo {
  final TodoRepository repository;
  DeleteTodo(this.repository);

  Future<void> call(int id) async {
    await repository.deleteTodo(id);
  }
}
