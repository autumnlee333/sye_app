import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/library_book_model.dart';
import '../models/progress_update_model.dart';

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
        'status': status.name,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Removes multiple books from the user's library.
  Future<void> removeBooksFromLibrary(String uid, List<String> bookIds) async {
    final batch = _firestore.batch();
    for (final id in bookIds) {
      batch.delete(_libraryCollection(uid).doc(id));
    }
    await batch.commit();
  }

  /// Updates the reading status of multiple books.
  Future<void> updateBooksStatus(String uid, List<String> bookIds, ReadingStatus status) async {
    final batch = _firestore.batch();
    for (final id in bookIds) {
      batch.update(_libraryCollection(uid).doc(id), {
        'status': status.name,
      });
    }
    await batch.commit();
  }

  /// Updates the reading progress of a book and adds an entry to the history.
  Future<void> updateProgress(String uid, String bookId, int currentPage, int totalPages, {String? comment}) async {
    try {
      final batch = _firestore.batch();
      
      // Update the book document
      batch.update(_libraryCollection(uid).doc(bookId), {
        'currentPage': currentPage,
        'totalPages': totalPages,
      });

      // Add to history sub-collection
      final historyRef = _libraryCollection(uid).doc(bookId).collection('progress_history').doc();
      batch.set(historyRef, {
        'id': historyRef.id,
        'bookId': bookId,
        'page': currentPage,
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  /// Streams the progress history for a specific book.
  Stream<List<ProgressUpdateModel>> watchProgressHistory(String uid, String bookId) {
    return _libraryCollection(uid)
        .doc(bookId)
        .collection('progress_history')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Convert Timestamp to ISO8601 string for the model's DateTime.fromJson
        if (data['timestamp'] is Timestamp) {
          data['timestamp'] = (data['timestamp'] as Timestamp).toDate().toIso8601String();
        }
        return ProgressUpdateModel.fromJson(data);
      }).toList();
    });
  }

  /// Streams the entire library for a specific user.
  Stream<List<LibraryBookModel>> watchLibrary(String uid) {
    return _libraryCollection(uid)
        .orderBy('addedAt', descending: true)
        .limit(200)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => LibraryBookModel.fromJson(doc.data())).toList();
    });
  }
}
