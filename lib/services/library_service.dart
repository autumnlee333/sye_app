import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/library_book_model.dart';

class LibraryService {
  final FirebaseFirestore _firestore;

  LibraryService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _libraryCollection(String uid) =>
      _firestore.collection('users').doc(uid).collection('library');

  /// Adds a book to the user's library or updates its status if it already exists.
  Future<void> addBookToLibrary(String uid, LibraryBookModel book) async {
    try {
      await _libraryCollection(uid).doc(book.bookId).set(book.toJson());
    } catch (e) {
      rethrow;
    }
  }

  /// Removes a book from the user's library.
  Future<void> removeBookFromLibrary(String uid, String bookId) async {
    try {
      await _libraryCollection(uid).doc(bookId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Updates the reading status of a book in the library.
  Future<void> updateBookStatus(String uid, String bookId, ReadingStatus status) async {
    try {
      await _libraryCollection(uid).doc(bookId).update({
        'status': status.name, // Using status.name because of @JsonValue mapping in model
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Streams the entire library for a specific user.
  Stream<List<LibraryBookModel>> watchLibrary(String uid) {
    return _libraryCollection(uid)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => LibraryBookModel.fromJson(doc.data())).toList();
    });
  }
}
