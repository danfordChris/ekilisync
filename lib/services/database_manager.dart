import 'package:ipf_flutter_starter_pack/bases.dart';
import 'package:ekilisync/models/user_model.dart';
import 'package:ekilisync/models/todo_model.dart';

class DatabaseManager extends BaseDatabaseManager {
	DatabaseManager._(): super("ekilisync.db", 1, _tables);
	static final DatabaseManager _instance = DatabaseManager._();
	static DatabaseManager get instance => _instance;

	static List<BaseDatabaseModel> get _tables {
		return [
			UserModel(),
			TodoModel()
		];
	}
}