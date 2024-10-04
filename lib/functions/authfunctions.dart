import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:login/pages/homepage.dart';
// import 'package:login/pages/doc_homepage.dart';
import 'package:login/pages/home_screen.dart';

signup(
    BuildContext context, String email, String password, bool isDoctor) async {
  try {
    print('Attempting to create user...');
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    print('User created: ${credential.user?.uid}');

    print('Attempting to save user data in Firestore...');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(credential.user!.uid)
        .set({
      'email': email,
      'isDoctor': isDoctor,
    });
    print('User data saved successfully.');

    // Show success feedback
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Sign Up Successful! Log in Now')));
          showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Successful Sign Up . You can Log in now'),
          );
        });
  } on FirebaseAuthException catch (e) {
    print('FirebaseAuthException: ${e.code}');
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}

signin(BuildContext context, String email, password) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(credential.user!.uid)
        .get();

    // Retrieve the isDoctor flag from the user's document
    bool isDoctor = userDoc['isDoctor'];

    // Redirect to the appropriate homepage based on the user's type (doctor or patient)
    if (isDoctor) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeScreen()), // If doctor, navigate to DoctorHomepage
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeScreen()), // If patient, navigate to PatientHomepage
      );
    }

    print('//////////////////// SUCCESS LOGGING IN ////////////');
    // PASSING THE BUILDCONTEXT TO THE FUNCTION AS PARAMETER AND USING NAVIGATOR.PUSH WAS MY PLAN SO IF ANY ERRORS DUE TO THIS THIS CAN BE REMOVED
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Invalid credentials'),
          );
        });
  }
}
