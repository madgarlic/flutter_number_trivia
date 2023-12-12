import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDatasource {
  /// Calls the http://numbersapi.com/{number}
  /// Throws a [ServerException] for any error
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random
  /// Throws a [CacheException] for any error
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
