part of 'number_trivia_bloc.dart';

sealed class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

final class NumberTriviaInitial extends NumberTriviaState {}

final class NumberTriviaLoading extends NumberTriviaState {}

final class NumberTriviaSuccess extends NumberTriviaState {
  final NumberTrivia trivia;

  @override
  List<Object> get props => [...super.props, trivia];

  const NumberTriviaSuccess({required this.trivia});
}

final class NumberTriviaFailure extends NumberTriviaState {
  final String message;

  @override
  List<Object> get props => [...super.props, message];

  const NumberTriviaFailure({required this.message});
}
