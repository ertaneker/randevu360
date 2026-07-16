import 'package:firebase_core/firebase_core.dart';

/// Attempts to initialize Firebase with fake credentials for the test
/// environment. Catches errors if Firebase is already initialized or if
/// the platform doesn't support Firebase initialization.
Future<void> setupFirebaseForTest() async {
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'test-api-key-for-testing',
        appId: '1:test:android:test',
        messagingSenderId: 'test-sender-id',
        projectId: 'test-project-id',
      ),
    );
  } catch (_) {
    // Already initialized or running in an environment where Firebase
    // cannot be initialized (e.g. web). Safe to ignore.
  }
}
