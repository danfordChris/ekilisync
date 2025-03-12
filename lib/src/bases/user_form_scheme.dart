import 'package:ekilisync/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:ipf_flutter_starter_pack/bases.dart';

class UserFormSchema extends BaseDataForm<UserModel> {
  UserFormSchema._(super.data);
  UserFormSchema._sample() : super(null, true);
  factory UserFormSchema.from({UserModel? user}) => UserFormSchema._(user);

  factory UserFormSchema.create() {
    if (kDebugMode) return UserFormSchema._sample();
    return UserFormSchema._(null);
  }

  final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final TextEditingController _addressController = TextEditingController();
  TextEditingController get addressController => _addressController;

  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  final TextEditingController _titleController = TextEditingController();
  TextEditingController get titleController => _passwordController;

  final TextEditingController _descriptionController = TextEditingController();
  TextEditingController get descriptionController => _descriptionController;

  @override
  void setup(UserModel? user) {
    if (user == null) return;
    _nameController.text = user.name ?? '';
    _emailController.text = user.email ?? '';
    _passwordController.text = user.password ?? '';
  }

  @override
  void setupSample(UserModel? data) {
    super.setupSample(data);
    _nameController.text = "zogoa";
    _emailController.text = "zogo1@gmail.com";
    _passwordController.text = "1234";

  }

  UserModel get User {
    return UserModel(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }
}
