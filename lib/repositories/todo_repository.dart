import 'package:ekilisync/repositories/base_repository.dart';
import 'package:ekilisync/models/todo_model.dart';

/// * ---------- Auto Generated Code ---------- * ///

class TodoRepository extends BaseRepository<TodoModel> {
  TodoRepository._() : super(TodoModel(), (map) => TodoModel.fromDatabase(map));
  static final TodoRepository _instance = TodoRepository._();
  static TodoRepository get instance => _instance;

  Future<TodoModel?> updateTodo(model) async {
    return await update(model);
  }

  Future <TodoModel?> deleteAll() async{
    return await deleteAll( );
  }

  Future<TodoModel?> deleteTodo(int? id) async{
    return await findById(id);
  }
}
