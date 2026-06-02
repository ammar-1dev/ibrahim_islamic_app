import 'package:flutter_test/flutter_test.dart';
import 'package:ibrahim/core/network/api_client.dart';

void main() {
  group('ApiClient', () {
    test('init configures Dio instance', () {
      final client = ApiClient();
      client.init();
      expect(client.dio, isNotNull);
      expect(client.dio.options.connectTimeout, const Duration(seconds: 30));
      expect(client.dio.options.receiveTimeout, const Duration(seconds: 30));
    });
  });
}
