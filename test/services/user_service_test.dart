import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sye_app/models/user_model.dart';
import 'package:sye_app/services/user_service.dart';

// Mocks for Firestore classes
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

    // Setup the hierarchy of Firestore calls
    when(() => mockFirestore.collection(any())).thenReturn(mockCollection);
    when(() => mockCollection.doc(any())).thenReturn(mockDocument);
    
    userService = UserService(firestore: mockFirestore);
  });

  group('UserService Tests', () {
    test('saveUser calls Firestore set with correct data', () async {
      // ARRANGE
      when(() => mockDocument.set(any())).thenAnswer((_) async => {});

      // ACT
      await userService.saveUser(tUserModel);

      // ASSERT
      verify(() => mockCollection.doc(tUserModel.uid)).called(1);
      verify(() => mockDocument.set(tUserModel.toJson())).called(1);
    });

    test('getUser returns UserModel when document exists', () async {
      // ARRANGE
      when(() => mockDocument.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(true);
      when(() => mockSnapshot.data()).thenReturn(tUserModel.toJson());

      // ACT
      final result = await userService.getUser('123');

      // ASSERT
      expect(result, tUserModel);
      verify(() => mockDocument.get()).called(1);
    });

    test('getUser returns null when document does not exist', () async {
      // ARRANGE
      when(() => mockDocument.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(false);

      // ACT
      final result = await userService.getUser('123');

      // ASSERT
      expect(result, null);
    });
  });
}
