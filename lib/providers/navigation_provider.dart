import 'package:flutter_riverpod/legacy.dart';

/// Provider to track the current index of the BottomNavigationBar.
final navigationIndexProvider = StateProvider<int>((ref) => 0);
