import 'package:dartz/dartz.dart';
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
      conreteUseCase: mockConcrete,
      randomUseCase: mockRandom,
      inputConverter: mockInputConv,
    );
  });

  test('initial state should be NumberTriviaInitial', () {
    // assert
    expect(bloc.state, NumberTriviaInitial());
  });

  group('getTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tConvertedNumber = 1;
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('sholud call the InputConverter', () async {
      // arrange
      when(() => mockInputConv.stringToUnsignedInteger(any()))
          .thenReturn(const Right(tConvertedNumber));
      // act
      bloc.add(const NumberTriviaConcreteNumberStarted(tNumberString));
      // we dont know when the bloc will react, so we use mocktail to wait
      // until called
      await untilCalled(() => mockInputConv.stringToUnsignedInteger(any()));
      // assert
      verify(() => mockInputConv.stringToUnsignedInteger(tNumberString));
    });
  });
}
