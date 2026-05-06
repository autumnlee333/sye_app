import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/custom_list_model.dart';
import '../services/list_service.dart';
import 'auth_provider.dart';

/// Provider for the [ListService].
final listServiceProvider = Provider<ListService>((ref) {
  return ListService();
});

/// Streams all custom lists for the currently authenticated user (owned or collaborating).
final accessibleListsProvider = StreamProvider<List<CustomListModel>>((ref) {
  final userId = ref.watch(authProvider).value?.uid;
  if (userId == null) return Stream.value([]);
  
  return ref.watch(listServiceProvider).watchUserAccessibleLists(userId);
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
    state = await AsyncValue.guard(() async {
      await ref.read(listServiceProvider).addBookToList(listId, bookId);
    });
  }

  Future<void> removeBookFromList(String listId, String bookId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(listServiceProvider).removeBookFromList(listId, bookId);
    });
  }

  Future<void> bulkAddBooksToList(String listId, List<String> bookIds) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(listServiceProvider).addBooksToList(listId, bookIds);
    });
  }

  Future<void> bulkRemoveBooksFromList(String listId, List<String> bookIds) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(listServiceProvider).removeBooksFromList(listId, bookIds);
    });
  }

  Future<void> addCollaborator(String listId, String collaboratorId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(listServiceProvider).addCollaborator(listId, collaboratorId);
    });
  }

  Future<void> removeCollaborator(String listId, String collaboratorId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(listServiceProvider).removeCollaborator(listId, collaboratorId);
    });
  }

  Future<void> deleteList(String listId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(listServiceProvider).deleteList(listId);
    });
  }
}

final listActionProvider = AsyncNotifierProvider<ListNotifier, void>(
  ListNotifier.new,
);
