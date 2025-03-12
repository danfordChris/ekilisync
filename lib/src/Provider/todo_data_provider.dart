import 'package:ekilisync/models/todo_model.dart';
import 'package:ekilisync/repositories/todo_repository.dart';
import 'package:ekilisync/services/api_manager.dart';
import 'package:ekilisync/src/Provider/base_provider.dart';
import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/bases.dart';
import 'package:ipf_flutter_starter_pack/services.dart';

class TodoDataProvider extends BaseProvider<TodoModel> {
  TodoDataProvider() : super(TodoRepository.instance);
  
  static TodoDataProvider of(BuildContext context) =>
      BaseDataProvider.of<TodoDataProvider>(context);
  
  static TodoDataProvider listen(BuildContext context) =>
      BaseDataProvider.listen<TodoDataProvider>(context);
  
  TodoRepository todoRepository = TodoRepository.instance;
  
  @override
  Future<List<TodoModel>> refresh() async {
    try {
      setFetchState(true);
      List<TodoModel> todos = await todoRepository.all;
      setData(todos);
      notifyListeners(); // Ensure UI updates
      AppUtility.log("Fetched ${todos.length} todos");
      return todos;
    } catch (exception) {
      AppUtility.log("Error refreshing todos: $exception");
      return [];
    } finally {
      setFetchState(false);
    }
  }
  
  @override
  Future<TodoModel?> save(BuildContext context, TodoModel model) async {
    try {
      setCreateState(true);
      
      // API call to create todo
      final newTodo = await APIManager.instance.createTodo(
        model.title!,
        model.description!,
      );
      
      print('title : ${model.title}');
      if (newTodo == null) {
        throw Exception("No Todo added");
      }
      AppUtility.log("Todo successfully created on API");
      await todoRepository.save(model);
      // Save to local database
      // TodoModel? localSavedModel = await todoRepository.save(model);
      // if (localSavedModel == null) {
      //   throw Exception("Failed to save todo to the local database");
      // }
      AppUtility.log("Todo successfully saved to the local database");
      
      // if (!context.mounted) return localSavedModel;
      
      // Refresh data
      await refresh();
      // return localSavedModel;
    } catch (exception) {
      AppUtility.log("Error saving todo: $exception");
      return null;
    } finally {
      setCreateState(false);
    }
  }
  
  Future<TodoModel?> updateTodo(BuildContext context, TodoModel model) async {
    try {
      setCreateState(true);
      
      // Check if ID exists
      if (model.id == null) {
        throw Exception("Cannot update todo without ID");
      }
      
      // API call to update todo
      final updatedTodo = await APIManager.instance.updateTodo(
        model.title!,
        model.description!,
        model.id!,
      );
      
      if (updatedTodo == null) {
        throw Exception("No Todo updated");
      }
      AppUtility.log("Todo successfully updated on API");
      
      // Update in local database
      TodoModel? localUpdatedModel = await todoRepository.updateTodo(updatedTodo);
      if (localUpdatedModel == null) {
        throw Exception("Failed to update todo in the local database");
      }
      AppUtility.log("Todo successfully updated in the local database");
      
      if (!context.mounted) return localUpdatedModel;
      
      // Refresh data
      await refresh();
      return localUpdatedModel;
    } catch (exception) {
      AppUtility.log("Error updating todo: $exception");
      return null;
    } finally {
      setCreateState(false);
    }
  }
  
  Future<void> deleteTodo(BuildContext context, int id) async {
    try {
      setDeleteState(true);
      
      // API call to delete todo
      // final result = await APIManager.instance.deleteTodo(id);
      // if (result != true) {
      //   throw Exception("Failed to delete todo from API");
      // }
      
      // Delete from local database
      int? deletedId = await todoRepository.deleteWhereId(id);
      if (deletedId == null) {
        throw Exception("Failed to delete todo from local database");
      }
      
      AppUtility.log("Todo successfully deleted");
      
      if (!context.mounted) return;
      
      // Refresh data
      await refresh();
    } catch (exception) {
      AppUtility.log("Error deleting todo: $exception");
    } finally {
      setDeleteState(false);
    }
  }

  
}