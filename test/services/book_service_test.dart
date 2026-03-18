import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:sye_app/services/book_service.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late BookService bookService;
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    bookService = BookService(client: mockHttpClient);
  });

  group('BookService', () {
    test('searchBooks returns a list of BookModel on success', () async {
      const query = 'flutter';
      const mockResponseBody = '''
      {
        "items": [
          {
            "id": "1",
            "volumeInfo": {
              "title": "Flutter in Action",
              "authors": ["Eric Windmill"],
              "description": "A great book.",
              "imageLinks": {
                "thumbnail": "http://image.com/1"
              }
            }
          }
        ]
      }
      ''';

      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response(mockResponseBody, 200),
      );

      final results = await bookService.searchBooks(query);

      expect(results.length, 1);
      expect(results[0].title, 'Flutter in Action');
      expect(results[0].authors, ['Eric Windmill']);
      expect(results[0].thumbnailUrl, 'https://image.com/1'); // Check https conversion
    });

    test('searchBooks returns empty list if no items', () async {
      const mockResponseBody = '{"items": []}';

      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response(mockResponseBody, 200),
      );

      final results = await bookService.searchBooks('unknown');

      expect(results, isEmpty);
    });

    test('searchBooks throws exception on error', () async {
      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      expect(() => bookService.searchBooks('flutter'), throwsException);
    });
  });
}
