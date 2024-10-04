import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Define the main StatefulWidget
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Controller for the email text field
  final TextEditingController emailController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content:
                Text('Password Reset link has been sent to your email address'),
          );
        },
      );
      print('/////////////// Link has been sent ////////////////');
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
      print('/////////////// ERROR WHILE SENDING THE LINK ////////////////');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(254, 254, 254, 254),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Brain image with question mark
            Center(
              child: Image.asset(
                'assets/brain_question_mark.jpg', // Replace with your asset path
                height: 150,
                width: 150,
              ),
            ),
            const SizedBox(height: 20),

            // "Forgot Password" title
            const Text(
              "Forgot Password",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 107, 170, 181),
              ),
            ),
            const SizedBox(height: 10),

            // Centered message
            const Text(
              "No worries! Provide your email id and we'll send you the reset link",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 107, 170, 181),
              ),
            ),
            const SizedBox(height: 30),

            // Email TextField using the provided MyTextfield widget
            MyTextfield(
              controller: emailController,
              hintText: 'Email ID',
              obscureText: false,
            ),
            const SizedBox(height: 20),

            // Proceed button
            ElevatedButton(
              onPressed: () {
                // Handle email submission logic
                String email = emailController.text;
                if (email.isNotEmpty) {
                  // Implement email validation and submission logic here
                  passwordReset();
                  print("Email submitted: $email");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 107, 170, 181),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                "Proceed",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MyTextfield widget (provided code)
class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
