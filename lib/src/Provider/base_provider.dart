import 'package:ekilisync/repositories/base_repository.dart';
import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/bases.dart';
import 'package:ipf_flutter_starter_pack/services.dart';


abstract class BaseProvider<T extends BaseDatabaseModel>
    extends BaseDataProvider<T> {
  bool? _searching;
  bool get searching => _searching ?? false;

  BaseProvider(this._repository);

  final BaseRepository<T> _repository;

  Future<T?> save(BuildContext context, T model) async {
    try {
      setCreateState(true);
      T? savedModel = await _repository.save(model);
      if (savedModel == null) throw Exception("Model could not be saved");
      if (!context.mounted) return savedModel;
      // Scenery.showSuccess(Strings.of(context).dataSavedSuccessfully);
      return savedModel;
    } catch (exception) {
      AppUtility.log(exception);
      // Error handling for the project goes here
      return null;
    } finally {
      setCreateState(false);
    }
  }

  Future<void> delete(BuildContext context, int id) async {
    try {
      setDeleteState(true);
      int? deletedModel = await _repository.deleteWhereId(id);
      if (deletedModel == null) throw Exception("Model could not be removed");
      if (!context.mounted) return;
      // Scenery.showSuccess(Strings.of(context).save);
    } catch (exception) {
      AppUtility.log(exception);
      // Error handling for the project goes here
    } finally {
      setDeleteState(false);
    }
  }

  @override
  Future<void> refresh() async {
    try {
      setFetchState(true);
      // await _repository.refresh();
      List<T> data = await _repository.all;
      setData(data);
    } catch (exception) {
      AppUtility.log(exception);
      // Error handling for the project goes here
    } finally {
      setFetchState(false);
    }
  }
}
