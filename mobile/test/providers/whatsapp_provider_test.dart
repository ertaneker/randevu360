import 'package:flutter_test/flutter_test.dart';

import 'package:esnaftakvim/providers/whatsapp_provider.dart';

// ---------------------------------------------------------------------------
// WhatsAppProvider — unit tests for state management and computed properties.
// Network-dependent methods (requestPairingCode, sendMessage, sendBulk, etc.)
// require HTTP mocking and are tested via integration tests.
// ---------------------------------------------------------------------------
void main() {
  group('Initial state', () {
    test('all properties have expected defaults', () {
      final provider = WhatsAppProvider();

      expect(provider.isConnected, false);
      expect(provider.isPairing, false);
      expect(provider.pairingCode, isNull);
      expect(provider.connectionStatus, isNull);
      expect(provider.error, isNull);
      expect(provider.messageLogs, isEmpty);
    });
  });

  group('clearError', () {
    test('sets error to null and notifies listeners', () {
      final provider = WhatsAppProvider();
      var notifiedCount = 0;
      provider.addListener(() => notifiedCount++);

      provider.clearError();

      expect(provider.error, isNull);
      expect(notifiedCount, 1);
    });
  });

  group('Connection state', () {
    test('isConnected starts as false', () {
      final provider = WhatsAppProvider();

      expect(provider.isConnected, false);
    });

    test('isPairing starts as false', () {
      final provider = WhatsAppProvider();

      expect(provider.isPairing, false);
    });

    test('pairingCode starts as null', () {
      final provider = WhatsAppProvider();

      expect(provider.pairingCode, isNull);
    });

    test('messageLogs starts empty', () {
      final provider = WhatsAppProvider();

      expect(provider.messageLogs, isEmpty);
      expect(provider.messageLogs.length, 0);
    });
  });
}
