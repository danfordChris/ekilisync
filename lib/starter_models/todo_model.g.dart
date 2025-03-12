import 'package:ekilisync/models/todo_model.dart';
import 'package:ipf_flutter_starter_pack/bases.dart';

/// * ---------- Auto Generated Code ---------- * ///

class TodoModelGen extends BaseDatabaseModel {
	int? _id;
	String? _userId;
	String? _title;
	String? _description;
	bool? _is_done;
	
	TodoModelGen(this._id, this._userId, this._title, this._description, this._is_done, );

	int? get id => _id;
	String? get userId => _userId;
	String? get title => _title;
	String? get description => _description;
	bool? get is_done => _is_done;
	
	set id(int? id) => this._id = id;
	set userId(String? userId) => this._userId = userId;
	set title(String? title) => this._title = title;
	set description(String? description) => this._description = description;
	set is_done(bool? is_done) => this._is_done = is_done;
	

	static TodoModel fromJson(Map<String, dynamic> map) {
		return TodoModel(id: BaseModel.castToInt(map['id']), userId: map['userId'], title: map['title'], description: map['description'], is_done: BaseModel.castToBool(map['is_done']), );
	}

	static TodoModel fromDatabase(Map<String, dynamic> map) {
		return TodoModel(id: BaseModel.castToInt(map['id']), userId: map['user_id'], title: map['title'], description: map['description'], is_done: BaseModel.castToBool(map['is__done']), );
	}

	@override
	String get tableName => "todos";

	@override
	Map<String, dynamic> get toMap {
		return { "id": id, "user_id": userId, "title": title, "description": description, "is__done": is_done, };
	}

	Map<String, dynamic> get toJson {
		return { "id": id, "userId": userId, "title": title, "description": description, "is_done": is_done, };
	}

	@override
	Map<String, String> get toSchema {
		return { "id": "INTEGER PRIMARY KEY", "user_id": "TEXT", "title": "TEXT", "description": "TEXT", "is__done": "INTEGER", };
	}

	TodoModel merge(TodoModel model) {
		return TodoModel(
			id: model.id ?? this._id,
			userId: model.userId ?? this._userId,
			title: model.title ?? this._title,
			description: model.description ?? this._description,
			is_done: model.is_done ?? this._is_done
		);
	}

	@override
	Map<String, Map<String, String>>? get dataRelation => null;

}