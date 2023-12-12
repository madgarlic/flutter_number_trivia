import 'dart:convert';

import 'package:flutter_number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');
  test('should be a subclass of NumberTrivia entity', () {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJSON', () {
    test('should return a valid model when json number is an integer',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      // act
      final result = NumberTriviaModel.fromJSON(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });
    test('should return a valid model when json number is a double', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      // act
      final result = NumberTriviaModel.fromJSON(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJSON', () {
    test('should retorn a JSON map with proper data', () async {
      // arrange
      // act
      final result = tNumberTriviaModel.toJSON();
      // assert
      const expected = {'text': 'Test text', 'number': 1};
      expect(result, expected);
    });
  });
}
