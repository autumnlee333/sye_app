import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/custom_list_model.dart';

class ListService {
  final FirebaseFirestore _firestore;

  ListService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _listsCollection =>
      _firestore.collection('customLists');

  /// Creates a new custom list.
  Future<void> createList(CustomListModel list) async {
    await _listsCollection.doc(list.id).set(list.toJson());
  }

  /// Updates an existing list's details (name, description, privacy).
  Future<void> updateList(String listId, Map<String, dynamic> updates) async {
    await _listsCollection.doc(listId).update(updates);
  }

  /// Deletes a custom list. Only the owner should be able to do this.
  Future<void> deleteList(String listId) async {
    await _listsCollection.doc(listId).delete();
  }

  /// Adds a book to a custom list.
  Future<void> addBookToList(String listId, String bookId) async {
    await _listsCollection.doc(listId).update({
      'bookIds': FieldValue.arrayUnion([bookId]),
    });
  }

  /// Removes a book from a custom list.
  Future<void> removeBookFromList(String listId, String bookId) async {
    await _listsCollection.doc(listId).update({
      'bookIds': FieldValue.arrayRemove([bookId]),
    });
  }

  /// Adds multiple books to a custom list.
  Future<void> addBooksToList(String listId, List<String> bookIds) async {
    await _listsCollection.doc(listId).update({
      'bookIds': FieldValue.arrayUnion(bookIds),
    });
  }

  /// Removes multiple books from a custom list.
  Future<void> removeBooksFromList(String listId, List<String> bookIds) async {
    await _listsCollection.doc(listId).update({
      'bookIds': FieldValue.arrayRemove(bookIds),
    });
  }

  /// Adds a collaborator to the list.
  Future<void> addCollaborator(String listId, String userId) async {
    await _listsCollection.doc(listId).update({
      'collaboratorIds': FieldValue.arrayUnion([userId]),
    });
  }

  /// Removes a collaborator from the list.
  Future<void> removeCollaborator(String listId, String userId) async {
    await _listsCollection.doc(listId).update({
      'collaboratorIds': FieldValue.arrayRemove([userId]),
    });
  }

  /// Streams all custom lists that a user either owns or is a collaborator on.
  Stream<List<CustomListModel>> watchUserAccessibleLists(String userId) {
    // We need two queries because Firestore doesn't support 'OR' across different fields easily 
    // without multiple 'where' clauses which might require composite indexes.
    // However, we can use a query on ownerId and a query on collaboratorIds and merge them,
    // or use Filter.or if available in the current SDK version.
    
    return _listsCollection
        .where(
          Filter.or(
            Filter('ownerId', isEqualTo: userId),
            Filter('collaboratorIds', arrayContains: userId),
          ),
        )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CustomListModel.fromJson(doc.data()))
          .toList();
    });
  }

  /// Fetches a single list by ID.
  Future<CustomListModel?> getList(String listId) async {
    final doc = await _listsCollection.doc(listId).get();
    if (doc.exists && doc.data() != null) {
      return CustomListModel.fromJson(doc.data()!);
    }
    return null;
  }
}
