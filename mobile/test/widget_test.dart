import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart' show User, UserCredential;
import 'package:provider/provider.dart';

import 'package:esnaftakvim/core/auth/auth_service.dart';
import 'package:esnaftakvim/core/l10n/l10n_ext.dart';
import 'package:esnaftakvim/providers/auth_provider.dart';
import 'package:esnaftakvim/screens/auth/login_screen.dart';

// ---------------------------------------------------------------------------
// Manual mock for IAuthService — no real Firebase calls.
// ---------------------------------------------------------------------------
class MockAuthService implements IAuthService {
  final StreamController<User?> _controller =
      StreamController<User?>.broadcast();

  @override
  Stream<User?> get authStateChanges => _controller.stream;

  @override
  User? get currentUser => null;

  @override
  Future<UserCredential?> signInWithGoogle() async => null;

  @override
  Future<void> signOut() async {}

  @override
  Future<void> deleteAccount() async {}

  void emitAuthState(User? user) => _controller.add(user);

  void disposeMock() => _controller.close();
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('App smoke test', () {
    testWidgets('LoginScreen renders core branding text', (tester) async {
      final mockAuth = MockAuthService();
      addTearDown(() => mockAuth.disposeMock());

      // Emit null so the provider settles in unauthenticated state.
      mockAuth.emitAuthState(null);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(
              create: (_) => AuthProvider(authService: mockAuth),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('tr'),
            home: LoginScreen(),
          ),
        ),
      );
      // Let the auth stream listener process and the first frame render.
      await tester.pump();

      expect(find.text('Esnaf Takvim'), findsOneWidget);
    });

    testWidgets('LoginScreen shows Google sign-in button', (tester) async {
      final mockAuth = MockAuthService();
      addTearDown(() => mockAuth.disposeMock());

      mockAuth.emitAuthState(null);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(
              create: (_) => AuthProvider(authService: mockAuth),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('tr'),
            home: LoginScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Google ile Giriş Yap'), findsOneWidget);
    });

    testWidgets('LoginScreen shows terms text', (tester) async {
      final mockAuth = MockAuthService();
      addTearDown(() => mockAuth.disposeMock());

      mockAuth.emitAuthState(null);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(
              create: (_) => AuthProvider(authService: mockAuth),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('tr'),
            home: LoginScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.text('Giriş yaparak Kullanım Koşulları\'nı kabul etmiş olursunuz'),
        findsOneWidget,
      );
    });
  });
}
