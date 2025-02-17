// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCNnetJSUKrxnd3p-XRmNSfx82sMMTNsWM',
    appId: '1:727553929161:web:ba1830293b10ffc9d1c218',
    messagingSenderId: '727553929161',
    projectId: 'mediconew-20b8f',
    authDomain: 'mediconew-20b8f.firebaseapp.com',
    storageBucket: 'mediconew-20b8f.appspot.com',
    measurementId: 'G-9WM9S1QEYD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBWNxwyUbfZiQn3_iOWh0If6gQYTAT8DEg',
    appId: '1:727553929161:android:bc7349843ca50165d1c218',
    messagingSenderId: '727553929161',
    projectId: 'mediconew-20b8f',
    storageBucket: 'mediconew-20b8f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCPqrQyyxvELDa5Y7r1S4vllRBKAERzj4M',
    appId: '1:727553929161:ios:45616abd13a2c949d1c218',
    messagingSenderId: '727553929161',
    projectId: 'mediconew-20b8f',
    storageBucket: 'mediconew-20b8f.appspot.com',
    iosBundleId: 'com.example.login',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCPqrQyyxvELDa5Y7r1S4vllRBKAERzj4M',
    appId: '1:727553929161:ios:45616abd13a2c949d1c218',
    messagingSenderId: '727553929161',
    projectId: 'mediconew-20b8f',
    storageBucket: 'mediconew-20b8f.appspot.com',
    iosBundleId: 'com.example.login',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCNnetJSUKrxnd3p-XRmNSfx82sMMTNsWM',
    appId: '1:727553929161:web:c2331144308675bbd1c218',
    messagingSenderId: '727553929161',
    projectId: 'mediconew-20b8f',
    authDomain: 'mediconew-20b8f.firebaseapp.com',
    storageBucket: 'mediconew-20b8f.appspot.com',
    measurementId: 'G-41L7LFFDJD',
  );
}
