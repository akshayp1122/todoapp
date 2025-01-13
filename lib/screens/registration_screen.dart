import 'package:flutter/material.dart';
import 'package:todo_list_app/controller/auth_controller.dart';
import 'package:todo_list_app/core/constants/size.dart';
import 'package:todo_list_app/screens/login_screen.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthController _authController = AuthController();

  late String email;

  late String password;

  late String fullName;
  registerUser() async {
    BuildContext localContext = context;
    String res =
        await _authController.registerNewUser(email, password, fullName);
    if (res == 'success') {
      ScaffoldMessenger.of(localContext).showSnackBar(const SnackBar(
          content: Text("account have been created successfully")));
      Future.delayed(Duration.zero, () {
        Navigator.push(localContext, MaterialPageRoute(builder: (context) {
          return SignIn();
        }));
      });
    } else {
      ScaffoldMessenger.of(localContext).showSnackBar(
          const SnackBar(content: Text("account creation failed")));
    }
  }

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppSizes.sizedBoxOne),
                    Image.asset("lib/assets/login.jpg"),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
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
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    child: const Text(
                                      "SignUp",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800),
                                    )),
                                const SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  decoration: const BoxDecoration(
                                      color: Color(0xfff5f8fd),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: TextFormField(
                                    onChanged: (value) {
                                      fullName = value;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'enter your username';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "Username",
                                        border: InputBorder.none),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  decoration: const BoxDecoration(
                                      color: Color(0xfff5f8fd),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
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
                                        border: InputBorder.none),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  decoration: const BoxDecoration(
                                      color: Color(0xfff5f8fd),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    onChanged: (value) {
                                      password = value;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'enter your password';
                                      } else if (value.length < 6) {
                                        return "Password must be at least 6 characters";
                                      } else {
                                        return null;
                                      }
                                    },
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                        hintText: "Password",
                                        border: InputBorder.none),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  decoration: const BoxDecoration(
                                      color: Color(0xfff5f8fd),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: TextFormField(
                                    controller: _confirmPasswordController,
                                    onChanged: (value) {
                                      password = value;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'enter your password';
                                      } else if (value !=
                                          _passwordController.text) {
                                        return "Passwords do not match";
                                      }
                                      {
                                        return null;
                                      }
                                    },
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                        hintText: "Confirm Password",
                                        border: InputBorder.none),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    //Raised Buttons of sigup will appear.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 13,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 55),
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.white70),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              registerUser();
                            } else {
                              print("failed");
                            }
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("Already have an account?"),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignIn()),
                          );
                        },
                        child: const Text("Sign In",
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.deepPurpleAccent,
                                fontSize: 18)),
                      )
                    ]),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
