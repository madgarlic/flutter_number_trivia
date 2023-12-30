import 'package:dartz/dartz.dart';
import 'package:flutter_number_trivia/core/error/failures.dart';
import 'package:flutter_number_trivia/core/usecases/usecase.dart';
import 'package:flutter_number_trivia/core/util/input_converter.dart';
import 'package:flutter_number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandmoNumberTrivia extends Mock implements GetRandmoNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockInputConverter mockInputConv;
  late MockGetConcreteNumberTrivia mockConcrete;
  late MockGetRandmoNumberTrivia mockRandom;

  setUp(() {
    mockInputConv = MockInputConverter();
    mockConcrete = MockGetConcreteNumberTrivia();
    mockRandom = MockGetRandmoNumberTrivia();

    bloc = NumberTriviaBloc(
      concreteUseCase: mockConcrete,
      randomUseCase: mockRandom,
      inputConverter: mockInputConv,
    );

    registerFallbackValue(const Params(number: 1));
    registerFallbackValue(NoParams());
  });

  test('initial state should be NumberTriviaInitial', () {
    // assert
    expect(bloc.state, NumberTriviaInitial());
  });

  group('getTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tConvertedNumber = 1;
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(() => mockInputConv.stringToUnsignedInteger(any()))
            .thenReturn(const Right(tConvertedNumber));
    test(
      'sholud call the InputConverter',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(() => mockConcrete(any()))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        bloc.add(const NumberTriviaConcreteNumberStarted(tNumberString));
        // we dont know when the bloc will react, so we use mocktail to wait
        // until called
        await untilCalled(() => mockInputConv.stringToUnsignedInteger(any()));
        // assert
        verify(() => mockInputConv.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'sholud emit [Failure] state when input is invalid',
      () async {
        // arrange
        when(() => mockInputConv.stringToUnsignedInteger(any()))
            .thenReturn(Left(InvalidInputFailure()));
        // assert leter
        final expected = [
          const NumberTriviaFailure(message: CONVERSION_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const NumberTriviaConcreteNumberStarted(tNumberString));
      },
    );

    test(
      'sholud get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(() => mockConcrete(any()))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        bloc.add(const NumberTriviaConcreteNumberStarted(tNumberString));
        await untilCalled(() => mockConcrete(any()));
        // assert
        verify(() => mockConcrete(const Params(number: tConvertedNumber)));
      },
    );

    test('sholud emit [Loading, Success] when data is loaded successfully', () {
      // arrange
      setUpMockInputConverterSuccess();
      when(() => mockConcrete(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // assert later
      final expected = [
        NumberTriviaLoading(),
        const NumberTriviaSuccess(trivia: tNumberTrivia)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const NumberTriviaConcreteNumberStarted(tNumberString));
    });

    test('sholud emit [Loading, Failure] when [GetConcreteNumberTrivia] fails',
        () {
      // arrange
      setUpMockInputConverterSuccess();
      when(() => mockConcrete(any()))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        NumberTriviaLoading(),
        const NumberTriviaFailure(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const NumberTriviaConcreteNumberStarted(tNumberString));
    });

    test(
        'sholud emit [Loading, Failure] with proper message when data loading fails',
        () {
      // arrange
      setUpMockInputConverterSuccess();
      when(() => mockConcrete(any()))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        NumberTriviaLoading(),
        const NumberTriviaFailure(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const NumberTriviaConcreteNumberStarted(tNumberString));
    });
  });

  group('getTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test(
      'sholud get data from the random use case',
      () async {
        // arrange
        when(() => mockRandom(any()))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        bloc.add(NumberTriviaRandomNumberStarted());
        await untilCalled(() => mockRandom(any()));
        // assert
        verify(() => mockRandom(NoParams()));
      },
    );

    test('sholud emit [Loading, Success] when data is loaded successfully', () {
      // arrange
      when(() => mockRandom(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // assert later
      final expected = [
        NumberTriviaLoading(),
        const NumberTriviaSuccess(trivia: tNumberTrivia)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(NumberTriviaRandomNumberStarted());
    });

    test('sholud emit [Loading, Failure] when [GetRandomNumberTrivia] fails',
        () {
      // arrange
      when(() => mockRandom(any()))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        NumberTriviaLoading(),
        const NumberTriviaFailure(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(NumberTriviaRandomNumberStarted());
    });

    test(
        'sholud emit [Loading, Failure] with proper message when data loading fails',
        () {
      // arrange
      when(() => mockRandom(any()))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        NumberTriviaLoading(),
        const NumberTriviaFailure(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(NumberTriviaRandomNumberStarted());
    });
  });
}
