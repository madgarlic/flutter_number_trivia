import 'dart:convert';

import 'package:flutter_number_trivia/core/error/exceptions.dart';
import 'package:flutter_number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastNumberTrivia', () {
    final tCachedTriviaFixture = fixture('trivia_cached.json');
    final tCachedTriviaJson = json.decode(tCachedTriviaFixture);
    final tNumberTriviaModel = NumberTriviaModel.fromJSON(tCachedTriviaJson);
    test(
        'should retrun NumberTriviaModel from SharedPreferences when there is one in the cache',
        () async {
      // arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(tCachedTriviaFixture);
      // act
      final result = await dataSource.getLastNumberTrivia();
      // assert
      verify(() => mockSharedPreferences.getString(cachedNumberTriviaKey));
      expect(result, tNumberTriviaModel);
    });

    test(
        'should retrun NoLocalDataException when there is no data in the cache',
        () async {
      // arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      // act
      final call = dataSource.getLastNumberTrivia;
      // assert
      expect(() => call(), throwsA(isA<NoLocalDataException>()));
      verify(() => mockSharedPreferences.getString(cachedNumberTriviaKey));
    });
  });

  group('cacheNuberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(
      number: 1,
      text: "Test text",
    );
    test('sholud call SharedPreferences to cache the data', () async {
      // arrange
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);
      // act
      await dataSource.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      final tCachedTriviaFixture = fixture('trivia_cached.json');
      verify(() => mockSharedPreferences.setString(
            cachedNumberTriviaKey,
            json.encode(tCachedTriviaFixture),
          ));
    });
  });
}
