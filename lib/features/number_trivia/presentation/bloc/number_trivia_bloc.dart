import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server failure!';
const String CACHE_FAILURE_MESSAGE = 'Cache failure!';
const String CONVERSION_FAILURE_MESSAGE =
    'Invalid input - The number should be a positive integer o zero!';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concreteUseCase;
  final GetRandmoNumberTrivia randomUseCase;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.concreteUseCase,
    required this.randomUseCase,
    required this.inputConverter,
  }) : super(NumberTriviaInitial()) {
    on<NumberTriviaConcreteNumberStarted>((event, emit) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      inputEither.fold(
        (failure) {
          emit(const NumberTriviaFailure(message: CONVERSION_FAILURE_MESSAGE));
        },
        (number) async {
          emit(NumberTriviaLoading());
          var failureOrTrivia = await concreteUseCase(Params(number: number));
          _eitherLoadedOrErrorState(failureOrTrivia, emit);
        },
      );
    });

    on<NumberTriviaRandomNumberStarted>((event, emit) async {
      emit(NumberTriviaLoading());
      var failureOrTrivia = await randomUseCase(NoParams());
      _eitherLoadedOrErrorState(failureOrTrivia, emit);
    });
  }

  void _eitherLoadedOrErrorState(Either<Failure, NumberTrivia> failureOrTrivia,
      Emitter<NumberTriviaState> emit) {
    failureOrTrivia.fold(
      (f) => emit(NumberTriviaFailure(message: _mapFailureToMessage(f))),
      (r) => emit(NumberTriviaSuccess(trivia: r)),
    );
  }

  String _mapFailureToMessage(Failure f) {
    switch (f.runtimeType) {
      case const (ServerFailure):
        return SERVER_FAILURE_MESSAGE;
      case const (CacheFailure):
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error!';
    }
  }
}
