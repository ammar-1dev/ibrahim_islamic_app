import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/local_storage.dart';

final onboardingDoneProvider = Provider<bool>((ref) {
  final storage = LocalStorage();
  return storage.getBool('onboarding_done', defaultValue: false);
});
