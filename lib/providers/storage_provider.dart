import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

/// Provider for the [StorageService].
/// This provider is initially unimplemented and must be overridden in the
/// [ProviderScope] within `main.dart` after the initialization of
/// [SharedPreferences].
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('storageServiceProvider must be overridden in ProviderScope');
});
