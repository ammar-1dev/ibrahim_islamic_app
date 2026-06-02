import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../storage/local_storage.dart';
import '../utils/location_service.dart';
import '../utils/notification_service.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient();
  client.init();
  return client;
});

final dioProvider = Provider<Dio>((ref) {
  return ref.read(apiClientProvider).dio;
});

final localStorageProvider = Provider<LocalStorage>((ref) {
  return LocalStorage();
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
