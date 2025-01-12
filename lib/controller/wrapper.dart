import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/controller/to_do_provider.dart';
import 'package:todo_list_app/screens/login_screen.dart';
import 'package:todo_list_app/screens/to_do_list_page.dart';
class WrapperPage extends StatelessWidget {
  const WrapperPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return ChangeNotifierProvider(
        create: (_) => TodoProvider(user.uid),
        child: const TodoListPage(),
      );
    } else {
      return  SignIn();
    }
  }
}
