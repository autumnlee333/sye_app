import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sye_app/models/user_model.dart';
import 'package:sye_app/services/user_service.dart';

// Mocks for Firestore classes
// These "fake" versions allow us to test the service without a real internet connection.
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late UserService userService;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocument;
  late MockDocumentSnapshot mockSnapshot;

  // 1. Setup "Ground Truth" data.
  final tUserModel = UserModel(
    uid: '123',
    displayName: 'Autumn',
    bio: 'Tester',
    profilePicUrl: 'url',
    favoriteGenres: ['Fantasy'],
  );

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocument = MockDocumentReference();
    mockSnapshot = MockDocumentSnapshot();

    // Setup the "Chain of Command": 
    // Any call to firestore.collection() -> returns our mock collection.
    // Any call to collection.doc() -> returns our mock document.
    when(() => mockFirestore.collection(any())).thenReturn(mockCollection);
    when(() => mockCollection.doc(any())).thenReturn(mockDocument);
    
    // Inject the mock into our service (Dependency Injection).
    userService = UserService(firestore: mockFirestore);
  });

  group('UserService Tests', () {
    // 2. Test "Create/Update" logic.
    // Verifies the service tells Firestore to save data in the correct document.
    test('saveUser calls Firestore set with correct data', () async {
      // ARRANGE: Tell the mock to succeed when .set() is called.
      when(() => mockDocument.set(any())).thenAnswer((_) async => {});

      // ACT: Trigger the save method.
      await userService.saveUser(tUserModel);

      // ASSERT: Verify the service targeted the right UID and sent the correct JSON.
      verify(() => mockCollection.doc(tUserModel.uid)).called(1);
      verify(() => mockDocument.set(tUserModel.toJson())).called(1);
    });

    // 3. Test "Successful Retrieval" logic.
    // Verifies the service can translate a Firestore response back into a UserModel.
    test('getUser returns UserModel when document exists', () async {
      // ARRANGE: Setup the mock to say "Yes, this document exists" and return data.
      when(() => mockDocument.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(true);
      when(() => mockSnapshot.data()).thenReturn(tUserModel.toJson());

      // ACT: Request the user data.
      final result = await userService.getUser('123');

      // ASSERT: Verify the service correctly converted the Firestore map into our model.
      expect(result, tUserModel);
      verify(() => mockDocument.get()).called(1);
    });

    // 4. Test "Failed Retrieval" logic.
    // Verifies the service handles a missing user document gracefully.
    test('getUser returns null when document does not exist', () async {
      // ARRANGE: Setup the mock to say "No, this document doesn't exist."
      when(() => mockDocument.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(false);

      // ACT: Request the missing user data.
      final result = await userService.getUser('123');

      // ASSERT: Verify the service returns null instead of throwing an error.
      expect(result, null);
    });
  });
}
