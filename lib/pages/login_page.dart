import 'package:flutter/material.dart';
import 'package:login/components/my_button.dart';
import 'package:login/components/my_textfield.dart';
import 'package:login/pages/homepage.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void signUserIn() {
      print("Tapped on the button");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 107, 170, 181),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
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
              MyTextfield(
                controller: usernameController,
                hintText: "Enter Username",
                obscureText: false,
              ),
              const SizedBox(height: 10),
              // Password textfield
              MyTextfield(
                controller: passwordController,
                hintText: "Enter Password",
                obscureText: true,
              ),
              const SizedBox(height: 10),
              // Forgot password
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Forgot Password',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              // Sign in button
              MyButton(
                onTap: signUserIn,
              ),
              const SizedBox(height: 10),
              // Are you a Doctor? text
              const Text(
                'Are you a Doctor?',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              // Divider
              Divider(
                color: const Color.fromARGB(255, 244, 235, 235),
                thickness: 1,
              ),
              const SizedBox(height: 40),
              // Expanded container with image

              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(254, 254, 254, 254),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("Tapped on the button");
                          },
                          child: Text(
                            "Sign In With Google",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                            width:
                                15), // Adjust width of space between text and image
                        Image.asset(
                          'assets/img3.jpg',
                          fit: BoxFit.cover,
                          height: 75,
                          width: 75,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
