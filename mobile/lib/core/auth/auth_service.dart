import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
  checking,   // checking Firestore for existing registration
  loading,
  error,
}

/// Abstract interface for authentication, enabling test mocks without Firebase.
abstract class IAuthService {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<UserCredential?> signInWithGoogle();
  Future<void> signOut();
  Future<void> deleteAccount();
}

class AuthService implements IAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled

      // Get auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    } catch (e) {
      throw Exception('Google giriş yapılamadı: $e');
    }
  }

  @override
  Future<void> signOut() async {
    // Google Sign-In signOut may throw if the user didn't sign in with Google.
    // Always proceed to Firebase signOut to ensure the session is cleared.
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
    await signOut();
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'Bu email ile başka bir hesap var';
      case 'invalid-credential':
        return 'Geçersiz kimlik bilgisi';
      case 'user-disabled':
        return 'Hesap devre dışı bırakılmış';
      case 'user-not-found':
        return 'Kullanıcı bulunamadı';
      default:
        return 'Giriş hatası: ${e.message}';
    }
  }
}
