import 'package:ipf_flutter_starter_pack/bases.dart';
import 'package:ipf_flutter_starter_pack/services.dart';

void main(){
  List<BaseModelGenerator> generators =[_User(),_Todo()];
  CodeGenerator.of('ekilisync', generators).generate();


}

  class _User extends BaseModelGenerator{
    _User():super.database('users', {
      "id": int,
      "userId": String,
      "name": String,
      "email": String,
      "password": String,
    }, 
    
    // relations: [
    //   ModelRelation.many("userId", [_Todo()])
    // ]
    
    );
  }

  class _Todo extends BaseModelGenerator{
    _Todo():super.database('todos', {
      "id": int,
      "userId": String,
      "title": String,
      "description": String,
      "is_done": bool,
    });
  }

