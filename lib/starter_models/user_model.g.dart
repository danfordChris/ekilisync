import 'package:ekilisync/models/user_model.dart';
import 'package:ipf_flutter_starter_pack/bases.dart';

/// * ---------- Auto Generated Code ---------- * ///

class UserModelGen extends BaseDatabaseModel {
	int? _id;
	String? _userId;
	String? _name;
	String? _email;
	String? _password;
	
	UserModelGen(this._id, this._userId, this._name, this._email, this._password, );

	int? get id => _id;
	String? get userId => _userId;
	String? get name => _name;
	String? get email => _email;
	String? get password => _password;
	
	set id(int? id) => this._id = id;
	set userId(String? userId) => this._userId = userId;
	set name(String? name) => this._name = name;
	set email(String? email) => this._email = email;
	set password(String? password) => this._password = password;
	

	static UserModel fromJson(Map<String, dynamic> map) {
		return UserModel(id: BaseModel.castToInt(map['id']), userId: map['userId'], name: map['name'], email: map['email'], password: map['password'], );
	}

	static UserModel fromDatabase(Map<String, dynamic> map) {
		return UserModel(id: BaseModel.castToInt(map['id']), userId: map['user_id'], name: map['name'], email: map['email'], password: map['password'], );
	}

	@override
	String get tableName => "users";

	@override
	Map<String, dynamic> get toMap {
		return { "id": id, "user_id": userId, "name": name, "email": email, "password": password, };
	}

	Map<String, dynamic> get toJson {
		return { "id": id, "userId": userId, "name": name, "email": email, "password": password, };
	}

	@override
	Map<String, String> get toSchema {
		return { "id": "INTEGER PRIMARY KEY", "user_id": "TEXT", "name": "TEXT", "email": "TEXT", "password": "TEXT", };
	}

	UserModel merge(UserModel model) {
		return UserModel(
			id: model.id ?? this._id,
			userId: model.userId ?? this._userId,
			name: model.name ?? this._name,
			email: model.email ?? this._email,
			password: model.password ?? this._password
		);
	}

	@override
	Map<String, Map<String, String>>? get dataRelation => null;

}