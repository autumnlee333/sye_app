import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/custom_list_model.dart';

class ListService {
  final FirebaseFirestore _firestore;

  ListService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _listsCollection(String userId) =>
      _firestore.collection('users').doc(userId).collection('customLists');

  /// Creates a new custom list for a user.
  Future<void> createList(CustomListModel list) async {
    await _listsCollection(list.ownerId).doc(list.id).set(list.toJson());
  }

  /// Updates an existing list's details (name, description, privacy).
  Future<void> updateList(String userId, String listId, Map<String, dynamic> updates) async {
    await _listsCollection(userId).doc(listId).update(updates);
  }

  /// Deletes a custom list.
  Future<void> deleteList(String userId, String listId) async {
    await _listsCollection(userId).doc(listId).delete();
  }

  /// Adds a book to a custom list.
  Future<void> addBookToList(String userId, String listId, String bookId) async {
    await _listsCollection(userId).doc(listId).update({
      'bookIds': FieldValue.arrayUnion([bookId]),
    });
  }

  /// Removes a book from a custom list.
  Future<void> removeBookFromList(String userId, String listId, String bookId) async {
    await _listsCollection(userId).doc(listId).update({
      'bookIds': FieldValue.arrayRemove([bookId]),
    });
  }

  /// Streams all custom lists for a specific user.
  Stream<List<CustomListModel>> watchUserLists(String userId) {
    return _listsCollection(userId).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => CustomListModel.fromJson(doc.data()))
          .toList();
    });
  }

  /// Fetches a single list by ID.
  Future<CustomListModel?> getList(String userId, String listId) async {
    final doc = await _listsCollection(userId).doc(listId).get();
    if (doc.exists && doc.data() != null) {
      return CustomListModel.fromJson(doc.data()!);
    }
    return null;
  }
}
