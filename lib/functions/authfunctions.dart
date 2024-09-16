import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/pages/homepage.dart';

signup(BuildContext context, String email, String password) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    print('////////////// SUCCESS SIGNING UP ////////');
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Successful Sign Up Now Proceed to Log in'),
          );
        });
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

signin(BuildContext context, String email, password) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    print('//////////////////// SUCCESS LOGGING IN ////////////');
    // PASSING THE BUILDCONTEXT TO THE FUNCTION AS PARAMETER AND USING NAVIGATOR.PUSH WAS MY PLAN SO IF ANY ERRORS DUE TO THIS THIS CAN BE REMOVED
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
     showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Invalid credentials'),
          );
        });
  }
}
