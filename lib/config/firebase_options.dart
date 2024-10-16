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
    apiKey: 'AIzaSyAXDE1_BxiNwe9MyTkrTnZuVSx4hBjiGrg',
    appId: '1:731389448589:web:bfa93a99a49af57821edc4',
    messagingSenderId: '731389448589',
    projectId: 'datatrip-863f8',
    authDomain: 'datatrip-863f8.firebaseapp.com',
    databaseURL: 'https://datatrip-863f8-default-rtdb.firebaseio.com',
    storageBucket: 'datatrip-863f8.appspot.com',
    measurementId: 'G-TWS9PG17M9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAA592hrE8Wr87MWYdOxRsRdjmId9l3i6k',
    appId: '1:731389448589:android:c9f902d0dee452ff21edc4',
    messagingSenderId: '731389448589',
    projectId: 'datatrip-863f8',
    databaseURL: 'https://datatrip-863f8-default-rtdb.firebaseio.com',
    storageBucket: 'datatrip-863f8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDjaqdDnWDvWFjUrYQVy61fhiLiG_kOlP0',
    appId: '1:731389448589:ios:b4c5e8c77c0bb35221edc4',
    messagingSenderId: '731389448589',
    projectId: 'datatrip-863f8',
    databaseURL: 'https://datatrip-863f8-default-rtdb.firebaseio.com',
    storageBucket: 'datatrip-863f8.appspot.com',
    iosBundleId: 'com.example.mapSample',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDjaqdDnWDvWFjUrYQVy61fhiLiG_kOlP0',
    appId: '1:731389448589:ios:b4c5e8c77c0bb35221edc4',
    messagingSenderId: '731389448589',
    projectId: 'datatrip-863f8',
    databaseURL: 'https://datatrip-863f8-default-rtdb.firebaseio.com',
    storageBucket: 'datatrip-863f8.appspot.com',
    iosBundleId: 'com.example.mapSample',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAXDE1_BxiNwe9MyTkrTnZuVSx4hBjiGrg',
    appId: '1:731389448589:web:05e33087f1ad78a121edc4',
    messagingSenderId: '731389448589',
    projectId: 'datatrip-863f8',
    authDomain: 'datatrip-863f8.firebaseapp.com',
    databaseURL: 'https://datatrip-863f8-default-rtdb.firebaseio.com',
    storageBucket: 'datatrip-863f8.appspot.com',
    measurementId: 'G-BP9LDFK34D',
  );
}
