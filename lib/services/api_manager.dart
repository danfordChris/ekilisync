import 'dart:convert';

import 'package:ekilisync/models/todo_model.dart';
import 'package:ekilisync/models/user_model.dart';
import 'package:ekilisync/src/Provider/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/bases.dart';
import 'package:ekilisync/services/preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ipf_flutter_starter_pack/services.dart';

class APIManager extends BaseAPIManager {
  APIManager._() : super(_currentURL, _authorization);
  static APIManager get instance => APIManager._();

  static const String _localURL = "https://ekilisync-nestjs.onrender.com";
  static const String _baseURL = "<Insert URL Here>/api/v1";
  static const String _releaseURL = "<Insert URL Here>/api/v1";
  static const String _currentURL = kDebugMode ? _localURL : _releaseURL;

  
  Preferences preferences = Preferences.instance;

  static Future<Map<String, String>?> get _authorization async {
    Preferences preferences = Preferences.instance;
    String? token = await preferences.fetch(PrefKeys.apiToken);
    if (token == null) return null;
    return {"Authorization": "Bearer $token"};
  }

  Future<UserModel?> loginUser(
    
    String email,
    String password,
  ) async {
    try {
      APIManager apiManager = APIManager.instance;

      Map<String, dynamic> body = {"email": email, "password": password};

      http.Response response = await apiManager.post(
        "/auth/login",
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData["user"] != null) {
          UserModel user = UserModel.fromJson(responseData["user"]);
          AppUtility.log("Login Successful: ${user.email}");
          if (preferences.fetch(PrefKeys.apiToken) != null  || preferences.fetch(PrefKeys.ownerId) != null) {
            await preferences.removeApiToken();
            await preferences.removeOwnerId();
          }
          await preferences.saveApiToken(responseData["token"]);
          await preferences.saveOwnerId(responseData["user"]["id"]);

          

          return user;
        } else {
          AppUtility.log("Invalid response: ${response.body}");
        }
      } else {
        AppUtility.log("Error ${response.statusCode}: ${response.body}");
      }
      return null;
      
    } catch (exception) {
      AppUtility.log("Exception: $exception");
    }

    return null;
  }

  Future<UserModel?> userSignup(
    String name,
    String email,
    String password,
  ) async {
    try {
      APIManager apiManager = APIManager.instance;

      Map<String, dynamic> body = {
        "name": name,
        "email": email,
        "password": password,
      };

      http.Response response = await apiManager.post(
        "/auth/signup",
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData["token"] != null) {
          await preferences.saveApiToken(responseData["token"]);

          return UserModel.fromJson(responseData["user"]);
        } else {
          AppUtility.log("Invalid response: ${response.body}");
        }
      } else {
        AppUtility.log("Error ${response.statusCode}: ${response.body}");
      }
    } catch (exception) {
      AppUtility.log("Exception: $exception");
    }

    return null;
  }

  Future<TodoModel?> createTodo(
    String title,
    String description,
   
  ) async {
    try {
      APIManager apiManager = APIManager.instance;
    final ownerId = await preferences.fetch(PrefKeys.ownerId);
      Map<String, dynamic> body = {
        "title": title,
        "description": description,
        "ownerId": ownerId,
      };

      http.Response response = await apiManager.post(
        "/tasks",
        body: jsonEncode(body),
        headers: await _authorization,
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        AppUtility.log('Response Data: $responseData'); 
        return TodoModel.fromJson(responseData);
      } else {
        AppUtility.log("Error ${response.statusCode}: ${response.body}");
      }
    } catch (exception) {
      AppUtility.log("Exception: $exception");
    }

    return null;
  }

  Future<TodoModel?> updateTodo(
    String title,
    String description,
    int id,
   
  ) async {
    try {
      APIManager apiManager = APIManager.instance;
    final ownerId = await preferences.fetch(PrefKeys.ownerId);
      Map<String, dynamic> body = {
        "title": title,
        "description": description,
        "ownerId": ownerId,
      };

      http.Response response = await apiManager.patch(
        "/tasks/${id}",
        body: jsonEncode(body),
        headers: await _authorization,
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        AppUtility.log('Response Data: $responseData'); 
        return TodoModel.fromJson(responseData);
      } else {
        AppUtility.log("Error ${response.statusCode}: ${response.body}");
      }
    } catch (exception) {
      AppUtility.log("Exception: $exception");
    }

    return null;
  }



}
