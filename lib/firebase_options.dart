// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD5YDi2skG8WzDpIRvTZHtyDbaKIX0Olfc',
    appId: '1:43767063006:web:bef61fbdc10189fb357d4f',
    messagingSenderId: '43767063006',
    projectId: 'tag-lag-f6931',
    authDomain: 'tag-lag-f6931.firebaseapp.com',
    databaseURL: 'https://tag-lag-f6931-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'tag-lag-f6931.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9dIvrsUYgJY1lsilyt56FNzwgyQOwtng',
    appId: '1:43767063006:android:af16a162063ca20d357d4f',
    messagingSenderId: '43767063006',
    projectId: 'tag-lag-f6931',
    databaseURL: 'https://tag-lag-f6931-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'tag-lag-f6931.appspot.com',
  );
}