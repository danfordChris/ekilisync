import 'package:ekilisync/models/todo_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:ipf_flutter_starter_pack/bases.dart';

class TodoFormScheme extends BaseDataForm<TodoModel> {
  TodoFormScheme._(super.data);
  TodoFormScheme._sample() : super(null, true);
  factory TodoFormScheme.from({TodoModel? user}) => TodoFormScheme._(user);

  factory TodoFormScheme.create() {
    if (kDebugMode) return TodoFormScheme._sample();
    return TodoFormScheme._(null);
  }


  final TextEditingController _titleController = TextEditingController();
  TextEditingController get titleController => _titleController;

  final TextEditingController _descriptionController = TextEditingController();
  TextEditingController get descriptionController => _descriptionController;

  @override
  void setup(TodoModel? todo) {
    if (todo == null) return;
    _titleController.text = todo.title ?? '';
    _descriptionController.text = todo.description ?? '';
  }

  @override
  void setupSample(TodoModel? data) {
    super.setupSample(data);

    _titleController.text = "title";
    _descriptionController.text = "description";
  }

  TodoModel get User {
    return TodoModel(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
    );
  }
}
