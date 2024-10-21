import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/onboarding_page.dart';
import 'pages/doc_homepage.dart';
import 'pages/main_screen.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      
      // Check Firestore for user type (doctor or patient)
      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              bool isDoctor = snapshot.data!['isDoctor'];
              return isDoctor ? DocHomeScreen() : MainScreen();
            } else {
              return OnboardingPage(); // In case Firestore data isn't available, fall back to onboarding
            }
          }
          // Customizable SpinKitFadingCircle loader
          final spinkit = SpinKitFadingCircle(
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.red : Colors.green,
                ),
              );
            },
          );
          
          return Center(
            child: spinkit, // Display the SpinKit loader in the center
          );
        },
      );
    } else {
      // No user is logged in, show onboarding page
      return const OnboardingPage();
    }
  }
}
