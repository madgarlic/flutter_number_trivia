import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDatasource {
  /// Gets cached [NumberTriviaModel]
  /// Throws no [NoLocalDataException] if nothing is found
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const String cachedNumberTriviaKey = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDatasource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    String? jsonString = sharedPreferences.getString(cachedNumberTriviaKey);
    if (jsonString == null) throw NoLocalDataException();
    var triviaModel = NumberTriviaModel.fromJSON(json.decode(jsonString));
    return Future.value(triviaModel);
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(
      cachedNumberTriviaKey,
      json.encode(triviaToCache.toJSON()),
    );
  }
}
