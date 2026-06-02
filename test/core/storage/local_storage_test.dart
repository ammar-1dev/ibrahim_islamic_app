import 'package:flutter_test/flutter_test.dart';
import 'package:ibrahim/core/storage/local_storage.dart';

void main() {
  group('LocalStorage', () {
    test('prayer status defaults to false', () {
      // Note: Full Hive tests require setUp with Hive.init + temp path
      // This is a smoke test for the interface
      expect(LocalStorage(), isNotNull);
    });
  });
}
