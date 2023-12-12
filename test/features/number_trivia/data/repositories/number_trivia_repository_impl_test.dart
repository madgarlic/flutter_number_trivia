import 'package:dartz/dartz.dart';
import 'package:flutter_number_trivia/core/error/exceptions.dart';
import 'package:flutter_number_trivia/core/error/failures.dart';
import 'package:flutter_number_trivia/core/network/network_info.dart';
import 'package:flutter_number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:flutter_number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDatasource extends Mock
    implements NumberTriviaRemoteDatasource {}

class MockLocalDatasource extends Mock implements NumberTriviaLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDatasource mockRemoteDatasource;
  late MockLocalDatasource mockLocalDatasource;
  late MockNetworkInfo mockNetworkInfo;

  // Declare global test variables
  const tNumber = 1;
  const tNumberTriviaModel = NumberTriviaModel(
    text: 'Test text',
    number: tNumber,
  );
  registerFallbackValue(tNumberTriviaModel);

  const NumberTrivia tNumberTrivia = tNumberTriviaModel;

  setUp(() {
    mockRemoteDatasource = MockRemoteDatasource();
    mockLocalDatasource = MockLocalDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDatasource: mockRemoteDatasource,
      localDatasource: mockLocalDatasource,
      networkInfo: mockNetworkInfo,
    );

    when(() => mockLocalDatasource.cacheNumberTrivia(any()))
        .thenAnswer((_) => Future.value());
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => tNumberTriviaModel);
      // act
      repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should return remote data when the remote data call is successfull',
          () async {
        // arrange
        when(() => mockRemoteDatasource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        var result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
        expect(result, const Right(tNumberTrivia));
      });

      test(
          'should cache data locally when remote the remote data call is successfull',
          () async {
        // arrange
        when(() => mockRemoteDatasource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);

        // act
        await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return ServerFailure when the remote data call is unsuccessfull',
          () async {
        // arrange
        when(() => mockRemoteDatasource.getConcreteNumberTrivia(any()))
            .thenThrow(ServerException());
        // act
        var result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test('should return last locally cached data when data is present',
          () async {
        // arrange
        when(() => mockLocalDatasource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockRemoteDatasource);
        verify(() => mockLocalDatasource.getLastNumberTrivia());
        expect(result, const Right(tNumberTriviaModel));
      });

      test('should return [CacheFailure] when not data is present', () async {
        // arrange
        when(() => mockLocalDatasource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockRemoteDatasource);
        verify(() => mockLocalDatasource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      // act
      repository.getRandomNumberTrivia();
      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should return remote data when the remote data call is successfull',
          () async {
        // arrange
        when(() => mockRemoteDatasource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        var result = await repository.getRandomNumberTrivia();
        // assert
        verify(() => mockRemoteDatasource.getRandomNumberTrivia());
        expect(result, const Right(tNumberTrivia));
      });

      test(
          'should cache data locally when remote the remote data call is successfull',
          () async {
        // arrange
        when(() => mockRemoteDatasource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        // act
        await repository.getRandomNumberTrivia();
        // assert
        verify(() => mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return ServerFailure when the remote data call is unsuccessfull',
          () async {
        // arrange
        when(() => mockRemoteDatasource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        // act
        var result = await repository.getRandomNumberTrivia();
        // assert
        verify(() => mockRemoteDatasource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test('should return last locally cached data when data is present',
          () async {
        // arrange
        when(() => mockLocalDatasource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(mockRemoteDatasource);
        verify(() => mockLocalDatasource.getLastNumberTrivia());
        expect(result, const Right(tNumberTriviaModel));
      });

      test('should return [CacheFailure] when not data is present', () async {
        // arrange
        when(() => mockLocalDatasource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(mockRemoteDatasource);
        verify(() => mockLocalDatasource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });
}
