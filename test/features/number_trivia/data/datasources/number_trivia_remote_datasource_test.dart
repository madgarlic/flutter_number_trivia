import 'dart:convert';

import 'package:flutter_number_trivia/core/error/exceptions.dart';
import 'package:flutter_number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:flutter_number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDatasource dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDatasourceImpl(client: mockHttpClient);
    registerFallbackValue(Uri.http('google.it'));
  });
  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tFixture = fixture('trivia.json');
    final tNumberTriviaModel =
        NumberTriviaModel.fromJSON(json.decode(tFixture));
    test('''sholud perform http request on url with tNumber as the endpoint
        and header with application/json ''', () async {
      // arrange
      setupMockHttpSuccess200(mockHttpClient, tFixture);
      // act
      dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(() => mockHttpClient.get(
            Uri.http('numberapi.com', '$tNumber'),
            headers: {
              'Content-Type': 'application/json',
            },
          ));
    });

    test('''sholud return NumberTriviaModel when status code is 200 ''',
        () async {
      // arrange
      setupMockHttpSuccess200(mockHttpClient, tFixture);

      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, tNumberTriviaModel);
    });

    test('''sholud throw ServerException when status code is not 200 ''',
        () async {
      // arrange
      setupoMockHttpError404(mockHttpClient);
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tFixture = fixture('trivia.json');
    final tNumberTriviaModel =
        NumberTriviaModel.fromJSON(json.decode(tFixture));
    test('''sholud perform http request on url with random as the endpoint
        and header with application/json ''', () async {
      // arrange
      setupMockHttpSuccess200(mockHttpClient, tFixture);
      // act
      dataSource.getRandomNumberTrivia();
      // assert
      verify(() => mockHttpClient.get(
            Uri.http('numberapi.com', 'random'),
            headers: {
              'Content-Type': 'application/json',
            },
          ));
    });

    test('''sholud return NumberTriviaModel when status code is 200 ''',
        () async {
      // arrange
      setupMockHttpSuccess200(mockHttpClient, tFixture);

      // act
      final result = await dataSource.getRandomNumberTrivia();
      // assert
      expect(result, tNumberTriviaModel);
    });

    test('''sholud throw ServerException when status code is not 200 ''',
        () async {
      // arrange
      setupoMockHttpError404(mockHttpClient);
      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}

void setupoMockHttpError404(MockHttpClient mockHttpClient) {
  when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
      .thenAnswer((_) async => http.Response('Error!', 404));
}

void setupMockHttpSuccess200(MockHttpClient mockHttpClient, String tFixture) {
  when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
      .thenAnswer((_) async => http.Response(tFixture, 200));
}
