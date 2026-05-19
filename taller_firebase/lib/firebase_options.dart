import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBF2SI8wYCUiQQh9x4ChptYIY-0sUq9zcw',
    appId: '1:380869657957:web:120cb1954e696f316c0d8c',
    messagingSenderId: '380869657957',
    projectId: 'taller-firebase-universi-d4fa0',
    authDomain: 'taller-firebase-universi-d4fa0.firebaseapp.com',
    storageBucket: 'taller-firebase-universi-d4fa0.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBF2SI8wYCUiQQh9x4ChptYIY-0sUq9zcw',
    appId: '1:380869657957:android:1542aaed818bfbaebc09c7',
    messagingSenderId: '380869657957',
    projectId: 'taller-firebase-universi-d4fa0',
    storageBucket: 'taller-firebase-universi-d4fa0.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBF2SI8wYCUiQQh9x4ChptYIY-0sUq9zcw',
    appId: '1:380869657957:ios:9e047debba2cb2e0bc09c7',
    messagingSenderId: '380869657957',
    projectId: 'taller-firebase-universi-d4fa0',
    storageBucket: 'taller-firebase-universi-d4fa0.firebasestorage.app',
    iosBundleId: 'com.taller.tallerFirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBF2SI8wYCUiQQh9x4ChptYIY-0sUq9zcw',
    appId: '1:380869657957:ios:9e047debba2cb2e0bc09c7',
    messagingSenderId: '380869657957',
    projectId: 'taller-firebase-universi-d4fa0',
    storageBucket: 'taller-firebase-universi-d4fa0.firebasestorage.app',
    iosBundleId: 'com.taller.tallerFirebase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBF2SI8wYCUiQQh9x4ChptYIY-0sUq9zcw',
    appId: '1:380869657957:web:120cb1954e696f316c0d8c',
    messagingSenderId: '380869657957',
    projectId: 'taller-firebase-universi-d4fa0',
    authDomain: 'taller-firebase-universi-d4fa0.firebaseapp.com',
    storageBucket: 'taller-firebase-universi-d4fa0.firebasestorage.app',
  );
}
