import 'package:ekilisync/starter_models/todo_model.g.dart';

/// * ---------- Auto Generated Code ---------- * ///

class TodoModel extends TodoModelGen {
	TodoModel({
		int? id,
		String? userId,
		String? title,
		String? description,
		bool? is_done = false
	}): super(id, userId, title, description, is_done);

	factory TodoModel.fromDatabase(Map<String, dynamic> map) {
		return TodoModelGen.fromDatabase(map);
	}

	factory TodoModel.fromJson(Map<String, dynamic> map) {
		return TodoModelGen.fromJson(map);
	}

}