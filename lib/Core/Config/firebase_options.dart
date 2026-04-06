import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions are not configured for web platform.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC0y8mhe_mTKQxQlPmdGZd4t2WNPrxh0xg',
    appId: '1:413983209838:android:c89942059eebf90914e97f',
    messagingSenderId: '413983209838',
    projectId: 'slim30-86df2',
    storageBucket: 'slim30-86df2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAejl1lECs107RMySILL8Hx2rmPytHnqvs',
    appId: '1:413983209838:ios:9425ae0e30ed72a314e97f',
    messagingSenderId: '413983209838',
    projectId: 'slim30-86df2',
    storageBucket: 'slim30-86df2.firebasestorage.app',
    iosBundleId: 'com.flywork.slim30',
    iosClientId:
        '413983209838-f856mdegqin59mrc2dpd1sh3fnhli9i0.apps.googleusercontent.com',
  );
}
