import 'package:ekilisync/models/user_model.dart';
import 'package:ekilisync/services/api_manager.dart';
import 'package:ekilisync/src/Provider/user_data_provider.dart';
import 'package:ekilisync/src/bases/user_form_scheme.dart';
import 'package:ekilisync/src/screens/TodoList/all_todo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  bool _obscurePassword = true;

  final _formSchema = UserFormSchema.create();
  late UserDataProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserDataProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userProvider.refresh();
    });
  }

  void _toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

 void _submitAuthForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isLogin ? 'Logging in...' : 'Signing up...'),
          backgroundColor: Colors.teal,
          duration: Duration(seconds: 2),
        ),
      );

      UserModel? savedUser = await _userProvider.save(context, _formSchema.User);

      if (savedUser != null) {
        if (!context.mounted) return;

        if (isLogin) {
          // If login is successful, navigate to the Todo List screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TodoListScreen()),
          );
        } else {
          // If signup is successful, register user and navigate to AuthScreen or a different screen
          await APIManager.instance.userSignup(
            _formSchema.User.name!,
            _formSchema.User.email!,
            _formSchema.User.password!,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Signup successful! Please log in."),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthScreen()), // Return to login screen after signup
          );
        }
      } else {
        // Show an error message if authentication fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to authenticate. Please try again."),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 80, color: Colors.teal),
              SizedBox(height: 10),
              Text(
                isLogin ? 'Welcome Back!' : 'Create Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Signup
                    if (!isLogin)
                      TextFormField(
                        controller: _formSchema.nameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return 'Enter a username';
                          return null;
                        },
                      ),
                    if (!isLogin) SizedBox(height: 15),

                    TextFormField(
                      controller: _formSchema.emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    TextFormField(
                      controller: _formSchema.passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 1) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25),

                    ElevatedButton(
                      onPressed: _submitAuthForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 100,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isLogin ? 'Login' : 'Sign Up',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 15),

                    TextButton(
                      onPressed: _toggleAuthMode,
                      child: Text(
                        isLogin
                            ? "Don't have an account? Sign up"
                            : "Already have an account? Login",
                        style: TextStyle(fontSize: 16, color: Colors.teal),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
