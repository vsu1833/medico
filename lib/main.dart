import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/onboarding_page.dart';
import 'package:login/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OnboardingPage(),
  ));
}
