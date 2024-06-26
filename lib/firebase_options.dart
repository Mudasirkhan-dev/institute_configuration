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
    apiKey: 'AIzaSyA6YNZ8C68h6Pl43bdmO-QVVd3K-wXmYSQ',
    appId: '1:517285554732:web:f21e66eab9e1dab43f7f89',
    messagingSenderId: '517285554732',
    projectId: 'institute-configuration-system',
    authDomain: 'institute-configuration-system.firebaseapp.com',
    storageBucket: 'institute-configuration-system.appspot.com',
    measurementId: 'G-8YEJ87YET3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBDretjZi-Uv_t3eKRTxH199BLbOHDfuUo',
    appId: '1:517285554732:android:e23bf738e23580613f7f89',
    messagingSenderId: '517285554732',
    projectId: 'institute-configuration-system',
    storageBucket: 'institute-configuration-system.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAyeL3RLF1fnai9l4RiMarS8-KkAXjp8Jw',
    appId: '1:517285554732:ios:5a1ce052b826f0153f7f89',
    messagingSenderId: '517285554732',
    projectId: 'institute-configuration-system',
    storageBucket: 'institute-configuration-system.appspot.com',
    iosBundleId: 'com.example.instituteConfiguration',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAyeL3RLF1fnai9l4RiMarS8-KkAXjp8Jw',
    appId: '1:517285554732:ios:5a1ce052b826f0153f7f89',
    messagingSenderId: '517285554732',
    projectId: 'institute-configuration-system',
    storageBucket: 'institute-configuration-system.appspot.com',
    iosBundleId: 'com.example.instituteConfiguration',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA6YNZ8C68h6Pl43bdmO-QVVd3K-wXmYSQ',
    appId: '1:517285554732:web:6160788240f2847e3f7f89',
    messagingSenderId: '517285554732',
    projectId: 'institute-configuration-system',
    authDomain: 'institute-configuration-system.firebaseapp.com',
    storageBucket: 'institute-configuration-system.appspot.com',
    measurementId: 'G-3H928T94GC',
  );
}
