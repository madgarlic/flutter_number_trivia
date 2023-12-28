import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server failure!';
const String CACHE_FAILURE_MESSAGE = 'Cache failure!';
const String CONVERSION_FAILURE_MESSAGE = 'Converison failure!';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia conreteUseCase;
  final GetRandmoNumberTrivia randomUseCase;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.conreteUseCase,
    required this.randomUseCase,
    required this.inputConverter,
  }) : super(NumberTriviaInitial()) {
    on<NumberTriviaConcreteNumberStarted>((event, emit) {
      inputConverter.stringToUnsignedInteger(event.numberString);
    });
    on<NumberTriviaRandomNumberStarted>((event, emit) {
      // TODO: implement event handler
    });
  }
}
