import 'package:flutter_riverpod/legacy.dart';

/// A simple state provider to track selected book IDs for batch operations.
final selectedBookIdsProvider = StateProvider<Set<String>>((ref) => {});

/// A provider to track if the app is currently in "Batch Mode".
final isBatchModeProvider = StateProvider<bool>((ref) => false);
