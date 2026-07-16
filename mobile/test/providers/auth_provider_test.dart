import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart' show User, UserCredential;

import 'package:randevu360/core/auth/auth_service.dart';
import 'package:randevu360/providers/auth_provider.dart';

// ---------------------------------------------------------------------------
// Manual mock for IAuthService — no real Firebase calls, usable in tests
// without Firebase initialization.
// ---------------------------------------------------------------------------
class MockAuthService implements IAuthService {
  final StreamController<User?> _controller =
      StreamController<User?>.broadcast();

  bool signOutCalled = false;
  bool deleteAccountCalled = false;

  @override
  Stream<User?> get authStateChanges => _controller.stream;

  @override
  User? get currentUser => null;

  @override
  Future<UserCredential?> signInWithGoogle() async {
    throw Exception('Simulated sign-in failure');
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }

  @override
  Future<void> deleteAccount() async {
    deleteAccountCalled = true;
  }

  /// Emit a null or non-null user on the auth state stream.
  void emitAuthState(User? user) => _controller.add(user);

  void disposeMock() => _controller.close();
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------
void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  tearDown(() {
    mockAuthService.disposeMock();
  });

  group('Initial state', () {
    test('status is loading and user is null on creation', () {
      final provider = AuthProvider(authService: mockAuthService);

      expect(provider.status, AuthStatus.loading);
      expect(provider.user, isNull);
      expect(provider.isAuthenticated, false);
      expect(provider.errorMessage, isNull);
      expect(provider.businessData, isNull);
    });
  });

  group('signInWithGoogle', () {
    test('sets status to error and returns false on failure', () async {
      final provider = AuthProvider(authService: mockAuthService);

      final result = await provider.signInWithGoogle();

      expect(result, false);
      expect(provider.status, AuthStatus.error);
      expect(provider.errorMessage, isNotEmpty);
    });

    test('sets status to authenticating during the sign-in process', () async {
      final provider = AuthProvider(authService: mockAuthService);

      // Start sign-in but don't await — capture the future.
      final future = provider.signInWithGoogle();

      expect(provider.status, AuthStatus.authenticating);
      expect(provider.errorMessage, isNull);

      await future;
    });

    test('clears previous error before starting', () async {
      final provider = AuthProvider(authService: mockAuthService);

      // Force an error state first.
      await provider.signInWithGoogle();
      expect(provider.status, AuthStatus.error);

      // Start a new sign-in attempt.
      await provider.signInWithGoogle();
      // After the failed attempt, it should still be in error with a message.
      expect(provider.status, AuthStatus.error);
      expect(provider.errorMessage, isNotEmpty);
    });
  });

  group('signOut', () {
    test('resets state and delegates to IAuthService.signOut', () async {
      final provider = AuthProvider(authService: mockAuthService);

      await provider.signOut();

      expect(provider.user, isNull);
      expect(provider.status, AuthStatus.unauthenticated);
      expect(provider.businessData, isNull);
      expect(mockAuthService.signOutCalled, true);
    });
  });

  group('deleteAccount', () {
    test('resets state and delegates to IAuthService.deleteAccount', () async {
      final provider = AuthProvider(authService: mockAuthService);

      await provider.deleteAccount();

      expect(provider.user, isNull);
      expect(provider.status, AuthStatus.unauthenticated);
      expect(mockAuthService.deleteAccountCalled, true);
    });
  });

  group('clearError', () {
    test('clears error message and sets status to unauthenticated', () {
      final provider = AuthProvider(authService: mockAuthService);

      provider.clearError();

      expect(provider.errorMessage, isNull);
      expect(provider.status, AuthStatus.unauthenticated);
    });
  });

  group('Auth state listener', () {
    test('sets unauthenticated when stream emits null user', () async {
      final provider = AuthProvider(authService: mockAuthService);

      // Wait for _checkAuthState microtask to subscribe to the stream first
      await Future<void>.microtask(() {});
      mockAuthService.emitAuthState(null);

      // Let the async subscription callback process.
      await Future<void>.microtask(() {});

      expect(provider.status, AuthStatus.unauthenticated);
      expect(provider.user, isNull);
    });
  });
}
