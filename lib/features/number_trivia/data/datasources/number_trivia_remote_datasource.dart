import 'dart:convert';

import 'package:flutter_number_trivia/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDatasource {
  /// Calls the http://numbersapi.com/{number}
  /// Throws a [ServerException] for any error
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random
  /// Throws a [CacheException] for any error
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDatasourceImpl implements NumberTriviaRemoteDatasource {
  final http.Client client;

  NumberTriviaRemoteDatasourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) {
    return _getTrivia(number.toString());
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return _getTrivia('random');
  }

  Future<NumberTriviaModel> _getTrivia(String endpoint) async {
    final res = await client.get(
      Uri.http('numberapi.com', endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (res.statusCode == 200) {
      return NumberTriviaModel.fromJSON(json.decode(res.body));
    } else {
      throw ServerException();
    }
  }
}
