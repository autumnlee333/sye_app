import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sye_app/services/follow_service.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockWriteBatch extends Mock implements WriteBatch {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}

void main() {
  late FollowService followService;
  late MockFirebaseFirestore mockFirestore;
  late MockWriteBatch mockBatch;
  late MockCollectionReference mockUsersCollection;
  late MockDocumentReference mockFollowerDoc;
  late MockDocumentReference mockFollowedDoc;
  late MockCollectionReference mockFollowingSubCollection;
  late MockCollectionReference mockFollowersSubCollection;
  late MockDocumentReference mockFollowingItemDoc;
  late MockDocumentReference mockFollowersItemDoc;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockBatch = MockWriteBatch();
    mockUsersCollection = MockCollectionReference();
    mockFollowerDoc = MockDocumentReference();
    mockFollowedDoc = MockDocumentReference();
    mockFollowingSubCollection = MockCollectionReference();
    mockFollowersSubCollection = MockCollectionReference();
    mockFollowingItemDoc = MockDocumentReference();
    mockFollowersItemDoc = MockDocumentReference();

    registerFallbackValue(mockFollowingItemDoc);

    when(() => mockFirestore.batch()).thenReturn(mockBatch);
    when(() => mockFirestore.collection('users')).thenReturn(mockUsersCollection);
    when(() => mockUsersCollection.doc('follower_id')).thenReturn(mockFollowerDoc);
    when(() => mockUsersCollection.doc('followed_id')).thenReturn(mockFollowedDoc);
    
    when(() => mockFollowerDoc.collection('following')).thenReturn(mockFollowingSubCollection);
    when(() => mockFollowedDoc.collection('followers')).thenReturn(mockFollowersSubCollection);
    
    when(() => mockFollowingSubCollection.doc('followed_id')).thenReturn(mockFollowingItemDoc);
    when(() => mockFollowersSubCollection.doc('follower_id')).thenReturn(mockFollowersItemDoc);
    
    when(() => mockBatch.commit()).thenAnswer((_) async => {});
    
    // Explicitly handle the generic set method
    when(() => mockBatch.set<Map<String, dynamic>>(any(), any(), any())).thenReturn(null);
    when(() => mockBatch.update(any(), any())).thenReturn(null);
    when(() => mockBatch.delete(any())).thenReturn(null);

    followService = FollowService(firestore: mockFirestore);
  });

  group('FollowService Tests', () {
    test('followUser commits a batch with correct updates', () async {
      await followService.followUser('follower_id', 'followed_id');

      verify(() => mockBatch.set<Map<String, dynamic>>(any(), any())).called(2);
      verify(() => mockBatch.update(mockFollowerDoc, any())).called(1);
      verify(() => mockBatch.update(mockFollowedDoc, any())).called(1);
      verify(() => mockBatch.commit()).called(1);
    });

    test('unfollowUser commits a batch with correct updates', () async {
      await followService.unfollowUser('follower_id', 'followed_id');

      verify(() => mockBatch.delete(mockFollowingItemDoc)).called(1);
      verify(() => mockBatch.delete(mockFollowersItemDoc)).called(1);
      verify(() => mockBatch.update(mockFollowerDoc, any())).called(1);
      verify(() => mockBatch.update(mockFollowedDoc, any())).called(1);
      verify(() => mockBatch.commit()).called(1);
    });
  });
}
