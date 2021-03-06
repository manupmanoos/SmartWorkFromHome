// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB6XzvodZARl9IgyqVSURB2IiL4z7VnyPg',
    appId: '1:196747058010:web:ff508bf6d9601aec1d3163',
    messagingSenderId: '196747058010',
    projectId: 'iotproject-a9f1b',
    authDomain: 'iotproject-a9f1b.firebaseapp.com',
    storageBucket: 'iotproject-a9f1b.appspot.com',
    measurementId: 'G-NEBR42T9XJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC8rx-SjrOH63Q0htxWBu-v_xWLJrbjiC8',
    appId: '1:196747058010:android:e180682efe3209471d3163',
    messagingSenderId: '196747058010',
    projectId: 'iotproject-a9f1b',
    storageBucket: 'iotproject-a9f1b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDC_cXVhlvKuGzqG01QVJyIFVcRnSffAlc',
    appId: '1:196747058010:ios:0f821cc25e091ac81d3163',
    messagingSenderId: '196747058010',
    projectId: 'iotproject-a9f1b',
    storageBucket: 'iotproject-a9f1b.appspot.com',
    androidClientId: '196747058010-73ovpo9f1esjh3mu2fkg19mu5lktpel8.apps.googleusercontent.com',
    iosClientId: '196747058010-nnk1pk3f43l59onj0il4qiiaq0fbkr7f.apps.googleusercontent.com',
    iosBundleId: 'com.iotrix.swfh',
  );
}
