import 'package:ekilisync/services/api_manager.dart';
import 'package:ekilisync/services/database_manager.dart';
import 'package:ekilisync/src/Provider/todo_data_provider.dart';
import 'package:ekilisync/src/Provider/user_data_provider.dart';
import 'package:ekilisync/src/screens/Auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseManager.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    // Initialize the database
    // DatabaseManager.instance.init();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserDataProvider()),
        ChangeNotifierProvider(create: (context) => TodoDataProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: AuthScreen(),
      ),
    );
  }
}
