import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/goal_model.dart';
import '../models/library_book_model.dart';
import '../services/goal_service.dart';
import 'auth_provider.dart';
import 'library_provider.dart';

/// Provider for the [GoalService].
final goalServiceProvider = Provider<GoalService>((ref) {
  return GoalService();
});

/// Streams all goals for the current user and year.
final userGoalsProvider = StreamProvider<List<GoalModel>>((ref) {
  final authState = ref.watch(authProvider);
  final goalService = ref.watch(goalServiceProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream.value([]);
      // We pass the UID explicitly to ensure we are watching the correct path
      return goalService.watchGoals(user.uid, DateTime.now().year);
    },
    loading: () => const Stream.empty(),
    error: (e, st) => Stream.error(e, st),
  );
});

/// A provider that calculates the current progress for all goals.
final goalProgressProvider = Provider<AsyncValue<List<GoalModel>>>((ref) {
  final userGoalsAsync = ref.watch(userGoalsProvider);
  final userLibraryAsync = ref.watch(userLibraryProvider);

  return userGoalsAsync.when(
    data: (goals) {
      return userLibraryAsync.when(
        data: (library) {
          final currentYear = DateTime.now().year;
          // Only consider books finished this year
          final finishedThisYear = library.where((b) => 
            b.status == ReadingStatus.finished && 
            b.addedAt.year == currentYear
          ).toList();

          final processedGoals = goals.map((goal) {
            int progress = 0;
            switch (goal.type) {
              case GoalType.totalBooks:
                progress = finishedThisYear.length;
                break;
              case GoalType.genreCount:
                if (goal.metadata != null && goal.metadata!.isNotEmpty) {
                  progress = finishedThisYear.where((b) => 
                    b.categories.any((c) => c.toLowerCase() == goal.metadata!.toLowerCase())
                  ).length;
                }
                break;
              case GoalType.pageThreshold:
                if (goal.metadata != null) {
                  final threshold = int.tryParse(goal.metadata!) ?? 0;
                  progress = finishedThisYear.where((b) => b.totalPages >= threshold).length;
                }
                break;
            }
            return goal.copyWith(currentValue: progress);
          }).toList();
          return AsyncValue.data(processedGoals);
        },
        loading: () => const AsyncValue.loading(),
        error: (e, st) => AsyncValue.error(e, st),
      );
    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

/// A notifier to manage goal actions.
class GoalNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addGoal(GoalModel goal) async {
    final user = ref.read(authProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(goalServiceProvider).saveGoal(user.uid, goal);
    });
  }

  Future<void> deleteGoal(String goalId) async {
    final user = ref.read(authProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(goalServiceProvider).deleteGoal(user.uid, goalId);
    });
  }
}

final goalActionProvider = AsyncNotifierProvider<GoalNotifier, void>(
  GoalNotifier.new,
);
