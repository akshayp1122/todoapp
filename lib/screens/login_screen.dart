import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/controller/auth_controller.dart';
import 'package:todo_list_app/controller/to_do_provider.dart';
import 'package:todo_list_app/core/constants/size.dart';
import 'package:todo_list_app/screens/registration_screen.dart';
import 'package:todo_list_app/screens/to_do_list_page.dart';

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String email;
  late String password;
  final AuthController _authController = AuthController();
  loginUser() async {
    BuildContext localContext = context;
    String res = await _authController.loginuser(email, password);
    if (res == 'success') {
      ScaffoldMessenger.of(localContext).showSnackBar(
          const SnackBar(content: Text("User logged in successfully")));

      // Fetch the user UID after login
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Wrap the navigation with the provider to ensure TodoProvider is available
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => TodoProvider(user.uid), // Pass the user UID
                ),
              ],
              child: const TodoListPage(),
            ),
          ),
        );
      } else {
        print("User not authenticated after login");
      }
    } else {
      ScaffoldMessenger.of(localContext)
          .showSnackBar(const SnackBar(content: Text("User login failed")));
      print(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: AppSizes.sizedBoxOne,
              ),
              Image.asset("lib/assets/register.jpg"),
              Form(
                key: _formKey,
                child: Container(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: AppSizes.sizedBoxOne,
                    ),
                    // From here the login Credentials start.
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ]),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                )),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 5),
                              decoration: const BoxDecoration(
                                  color: Color(0xfff5f8fd),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: TextFormField(
                                onChanged: (value) {
                                  email = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'enter your email';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                  hintText: "Email",
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 5),
                              decoration: const BoxDecoration(
                                  color: Color(0xfff5f8fd),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: TextFormField(
                                onChanged: (value) {
                                  password = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'enter your password';
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: "Password",
                                  border: InputBorder.none,
                                  prefixIcon:
                                      Icon(Icons.vpn_key, color: Colors.grey),
                                ),
                              ),
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.w500),
                      ),
                    ),

                    const SizedBox(height: 25),

                    //From here the signin buttons will occur.

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 3,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50),
                              shape: const RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white70),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              )),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              loginUser();
                            } else {
                              print("failed");
                            }
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("Don't have an account?"),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        child: const Text("Register now",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.deepPurpleAccent)),
                      )
                    ]),
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
