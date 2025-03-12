import 'package:ekilisync/models/user_model.dart';
import 'package:ekilisync/repositories/user_repository.dart';
import 'package:ekilisync/services/api_manager.dart';
import 'package:ekilisync/src/Provider/base_provider.dart';
import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/bases.dart';

import 'package:ipf_flutter_starter_pack/services.dart';

class UserDataProvider extends BaseProvider<UserModel> {
  UserDataProvider() : super(UserRepository.instance);

  static UserDataProvider of(BuildContext context) =>
      BaseDataProvider.of(context);
  static UserDataProvider listen(BuildContext context) =>
      BaseDataProvider.listen(context);

  UserRepository userRepository = UserRepository.instance;

  List<UserModel>? _users;
  List<UserModel> get users => _users ?? [];

  UserModel? _user;
  UserModel get user => _user!;

  set user(UserModel value) {
    _user = value;
    notifyListeners();
  }

  @override
  refresh() async {
    try {
      setFetchState(true);
      List<UserModel> users = await userRepository.all;
      setData(users);
    } catch (exception) {
      AppUtility.log(exception);
    } finally {
      setFetchState(false);
    }
  }

  @override
  Future<UserModel?> save(BuildContext context, UserModel model) async {
    try {
      setCreateState(true);

      final loggedUser = await APIManager.instance.loginUser(
        model.email!,
        model.password!,
      );
      if (loggedUser == null) {
        throw Exception("Authentication failed");
      }
      AppUtility.log("User authenticated successfully");

      UserModel? localSavedModel = await userRepository.save(model);
      if (localSavedModel == null) {
        throw Exception("Failed to save user to the local database");
      }
      AppUtility.log("User successfully saved to the local database");

      if (!context.mounted) return localSavedModel;
      List<UserModel?> userList = await UserRepository.instance.getUser(
        model.name,
        model.email,
      );
      if (userList.isNotEmpty && userList.first != null) {
        user = userList.first!;
        print("User found: ${user.name}");
      } else {
        throw Exception("User not found");
      }
      return localSavedModel;
    } catch (exception) {
      AppUtility.log("Error: $exception");
      return null;
    } finally {
      setCreateState(false);
    }
  }

  Future<UserModel?> getUser() async {
    print("Getting user : ${user.name}");
    return Future.value(user);
  }

  

  
}
