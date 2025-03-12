import 'package:ekilisync/starter_models/user_model.g.dart';

/// * ---------- Auto Generated Code ---------- * ///

class UserModel extends UserModelGen {
	UserModel({
		int? id,
		String? userId,
		String? name,
		String? email,
		String? password
	}): super(id, userId, name, email, password);

	factory UserModel.fromDatabase(Map<String, dynamic> map) {
		return UserModelGen.fromDatabase(map);
	}

	factory UserModel.fromJson(Map<String, dynamic> map) {
		return UserModelGen.fromJson(map);
	}

}