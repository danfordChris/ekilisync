import 'package:ekilisync/models/todo_model.dart';
import 'package:ekilisync/repositories/base_repository.dart';
import 'package:ekilisync/models/user_model.dart';

/// * ---------- Auto Generated Code ---------- * ///

class UserRepository extends BaseRepository<UserModel> {
	UserRepository._(): super(UserModel(), (map) => UserModel.fromDatabase(map));
	static final UserRepository _instance = UserRepository._();
	static UserRepository get instance => _instance;



Future<List<UserModel?>>  getUser (String? name, String? email)async{
  return await findAllWhere("name LIKE ? AND email LIKE ?", ['%$name%', '%$email%']);

}


}