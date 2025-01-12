import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/controller/to_do_provider.dart';
import 'package:todo_list_app/controller/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: "AIzaSyB-M_ZwcRVzlXlnmDVyZMHuP7xNAXJjj9k",
              appId: "1:774231350999:android:ea6d8efd06d522bdf51a92",
              messagingSenderId: "774231350999",
              projectId: "todoapp-184f2",
             ))
      : await Firebase.initializeApp();
  
  // Wait for FirebaseAuth to check if a user is logged in
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    runApp(MyApp()); // If no user, run the app normally (login page)
  } else {
    runApp(
      MultiProvider(
        providers: [
          // Pass userId from FirebaseAuth to TodoProvider
          ChangeNotifierProvider(
            create: (_) => TodoProvider(user.uid), // Pass user UID to TodoProvider
          ),
        ],
        child: MyApp(),
      ),
    );
  }

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "LogIn Screen",
        debugShowCheckedModeBanner: false,
        home:const WrapperPage(), // WrapperPage decides which page to show
    );
  }
}
