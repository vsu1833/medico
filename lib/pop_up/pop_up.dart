import 'package:flutter/material.dart';

class DialogBoxScreen extends StatelessWidget {
  const DialogBoxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return invalidUsernameDialog(context);
                },
              );
            },
            child: const Text("Invalid Username"),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return signupErrorDialog(context);
                },
              );
            },
            child: const Text("Signup Error"),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return incorrectPasswordDialog(context);
                },
              );
            },
            child: const Text("Incorrect Password"),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return successDialog(context);
                },
              );
            },
            child: const Text("Success"),
          ),
        ],
      ),
    );
  }
}

Widget invalidUsernameDialog(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: SizedBox(
        width: 300,
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Invalid Username",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 100,
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text("OK"),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget signupErrorDialog(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: SizedBox(
        width: 300,
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Signup Error",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 100.0,
            ),
            const SizedBox(height: 40),
            TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                  },
                  child: const Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16.0), // Adjust horizontal padding as needed
                    child:  Text("Ok"),
                  ),
                ),
          ],
        ),
      ),
    ),
  );
}

Widget incorrectPasswordDialog(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: SizedBox(
        width: 300,
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Incorrect Password",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 100.0,
            ),
            const SizedBox(height: 40),
            TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                  },
                  child: const Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16.0), // Adjust horizontal padding as needed
                    child:  Text("Ok"),
                  ),
                ),
          ],
        ),
      ),
    ),
  );
}
Widget successDialog(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: SizedBox(
        width: 300,
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Signup Successful",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100.0,
            ),
            const SizedBox(height: 40),
            TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                  },
                  child: const Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16.0), // Adjust horizontal padding as needed
                    child:  Text("Ok"),
                  ),
                ),
          ],
        ),
      ),
    ),
  );
}


