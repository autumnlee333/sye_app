import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/custom_list_model.dart';
import '../services/list_service.dart';
import 'auth_provider.dart';

/// Provider for the [ListService].
final listServiceProvider = Provider<ListService>((ref) {
  return ListService();
});

/// Streams all custom lists for the currently authenticated user.
final userListsProvider = StreamProvider<List<CustomListModel>>((ref) {
  final userId = ref.watch(authProvider).value?.uid;
  if (userId == null) return Stream.value([]);
  
  return ref.watch(listServiceProvider).watchUserLists(userId);
});

/// Notifier to manage custom list actions.
class ListNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createList(String name, String description, bool isPrivate) async {
    final userId = ref.read(authProvider).value?.uid;
    if (userId == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final list = CustomListModel(
        id: const Uuid().v4(),
        ownerId: userId,
        name: name,
        description: description,
        isPrivate: isPrivate,
        createdAt: DateTime.now(),
      );
      await ref.read(listServiceProvider).createList(list);
    });
  }

  Future<void> addBookToList(String listId, String bookId) async {
    final userId = ref.read(authProvider).value?.uid;
    if (userId == null) return;

    state = await AsyncValue.guard(() async {
      await ref.read(listServiceProvider).addBookToList(userId, listId, bookId);
    });
  }

  Future<void> removeBookFromList(String listId, String bookId) async {
    final userId = ref.read(authProvider).value?.uid;
    if (userId == null) return;

    state = await AsyncValue.guard(() async {
      await ref.read(listServiceProvider).removeBookFromList(userId, listId, bookId);
    });
  }

  Future<void> deleteList(String listId) async {
    final userId = ref.read(authProvider).value?.uid;
    if (userId == null) return;

    state = await AsyncValue.guard(() async {
      await ref.read(listServiceProvider).deleteList(userId, listId);
    });
  }
}

final listActionProvider = AsyncNotifierProvider<ListNotifier, void>(
  ListNotifier.new,
);
