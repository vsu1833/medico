import 'package:flutter/material.dart';
import 'package:login/components/my_button.dart';
import 'package:login/functions/authFunctions.dart';
import 'package:login/pages/forgot_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String username = '';
  String licenseNo = '';
  bool isLogin = false;
  bool isDoctor = false;

  @override
  void dispose() {
    // Dispose of the controllers when no longer needed
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 107, 170, 181),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 50),
                  // Logo
                  const Icon(
                    Icons.lock,
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 50),
                  // Welcome message
                  const Text(
                    'Welcome back you have been missed!',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  // Username textfield
                  isLogin
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            key: const ValueKey('username'),
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Enter your Name",
                                hintStyle: TextStyle(color: Colors.grey)),
                            validator: (value) {
                              if ((value.toString().length < 3)) {
                                return 'Invalid username';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                username = value!;
                              });
                            },
                          ),
                        )
                      : Container(),

                  const SizedBox(height: 10),

                  //If doctor is the one signing in
                  isDoctor
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            key: const ValueKey('licenseNo'),
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Enter your License Number",
                                hintStyle: TextStyle(color: Colors.grey)),
                            validator: (value) {
                              if ((value.toString().length < 8)) {
                                return 'Invalid license No';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                licenseNo = value!;
                              });
                            },
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 10),
                  // Email textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      key: const ValueKey('email'),
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Enter Email",
                          hintStyle: TextStyle(color: Colors.grey)),
                      validator: (value) {
                        if (!(value.toString().contains('@'))) {
                          return 'Invalid email Id';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          email = value!;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Password textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      obscureText: true,
                      key: const ValueKey('password'),
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Enter Password",
                          hintStyle: TextStyle(color: Colors.grey)),
                      validator: (value) {
                        if (value.toString().length < 6) {
                          return 'Password is too small';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          password = value!;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 10),
                  // Forgot password
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(
                            isLogin ? 'already Signed Up? Log in' : 'Signup',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Sign in button
                  MyButton(
                    onTap: () {
                      if (_formkey.currentState!.validate()) {
                        _formkey.currentState!.save();
                        !isLogin
                            ? signin(context, email, password)
                            : signup(context, email, password, isDoctor);
                      }
                    },
                    buttonname: isLogin ? "Sign up" : "Login",
                  ),
                  const SizedBox(height: 10),
                  // Are you a Doctor? text
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isDoctor = !isDoctor;
                        print(isDoctor);
                      });
                      print('The Doctor button was pressed and state was set');
                    },
                    child: !isDoctor
                        ? const Text(
                            'Are you a Doctor?',
                            style: TextStyle(color: Colors.white),
                          )
                        : const Text(
                            'Are you a Patient?',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                  const SizedBox(height: 10),
                  // Forgot Password Button
                  !isLogin
                      ? TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage()),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 10),
                  // Divider
                  const Divider(
                    color: Color.fromARGB(255, 244, 235, 235),
                    thickness: 1,
                  ),
                  const SizedBox(height: 20),
                  // Expanded container with image
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(254, 254, 254, 254),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        topRight: Radius.circular(100),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              print("Tapped on the button");
                            },
                            child: Row(
                              children: [
                                const Text(
                                  "Made with ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                                Icon(
                                  Icons.favorite_sharp,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                const Text(
                                  " in India",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
